
import dataset
import subspace
import slicing
import stattest
import preprocessing
import utils
import math
import future
import sets

type
  IndexMap = seq[int] # not nil
  

  Parameters* = object
    numIterations*: int
    alpha*: float
  

proc initParameters*(numIterations: int = 100, alpha: float = 0.1): Parameters =
  Parameters(numIterations: numIterations, alpha: alpha)





proc computeContrast*[T](subspace: Subspace, ds: Dataset, preproData: PreproData, params: Parameters, statTest: T): float =
  # various assertions
  assert(ds.isValidSubspace(subspace))
  assert(preproData.indexMaps.len == ds.ncols)
  for m in preproData.indexMaps:
    assert(m.len == ds.nrows)

  let D = subspace.len
  let N = ds.nrows
  let M = (pow(params.alpha, 1 / (D-1)) * N.toFloat).toInt

  debug D, N, M

  var iselAll = newIndexSelection(N)
  var iselCur = newIndexSelection(N)

  var totalDev = 0.0

  for iter in 0 .. <params.numIterations:
    let cmpAttr = subspace.randomDim

    # reset all object-indices as "selected" (selection is destructive)
    iselAll.reset(true)

    for j in subspace:
      if j != cmpAttr:
        iselCur.selectRandomBlock(M)
        assert(iselCur.size == M)
        # now convert from the rank-indices in dim j
        # to global object-indices and unselect them
        # if they are not part of the selection block
        for indRank, used in iselCur:
          if not used:
            let indObject = preproData.indexMaps[j][indRank]
            iselAll[indObject] = false
    
    let deviation: float = statTest.computeDeviation(ds, cmpAttr, iselAll)
    totalDev += deviation

    let numRemainingObjects = iselAll.size
    #debug iter, cmpAttr, deviation, numRemainingObjects

  return totalDev / params.numIterations.toFloat



proc hicsFramework*(ds: Dataset, params: Parameters) =

  let N = ds.nrows
  let D = ds.ncols

  let preproData = ds.generatePreprocessingData()
  let statTest = initKSTest(ds, preproData, (params.alpha * N).toInt)

  var subspaces = generate2DSubspaces(D)

  for s in subspaces:
    let contrast = computeContrast(s, ds, preproData, params, statTest)
    debug s, contrast



