
import algorithm

type
  NotComparable = object

proc cmpByKey[K,V](x: (K,V), y: (K,V)): int = system.cmp(x[0], y[0])

proc sortByFirstTupleElement[K,V](data: seq[(K,V)]) =
  let compare = cmpByKey[K,V]
  sort[(K,V)](cmp: compare)

let data = @[(2, NotComparable()),
             (1, NotComparable()),
             (3, NotComparable())]

sortByFirstTupleElement[int, NotComparable](data)
