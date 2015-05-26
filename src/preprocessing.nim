import dataset
import utils
import algorithm
import future

type
  IndexMap = seq[int] # not nil
  
  PreproData* = object
    indexMaps*: seq[IndexMap] not nil


proc generatePreprocessingData*(ds: Dataset): PreproData =
  var indexMaps = newSeq[IndexMap](ds.ncols)

  for j in ds.colIndices:
    var col = ds.getCol(j).zipWithIndex

    sort(col, sortBy((x: (int,float)) => x[1]))
    #sort(col, sortBy((x: tuple) => x[1]))
    #sort(col, sortBy[(int,float),float]((x) => x[1]))

    #debug j, col[0], col[^1]

    indexMaps[j] = col.map((x: (int,float)) => x[0])

  result = PreproData(indexMaps: indexMaps)


