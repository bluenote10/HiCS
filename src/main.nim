
when true:
  import utils
  import dataset
  import hics
  import slicing
  import subspace
  import stattest as module_stattest

  let ds = loadDataset("/tmp/data.csv")

  let preproData = ds.generatePreprocessingData()

  let params = initParameters(numIterations = 100, alpha = 0.05)

  let statTest = initKSTest(ds, preproData, (params.alpha * ds.nrows).toInt)

  let contrast = computeContrast([0,1].toSubspace, ds, preproData, params, statTest)

  debug contrast

else:
  #import sequtils except toSeq
  template testTemplate(b: bool): stmt =
    when b:
      var a = "hi"
    else:
      var a = 5
    echo a
    
  testTemplate(false)
  testTemplate(true)
  testTemplate(false)
  
