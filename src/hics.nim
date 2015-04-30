
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
    indexMaps: seq[IndexMap] not nil

  Parameters = object
    numIterations: int
    alpha: float
  


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



proc computeContrast*(ds: Dataset, subspace: Subspace, params: Parameters) =
  assert(ds.isValidSubspace(subspace))

  let D = ds.ncols
  let N = ds.nrows
  let M = (pow(params.alpha, 1 / (D-1)) * N.toFloat).toInt

  debug D, N, M

  for iter in 0 .. <params.numIterations:
    echo iter

#let N = 500
#let D = 10
#echo pow(0.1, 1 / D) * N.toFloat

#var s = @[1,2,3]
#echo s.map((x: int) => x+1)
#

