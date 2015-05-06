
when true:
  import utils
  import dataset
  import hics
  import slicing
  import subspace
  import stattest as module_stattest

  let ds = loadDataset("/tmp/data.csv")

  let preproData = ds.generatePreprocessingData()

  let params = initParameters(numIterations = 1000, alpha = 0.01)

  let statTest = initKSTest(ds, preproData)

  let contrast = computeContrast([0,1].toSubspace, ds, preproData, params, statTest)

  debug contrast

else:
  #import sequtils except toSeq
  import math
  var x = random(42).float
  
