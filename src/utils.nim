
import macros

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


template runUnitTest*(name: string, code: stmt): stmt {.immediate.} =
  when defined(testing):
    echo "Running Test: ", name
    block:
      code

template indices*(expr): expr = low(expr) .. high(expr)


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



proc sortBy*[T,S](accessor: proc (x: T): S): proc (a: T, b: T): int =
  result = proc (a: T, b: T): int =
    system.cmp(accessor(a), accessor(b))


