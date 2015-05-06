
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
    isel[i] = true

proc selectBlock*(isel: var IndexSelection, M: int, offset: int) =
  let possibleOffsets = isel.possibleOffsets(M)
  assert(offset >= possibleOffsets.min and offset <= possibleOffsets.max)
  for i in isel.indices:
    isel[i] = if i >= offset and i < offset+M: true else: false

proc selectRandomBlock*(isel: var IndexSelection, M: int) =
  let possibleOffsets = isel.possibleOffsets(M)
  let offset = random(possibleOffsets.max+1)
  isel.selectBlock(M, offset)



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
        
