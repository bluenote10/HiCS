
import dataset
import hics
import math
import utils

proc testData2DLinear*(N: int, slope = 1.0): Dataset =
  result = newDataset()
  for i in 0 ..< N:
    let x = random(1.0)
    let y = slope * x
    result.appendRow(@[x, y])



proc randomSubspacePartition(D, maxSubspaceDim: int): seq[int] =
  result = @[]
  while result.sum < D:
    let remaining = D - result.sum
    let maxRand = min(remaining, maxSubspaceDim)
    let rand = random(maxRand) + 1
    result.add(rand)
  assert(result.sum == D)

proc generatorMultivariateLinear(N, D: int): Dataset =
  result = newDataset()
  for i in 0 ..< N:
    let x = random(1.0)
    var s = newSeq[float](D)
    for i, e in s: s[i] = x
    result.appendRow(s)
  
proc testDataHighDim(N, D, maxSubspaceDim: int, generator: proc (d: int): Dataset): (Dataset, seq[int]) =
  let subspaceDims = randomSubspacePartition(D, maxSubspaceDim)

  var datasets: seq[Dataset] = @[]

  for subspaceDim in subspaceDims:
    let data = generator(subspaceDim)
    datasets.add(data)

  result = (cbind(datasets), subspaceDims)



UnitTests("testdata"):

  test("generatorMultivariateLinear"):

    randomize(0)
    let N = 1000
    proc gen(d: int): Dataset = generatorMultivariateLinear(N, d)

    let (data, subspaces) = testDataHighDim(N, 5, 3, gen)
    # debug data, subspaces

    let params = initParameters(100, 0.1, numCandidates=4)

    let result = hicsFramework(data, params, verbose=false)

  




