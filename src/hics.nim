
import dataset
import utils
import algorithm

type
  IndexMap = seq[int] not nil
  
  PreproData* = object

    indexMaps: seq[IndexMap] not nil



proc generatePreprocessingData*(ds: Dataset): PreproData =
  var indexMaps = newSeq[IndexMap](ds.ncols)

  for j in ds.colIndices:
    var col = ds.getCol(j)
    sort(col, system.cmp)

    debug j, col[0], col[^1]
    #let sorted = 

  result = PreproData(indexMaps: indexMaps)


