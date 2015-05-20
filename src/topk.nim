
import heap

type
  StoreTopK*[T] = object
    k: int
    h: Heap[T]


proc newStoreTopK*[T](k: int): StoreTopK[T] =
  StoreTopK[T](k: k, h: newHeap[T]())


#proc newTupleStoreTopK*[T](k: int): StoreTopK[T] =
#  proc tupleKeyCmp[TT](x: TT, y: TT): int {.procvar.} = system.cmp(x[0], y[0])
#  StoreTopK[T](k: k, h: newHeap[T](cmp: tupleKeyCmp))

#proc tupleKeyCmp[T: tuple](x: T, y: T): int {.procvar.} = system.cmp(x[0], y[0])

#proc tupleKeyCmp[K,V](x: tuple[k: K,v: V], y: tuple[k: K,v: V]): int {.procvar.} = system.cmp(x.k, y.k)
proc tupleKeyCmp[K,V](x: tuple[k: K,v: V], y: tuple[k: K,v: V]): int = system.cmp(x.k, y.k)

proc newTupleStoreTopK*[K,V](k: int): StoreTopK[tuple[k: K,v: V]] =
  #proc tupleKeyCmp[TT](x: TT, y: TT): int {.procvar.} = system.cmp(x[0], y[0])
  #StoreTopK[tuple[K,V]](k: k, h: newHeap[tuple[K,V]](cmp: tupleKeyCmp))

  #proc tupleKeyCmp(x: (K,V), y: (K,V)): int {.procvar.} = system.cmp(x[0], y[0])
  #proc tupleKeyCmp(x: tuple[k: K,v: V], y: tuple[k: K,v: V]): int {.procvar.} = system.cmp(x.k, y.k)

  #proc cmp()

  let h = Heap[tuple[k: K,v: V]](data: newSeq[tuple[k: K,v: V]](), size: 0, cmp: tupleKeyCmp[K,V])
  #proc cmpKey(x: K, y: K): int = system.cmp(x,y)
  
  #StoreTopK[tuple[k: K,v: V]](k: k, h: newTupleHeap[K, V](cmp: cmpKey))


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
  import algorithm
  
  block:
    let N = 100
    var stk = newStoreTopK[float](5)

    for i in 1 .. 100:
      stk.add(random(1000.0))
      let values = toSeq(stk.sortedItems)
      echo values


  block:

    type
      NotComparable = object
    
    var stk = newTupleStoreTopK[int, NotComparable](5)

    proc cmpByKey[K,V](x: (K,V), y: (K,V)): int = system.cmp(x[0], y[0])

    proc sortByFirstTupleElement[K,V](data: seq[(K,V)]) =
        #if x[0] <= y[0]:
        #  -1
        #else:
        #  1
      let comp = cmpByKey[K,V]
      echo comp.repr
      #sort[(K,V)](cmp: comp) #cmpByKey[K,V])

    let data = @[(2, NotComparable()), (1, NotComparable()), (3, NotComparable())]
    #echo data.repr
    sortByFirstTupleElement[int, NotComparable](data)
