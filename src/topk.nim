
import heap

type
  StoreTopK*[T] = object
    k: int
    h: Heap[T]


proc newStoreTopK*[T](k: int): StoreTopK[T] =
  StoreTopK[T](k: k, h: newHeap[T]())

proc add*[T](stk: var StoreTopK[T], x: T) =
  if stk.h.size < stk.k:
    stk.h.push(x)
  else:
    discard stk.h.pushPop(x)

iterator sortedItems*[T](stk: StoreTopK[T]): T =
  for x in stk.h.sortedItems:
    yield x


when isMainModule:

  import math
  import sequtils

  let N = 100
  var stk = newStoreTopK[float](5)
  
  for i in 1 .. 100:
    stk.add(random(1000.0))
    let values = toSeq(stk.sortedItems)
    echo values
    
