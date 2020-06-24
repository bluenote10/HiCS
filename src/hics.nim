
import dataset
import subspace
import slicing
import stattest
import preprocessing
import utils
import math
import sugar
import sets
import topk
import strformat

type
  IndexMap = seq[int] # not nil

  Parameters* = object
    numIterations*: int
    alpha*: float
    numCandidates*: int
    maxOutputSpaces*: int


proc initParameters*(
    numIterations = 100,
    alpha = 0.1,
    numCandidates = 500,
    maxOutputSpaces = 1000,
  ): Parameters =
  Parameters(
    numIterations: numIterations,
    alpha: alpha,
    numCandidates: numCandidates,
    maxOutputSpaces: maxOutputSpaces
  )



proc computeContrast*[T](subspace: Subspace, ds: Dataset, preproData: PreproData, params: Parameters, statTest: T): float =
  # various assertions
  assert(ds.isValidSubspace(subspace))
  assert(preproData.indexMaps.len == ds.ncols)
  for m in preproData.indexMaps:
    assert(m.len == ds.nrows)

  let D = subspace.len
  let N = ds.nrows
  let M = (pow(params.alpha, 1 / (D-1)) * N.toFloat).toInt

  #debug D, N, M

  var iselAll = newIndexSelection(N)
  var iselCur = newIndexSelection(N)

  var totalDev = 0.0

  for iter in 0 ..< params.numIterations:
    let cmpAttr = subspace.randomDim

    # reset all object-indices as "selected" (selection is destructive)
    iselAll.reset(true)

    for j in subspace:
      if j != cmpAttr:
        iselCur.selectRandomBlock(M)
        assert(iselCur.getM == M)
        # now convert from the rank-indices in dim j
        # to global object-indices and unselect them
        # if they are not part of the selection block
        for indRank, used in iselCur:
          if not used:
            let indObject = preproData.indexMaps[j][indRank]
            iselAll[indObject] = false

    let deviation: float = statTest.computeDeviation(ds, cmpAttr, iselAll)
    totalDev += deviation

    let numRemainingObjects = iselAll.getM
    #debug iter, cmpAttr, deviation, numRemainingObjects

  return totalDev / params.numIterations.toFloat



proc hicsFramework*(ds: Dataset, params: Parameters, verbose = false): StoreTopK[(float, Subspace)] =

  let N = ds.nrows
  let D = ds.ncols

  let preproData = ds.generatePreprocessingData()
  let statTest = initKSTest(ds, preproData, (params.alpha * N).toInt, verbose)

  var outputSpaces = newTupleStoreTopK[float,Subspace](params.maxOutputSpaces, keepLarge=true)

  # variables representing the current state
  var d = 2
  var spaces = generate2DSubspaces(D)

  while spaces.len > 0:
    if verbose: echo &" * processing subspaces of dim {d} [number of spaces: {spaces.len}]"

    # initialize the limited store of subspaces used for apriori merging
    var spacesForAprioriMerge = newTupleStoreTopK[float,Subspace](params.numCandidates, keepLarge=true)

    # iterate over current spaces, determine their contrast,
    # and add them to the apriori-merge-spaces and the output-spaces.
    for s in spaces:
      let contrast = computeContrast(s, ds, preproData, params, statTest)
      if verbose: debug s, contrast
      spacesForAprioriMerge.add((contrast, s))
      outputSpaces.add((contrast, s))

    # for the apriori merge we have to convert spacesForAprioriMerge
    # from StoreTopK (i.e. a heap) into a SubspaceSet (a set)
    var candidateSet = newSubspaceSet()
    for contrast, subspace in spacesForAprioriMerge.items:
      candidateSet.incl(subspace)
    assert candidateSet.len == spacesForAprioriMerge.size

    # replace the current spaces by the result of an apriori merge of the candidates
    let oldNumSpaces = spaces.len
    spaces = candidateSet.aprioriMerge
    for s in spaces:
      assert s.dimensionality == d+1
    if verbose:
      let info = if oldNumSpaces <= params.numCandidates:
          &"using all spaces; number of {d}-dim spaces: {oldNumSpaces} <= numCandidates: {params.numCandidates}"
        else:
          &"number $d-dim spaces [{oldNumSpaces}] exceeds numCandidates [{params.numCandidates}] => limiting to top {params.numCandidates}]"
      echo &" => number of merged 3-dim spaces: {spaces.len} ({info})"

    inc d

  #for contrast, subspace in outputSpaces.sortedItems:
  #  echo contrast, subspace

  result = outputSpaces
