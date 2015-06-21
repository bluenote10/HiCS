
import dataset
import preprocessing
import slicing
import utils

type
  KSTest* = object
    N: int
    M: int
    preproData: PreproData
    applyCalibration: bool
    expectedMinDev: float
    expectedMaxDev: float


proc computeDeviationFromSelfSelection(selection: IndexSelection): float =
  ## This function is used internally for the calibration of the KS test.
  ## It does almost the same as the final `computeDeviation` function,
  ## but does not operate on actual data. Instead is considers cases
  ## of "self selection", which only depend on N and M (obtained from the selection)
  ## and not on the data.
  var cumulatedDistOrig = 0.0
  var cumulatedDistTest = 0.0
  var maxDiscrepancy = -Inf

  let N = selection.len
  let M = selection.getM

  for i in 0 ..< N:

    cumulatedDistOrig = (i+1).float / N.float

    if selection[i] == true:
      cumulatedDistTest += 1.0 / M.float

    maxDiscrepancy = max(maxDiscrepancy, abs(cumulatedDistTest - cumulatedDistOrig))

  return maxDiscrepancy


proc determineExpectedMinDeviation(N: int, M: int, iterations: int): float =
  ## min deviation == case of fully independent selection
  var totalDev = 0.0
  var selection = newIndexSelection(N)
  for iter in 0 ..< iterations:
    selection.selectRandomly(M)
    let dev = computeDeviationFromSelfSelection(selection)
    totalDev += dev
  return totalDev / iterations


proc determineExpectedMaxDeviation(N: int, M: int): float =
  ## max deviation == case of fully dependent block selection
  var totalDev = 0.0
  var selection = newIndexSelection(N)
  let possibleOffsets = selection.possibleOffsets(M)
  for offset in possibleOffsets.min .. possibleOffsets.max:
    selection.selectBlock(M, offset)
    let dev = computeDeviationFromSelfSelection(selection)
    totalDev += dev
  return totalDev / possibleOffsets.numPossible



proc initKSTest*(
    ds: Dataset,
    preproData: PreproData,
    expectedSampleSize: int,
    applyCalibration = true,
    calibrationIterations = 100,
    verbose = false
  ): KSTest =
  let N = ds.nrows
  let M = expectedSampleSize
  assert(M > 0, "expectedSampleSize must be larger than zero.")
  assert(M < N, "expectedSampleSize must be smaller than the total sample size.")
  # TODO: preproData.fitsTo(ds)
  
  let expectedMinDev = determineExpectedMinDeviation(N, M, calibrationIterations)
  let expectedMaxDev = determineExpectedMaxDeviation(N, M)

  if verbose:
    echo ifmt"KS expectations:    min value = $expectedMinDev    max value = $expectedMaxDev"
  
  KSTest(N: N, M: M,
         preproData: preproData,
         applyCalibration: applyCalibration,
         expectedMinDev: expectedMinDev,
         expectedMaxDev: expectedMaxDev)



proc computeDeviation*(ks: KSTest, ds: Dataset, cmpAttr: int, selection: IndexSelection): float =

  let numRemainingObjects = selection.getM
  
  var cumulatedDistOrig = 0.0
  var cumulatedDistTest = 0.0
  var maxDiscrepancy = -Inf

  for i in 0 ..< ks.N:
    # i  is the rank-index w.r.t. the sorted cmpAttr
    # ii is the object-index of the corresponding pattern in the matrix and the used vector
    let ii = ks.preproData.indexMaps[cmpAttr][i]

    cumulatedDistOrig = (i+1).float / ks.N.float

    if selection[ii] == true:
      cumulatedDistTest += 1.0 / numRemainingObjects.float

    maxDiscrepancy = max(maxDiscrepancy, abs(cumulatedDistTest - cumulatedDistOrig))

  if not ks.applyCalibration:
    result = maxDiscrepancy
  else:
    result = (maxDiscrepancy - ks.expectedMinDev) / (ks.expectedMaxDev - ks.expectedMinDev)
  
