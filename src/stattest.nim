
import dataset
import slicing
import hics
#import math

type
  KSTest* = object
    N: int
    M: int
    preproData: PreproData


proc initKSTest*(
    ds: Dataset,
    preproData: PreproData,
    expectedSampleSize: int,
    applyCalibration = true,
    calibrationIters = 100
  ): KSTest =
  let N = ds.nrows
  let M = expectedSampleSize
  assert(M > 0, "expectedSampleSize must be larger than zero.")
  assert(M < N, "expectedSampleSize must be smaller than the total sample size.")
  # TODO: preproData.fitsTo(ds)
  
  proc determineMinDeviation() =
    discard
  
  KSTest(N: N, M: M, preproData: preproData)




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
