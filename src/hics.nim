
import dataset
import subspace
import slicing
import utils
import algorithm
import math
import future

type
  IndexMap = seq[int] # not nil
  
  PreproData* = object
    indexMaps*: seq[IndexMap] not nil

  Parameters* = object
    numIterations*: int
    alpha*: float
  

proc initParameters*(numIterations: int = 100, alpha: float = 0.1): Parameters =
  Parameters(numIterations: numIterations, alpha: alpha)


proc generatePreprocessingData*(ds: Dataset): PreproData =
  var indexMaps = newSeq[IndexMap](ds.ncols)

  for j in ds.colIndices:
    var col = ds.getCol(j).zipWithIndex

    sort(col, sortBy((x: (int,float)) => x[1]))
    #sort(col, sortBy((x: tuple) => x[1]))
    #sort(col, sortBy[(int,float),float]((x) => x[1]))

    debug j, col[0], col[^1]
    #let sorted = 

    indexMaps[j] = col.map((x: (int,float)) => x[0])

  result = PreproData(indexMaps: indexMaps)



proc computeContrast*[T](subspace: Subspace, ds: Dataset, preproData: PreproData, params: Parameters, statTest: T): float =
  # various assertions
  assert(ds.isValidSubspace(subspace))
  assert(preproData.indexMaps.len == ds.ncols)
  for m in preproData.indexMaps:
    assert(m.len == ds.nrows)

  let D = ds.ncols
  let N = ds.nrows
  let M = (pow(params.alpha, 1 / (D-1)) * N.toFloat).toInt

  debug D, N, M

  var iselAll = newIndexSelection(N)
  var iselCur = newIndexSelection(N)

  var totalDev = 0.0

  for iter in 0 .. <params.numIterations:
    let cmpAttr = random(D)

    # reset all object-indices as "selected" (selection is destructive)
    iselAll.reset(true)

    for j in 0 ..< D:
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

#let N = 500
#let D = 10
#echo pow(0.1, 1 / D) * N.toFloat

#var s = @[1,2,3]
#echo s.map((x: int) => x+1)
#

