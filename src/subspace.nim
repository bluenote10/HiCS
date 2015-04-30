
import sets
import sequtils

type
  Subspace* = HashSet[int]


proc toSequence*(s: Subspace): seq[int] =
  result = sequtils.toSeq(items(s))

