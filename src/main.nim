
when true:
  import dataset
  import hics
  import slicing



  let ds = loadDataset("/tmp/data.csv")

  let preproData = ds.generatePreprocessingData()

else:
  import sequtils except toSeq
  
