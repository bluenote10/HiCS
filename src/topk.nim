
import heap

type
  StoreTopK*[T] = object
    k: int
    h: Heap[T]


proc newStoreTopK*[T](k: int): StoreTopK[T] =
  StoreTopK[T](k: k, h: newHeap[T](system.cmp))



proc newTupleStoreTopK*[K,V](k: int, keepLarge: bool = true):
  StoreTopK[tuple[k: K,v: V]] = # looks like (K,V) does not work here
  ## generates a top-k store of type "key-value-tuple", where the
  ## top k elements are only determined w.r.t. the key of the tuple.
  proc cmpByKey[K,V](x: (K,V), y: (K,V)): int =
    # in order to keep "large" values we need a min-heap
    # where as "small" values require a max-heap.
    if keepLarge:
      system.cmp(x[0], y[0])
    else:
      system.cmp(y[0], x[0])
  StoreTopK[(K,V)](k: k, h: newHeap[(K,V)](cmpByKey[K,V]))


proc add*[T](stk: var StoreTopK[T], x: T) =
  if stk.h.size < stk.k:
    stk.h.push(x)
  else:
    discard stk.h.pushPop(x)

proc size*[T](stk: var StoreTopK[T]): int =
  return stk.h.size


iterator items*[T](stk: StoreTopK[T]): T =
  for x in stk.h.items:
    yield x

iterator sortedItems*[T](stk: StoreTopK[T]): T =
  var data = newSeq[T]()
  for x in stk.h.sortedItems:
    data.add x
  let dataRev = data.reverse
  for x in dataRev:
    yield x


when isMainModule:

  import math
  import sequtils
  import algorithm
  
  block:
    let N = 100
    var stk = newStoreTopK[float](5)

    for i in 1 .. 100:
      stk.add(random(1000.0))
      let values = toSeq(stk.sortedItems)
      #echo values


  block:

    type
      NotComparable = object
    
    var stk = newTupleStoreTopK[int, NotComparable](5, true)

    for i in 1 .. 20:
      stk.add((random(1000), NotComparable()))
      let values = toSeq(stk.sortedItems)
      echo values

