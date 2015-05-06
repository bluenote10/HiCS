
import dataset
import slicing
import hics
#import math

type
  KSTest* = object
    N: int
    preproData: PreproData


proc initKSTest*(ds: Dataset, preproData: PreproData): KSTest =
  # TODO: preproData.fitsTo(ds)
  KSTest(N: ds.nrows, preproData: preproData)


proc computeDeviation*(ks: KSTest, ds: Dataset, cmpAttr: int, selection: IndexSelection): float =

  let numRemainingObjects = selection.size
  
  var cumulatedDistOrig = 0.0
  var cumulatedDistTest = 0.0
  var maxDiscrepancy = -Inf

  assert(1.float == 1.toFloat)

  for i in 0 ..< ks.N:
    # i  is the rank-index w.r.t. the sorted cmpAttr
    # ii is the object-index of the corresponding pattern in the matrix and the used vector
    let ii = ks.preproData.indexMaps[cmpAttr][i]

    cumulatedDistOrig = (i+1).float / ks.N.float

    if selection[ii] == true:
      cumulatedDistTest += 1.0 / numRemainingObjects.float

    maxDiscrepancy = max(maxDiscrepancy, abs(cumulatedDistTest - cumulatedDistOrig))

  return maxDiscrepancy
