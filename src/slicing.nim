
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
  IndexBlock = seq[bool]

proc newIndexBlock(N: int): IndexBlock =
  newSeq[bool](N)

#template newIndexBlock(N: int): expr =
#  var s: IndexBlock = newSeq[bool](N)
#  s

proc size(iblock: IndexBlock): int =
  result = 0
  for b in iblock:
    if b:
      result += 1

proc possibleOffsets(iblock: IndexBlock, M: int): tuple[min, max, numPossible: int] =
  let N = iblock.len
  let numPossible = N - M + 1
  (0, numPossible-1, numPossible)


proc selectBlock(iblock: var IndexBlock, M: int, offset: int) =
  let possibleOffsets = iblock.possibleOffsets(M)
  assert(offset >= possibleOffsets.min and offset <= possibleOffsets.max)
  for i in iblock.indices:
    iblock[i] = if i >= offset and i < offset+M: true else: false

proc selectRandomBlock(iblock: var IndexBlock, M: int) =
  let possibleOffsets = iblock.possibleOffsets(M)
  let offset = random(possibleOffsets.max+1)
  iblock.selectBlock(M, offset)
  

runUnitTest("IndexBlock.possibleOffsets"):
  let s = newIndexBlock(3)
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

runUnitTest("IndexBlock.selectBlock"):
  var s = newIndexBlock(10)
  s.selectBlock(2, 5)
  assert(s.size == 2)
  s.selectBlock(3, 0)
  assert(s.size == 3)
  s.selectBlock(4, 6)
  assert(s.size == 4)

runUnitTest("IndexBlock.selectRandomBlock"):
  for N in 2..10:
    for M in 1..N:
      var counts = initCountTable[int]()
      for iteration in 0..<100:
        var s = newIndexBlock(N)
        s.selectRandomBlock(M)
        for i, b in s:
          if b:
            counts.inc(i)
        assert(s.size == M)
      #debug N, M, counts
        
