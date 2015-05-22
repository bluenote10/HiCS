
import sets
import hashes
import stringinterpolation

type
  MySet* = HashSet[int]

when true:
  proc hash*(s: HashSet[int]): THash =
    for it in items(s):
      result = result !& hash(it)
    result = !$result

  proc toMySet*(s: openarray[int]): MySet =
    s.toSet

  let s = [0,1,2,3,4].toMySet
  let setOfS = [s].toSet
  echo ifmt"$s, $setOfS, ${s in setOfS}"

when false:
  let s = [0,1,2,3,4].toSet
  let setOfS = [s].toSet
  echo ifmt"$s, $setOfS, ${s in setOfS}"

discard """
import algorithm

type
  NotComparable = object

proc cmpByKey[K,V](x: (K,V), y: (K,V)): int = system.cmp(x[0], y[0])

proc sortByFirstTupleElement[K,V](data: var seq[(K,V)]) =
  let compare = cmpByKey[K,V]
  sort[(K,V)](data, compare)

var data = @[(2, NotComparable()),
             (1, NotComparable()),
             (3, NotComparable())]

sortByFirstTupleElement[int, NotComparable](data)
"""

discard """
proc mycall[T](a: T, b: T, comp: proc (x: T, y: T): int = system.cmp): T =
  comp(a, b)

proc revCmp[T](x: T, y: T): int = system.cmp(y, x)

echo mycall(1, 2, system.cmp)
echo mycall(2, 1, system.cmp)
echo mycall(1, 2, revCmp[int])
echo mycall(2, 1, revCmp[int])
"""


#proc dummy() = echo "something"

#proc f(procvar: proc() = dummy) =
#  procvar()

#f(procvar: echo "I made a stupid mistake")

