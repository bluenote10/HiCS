
import macros
import sequtils
import stringinterpolation

export ifmt, format, formatUnsafe
#import tables

macro debug*(n: varargs[expr]): stmt =
  # `n` is a Nim AST that contains the whole macro invocation
  # this macro returns a list of statements:
  result = newNimNode(nnkStmtList, n)
  # iterate over any argument that is passed to this macro:
  for i in 0..n.len-1:
    # add a call to the statement list that writes the expression;
    # `toStrLit` converts an AST to its string representation:
    add(result, newCall("write", newIdentNode("stdout"), toStrLit(n[i])))
    # add a call to the statement list that writes ": "
    add(result, newCall("write", newIdentNode("stdout"), newStrLitNode(": ")))
    # add a call to the statement list that writes the expressions value:
    #add(result, newCall("writeln", newIdentNode("stdout"), n[i]))
    add(result, newCall("write", newIdentNode("stdout"), n[i]))
    # separate by ", "
    if i != n.len-1:
      add(result, newCall("write", newIdentNode("stdout"), newStrLitNode(", ")))

  # add new line
  add(result, newCall("writeln", newIdentNode("stdout"), newStrLitNode("")))


proc `*`*(x: float, y: int): float = x * y.toFloat
proc `*`*(x: int, y: float): float = x.toFloat * y
proc `/`*(x: float, y: int): float = x / y.toFloat
proc `/`*(x: int, y: float): float = x.toFloat / y


template runUnitTest*(name: string, code: stmt): stmt {.immediate.} =
  when defined(testing):
    echo "Running Test: ", name
    block:
      code

template UnitTests*(name: string, code: stmt): stmt {.immediate.} =
  when defined(testing):
    import unittest
    suite(name):
      code


template indices*(expr): expr = low(expr) .. high(expr)

when false:
  proc reverse*[T](iter: iterator: T): iterator (): T =
    var data = newSeq[T]()
    for x in iter():
      data.add x
    iterator rev(): T =
      for x in data:
        yield x

proc reverse*[T](s: seq[T]): seq[T] =
  result = newSeq[T](s.len)
  for i,x in s:
    result[^(i+1)] = x


proc zipWithIndex*[T](s: seq[T]): seq[tuple[index: int, value: T]] =
  result = newSeq[(int, T)](s.len)
  for i, x in s:
    result[i] = (i, x)

runUnitTest("zipWithIndex"):
  let s1 = @["a", "b", "c"]
  let s2 = s1.zipWithIndex()
  assert(s2[0].index == 0)
  assert(s2[0].value == "a")
  assert(s2[1].index == 1)
  assert(s2[1].value == "b")
  assert(s2[2].index == 2)
  assert(s2[2].value == "c")



#proc mgetDefault[A, B](t: var Table[A, B]; key: A): var B =

template ijForLoop*(N: int, s: stmt): stmt {.immediate.} =
  for ii in 0 ..< N-1:
    for jj in ii+1 .. <N:
      let i {.inject.} = ii
      let j {.inject.} = jj
      s

runUnitTest("ijForLoop"):
  for N in 0 .. 10:
    var c = 0
    ijForLoop(N):
      assert(i < j)
      c += 1
    assert(c == N*(N-1) div 2)


proc sortBy*[T,S](accessor: proc (x: T): S): proc (a: T, b: T): int =
  result = proc (a: T, b: T): int =
    system.cmp(accessor(a), accessor(b))


