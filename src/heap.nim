
import math
import utils

proc parentInd(i: int): int = (i-1) div 2
proc childLInd(i: int): int = 2*i + 1
proc childRInd(i: int): int = 2*i + 2


type
  HeapObj[T] = object
    data: seq[T]

  Heap[T] = object #ref HeapObj[T]
    data: seq[T]
    size: int
    cmp: proc (x: T, y: T): int # byte?


proc newHeap[T](): Heap[T] =
  Heap[T](data: newSeq[T](), size: 0, cmp: system.cmp)


proc size*[T](h: Heap[T]): int = h.size


proc hasIndex*[T](h: Heap[T], i: int): bool =
  0 <= i and i < h.size

proc hasChildAt*[T](h: Heap[T], i: int): bool =
  i < h.size

proc hasParentAt*[T](h: Heap[T], i: int): bool =
  0 <= i


proc indicesWithChildren*[T](h: Heap[T]): Slice[int] =
  let lastIndexWithChildren = (h.size div 2) - 1
  0 .. lastIndexWithChildren

#proc isLower
proc propFulfilled[T](h: Heap[T], indParent, indChild: int): bool =
  h.cmp(h.data[indParent], h.data[indChild]) <= 0

proc checkHeapProperty[T](h: Heap[T]): bool =
  for i in h.indicesWithChildren:
    # note: we only know that i has a left child
    # the right child is optional and required check
    let j = childLInd(i)
    let k = childRInd(i)
    #echo i, j, k
    if not h.propFulfilled(i, j):
      return false
    if h.hasChildAt(k) and not h.propFulfilled(i, k):
      return false
  return true


proc swap[T](h: var Heap[T], i, j: int) =
  let t = h.data[j]
  h.data[j] = h.data[i]
  h.data[i] = t
  echo "swapping ", i, " with ", j


proc siftup[T](h: var Heap[T], i: int) =
  let j = i.parentInd
  if h.hasParentAt(j) and not h.propFulfilled(j,i):
    h.swap(i,j)
    h.siftup(j)
  
proc siftdown[T](h: var Heap[T], i: int) =
  # This is nonsense:
  # we siftdown to the left first, and then again to the right
  # if two child: pick best and you're done...
  discard """
  let j = i.childLInd
  if h.hasChildAt(j) and not h.propFulfilled(i,j):
    h.swap(i,j)
    h.siftdown(j)
  let k = i.childRInd
  if h.hasChildAt(k) and not h.propFulfilled(i,k):
    h.swap(i,k)
    h.siftdown(k)
  """
  let j = i.childLInd
  let k = i.childRInd
  if h.hasChildAt(j) and h.hasChildAt(k): # most often we have two, this should be checked first:
    # take min/max
    if not h.propFulfilled(i,j) or not h.propFulfilled(i,j):
      if h.propFulfilled(j,k):
        h.swap(i,j)
        h.siftdown(j)
      else:
        h.swap(i,k)
        h.siftdown(k)
  elif h.hasChildAt(j):
    if not h.propFulfilled(i,j):
      h.swap(i,j)
      h.siftdown(j)
  else:
    discard
    
  if h.hasChildAt(j) and not h.propFulfilled(i,j):
    h.swap(i,j)
    h.siftdown(j)
  if h.hasChildAt(k) and not h.propFulfilled(i,k):
    h.swap(i,k)
    h.siftdown(k)


proc push[T](h: var Heap[T], x: T) =
  h.data.add(x)
  h.siftup(h.size)
  h.size.inc
  assert h.checkHeapProperty

proc pop[T](h: var Heap[T]): T =
  # store root for return
  result = h.data[0]
  
  # make last node the new root
  h.data[0] = h.data[^1] # TODO handle root == last

  # handle size modification
  h.size.dec
  h.data.setlen(h.size)

  # restore heap property
  h.siftdown(0)

  assert h.checkHeapProperty

  


when isMainModule:
  import unittest

  suite "Heap":

    test "Relation parent/child":
      assert childLInd(0) == 1
      assert childRInd(0) == 2
      assert parentInd(1) == 0
      assert parentInd(2) == 0

    test "indicesWithChildren":

      randomize(0)
      let N = 100
      var h = newHeap[int]()
      for i in 1..N:
        h.push(random(100))
        debug i, h.data
      for i in 1..N:
        let x = h.pop
        debug i, h.data, x
      debug h.indicesWithChildren
      echo h.checkHeapProperty





