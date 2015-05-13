
import utils
import math

when defined(testing):
  import tables

#proc myNewSeq(N: int): var seq[bool] = newSeq[bool](N)
#proc myNewSeq(N: int): var bool = true

#template myNewSeq(N: int): var seq[bool] =
#  var s = newSeq[bool](N)
#  s

#echo myNewSeq(10).setlen(20)


type
  IndexSelection* = seq[bool]


proc size*(isel: IndexSelection): int =
  result = 0
  for b in isel:
    if b:
      result += 1


proc possibleOffsets*(isel: IndexSelection, M: int): tuple[min, max, numPossible: int] =
  let N = isel.len
  let numPossible = N - M + 1
  (0, numPossible-1, numPossible)


proc reset*(isel: var IndexSelection, default = false) =
  for i, x in isel:
    isel[i] = default


proc selectBlock*(isel: var IndexSelection, M: int, offset: int) =
  let possibleOffsets = isel.possibleOffsets(M)
  assert(offset >= possibleOffsets.min and offset <= possibleOffsets.max)
  for i in isel.indices:
    isel[i] = if i >= offset and i < offset+M: true else: false

proc selectRandomBlock*(isel: var IndexSelection, M: int) =
  let possibleOffsets = isel.possibleOffsets(M)
  let offset = random(possibleOffsets.max+1)
  isel.selectBlock(M, offset)

proc selectRandomly*(isel: var IndexSelection, M: int) =
  ## inspired by: Algorithm 3.4.2S of Knuth's book Seminumeric Algorithms
  ## http://stackoverflow.com/a/311716/1804173
  isel.reset(false)
  let N = isel.len
  var t = 0 # total input records dealt with
  var m = 0 # number of items selected so far

  while (m < M):
    let u = random(1.0) # call a uniform(0,1) random number generator

    #debug N, M, t, m, u, (N-t)*u, M-m
    
    # meaning of these terms:
    # (N - t) is the total number of remaining draws left (initially just N)
    # (M - m) is the number how many of these remaining draw must be positive (initially just M)
    # => Probability for next draw = (M-m) / (N-t)
    #
    # This is implemented by the inequality:
    # - the larger (M-m), the larger the probability of a positive draw
    # - for (N-t) == (M-m), the term on the left is always smaller => we will draw 100%
    # - for (N-t) >> (M-m), we must get a very small u
    #
    # example: (N-t) = 7, (M-m) = 5
    # => we draw the next with prob 5/7
    #    lets assume the draw fails
    # => t += 1 => (N-t) = 6
    # => we draw the next with prob 5/6
    #    lets assume the draw succeeds
    # => t += 1, m += 1 => (N-t) = 5, (M-m) = 4
    # => we draw the next with prob 4/5
    #    lets assume the draw fails
    # => t += 1 => (N-t) = 4
    # => we draw the next with prob 4/4, i.e.,
    #    we will draw with certainty from now on
    #    (in the next we get prob 3/3, 2/2, ...)
    if (N - t)*u >= (M - m).toFloat: # this is essentially a draw with P = (M-m) / (N-t)
      # no draw -- happens mainly for (N-t) >> (M-m) and/or high u
      t += 1
    else:
      # draw t -- happens when (M-m) gets large and/or low u
      isel[t] = true
      t += 1
      m += 1


proc newIndexSelection*(N: int, default = false): IndexSelection =
  result = newSeq[bool](N)
  if default == true:
    result.reset(true)
    

runUnitTest("IndexSelection.possibleOffsets"):
  let s = newIndexSelection(3)
  assert(s.size == 0)
  assert(s.possibleOffsets(1).numPossible == 3)
  assert(s.possibleOffsets(1).min == 0)
  assert(s.possibleOffsets(1).max == 2)
  assert(s.possibleOffsets(2).numPossible == 2)
  assert(s.possibleOffsets(2).min == 0)
  assert(s.possibleOffsets(2).max == 1)
  assert(s.possibleOffsets(3).numPossible == 1)
  assert(s.possibleOffsets(3).min == 0)
  assert(s.possibleOffsets(3).max == 0)

runUnitTest("IndexSelection.selectBlock"):
  var s = newIndexSelection(10)
  s.selectBlock(2, 5)
  assert(s.size == 2)
  s.selectBlock(3, 0)
  assert(s.size == 3)
  s.selectBlock(4, 6)
  assert(s.size == 4)

runUnitTest("IndexSelection.selectRandomBlock"):
  for N in 2..10:
    for M in 1..N:
      var counts = initCountTable[int]()
      for iteration in 0..<100:
        var s = newIndexSelection(N)
        s.selectRandomBlock(M)
        for i, b in s:
          if b:
            counts.inc(i)
        assert(s.size == M)
      #debug N, M, counts
        
runUnitTest("IndexSelection.selectRandomly"):
  randomize()
  let N = 3
  let M = 2
  let iterations = 1000
  var probs = newSeq[float](N)
  for iter in 0..<iterations:
    var s = newIndexSelection(N)
    s.selectRandomly(M)
    for i, b in s:
      if b:
        probs[i] += 1
  for i, p in probs:
    probs[i] /= iterations.toFloat
  

