
import parsecsv, streams, strutils
#import sequtils except toSeq
import sequtils
import subspace
import sugar
import sets
import strformat

type
  Vector* = seq[float] # not nil

  Dataset* = object
    data: seq[Vector] # not nil

proc newDataset*(): Dataset =
  Dataset(data: @[])

proc nrows*(ds: Dataset): int =
  ds.data.len

proc ncols*(ds: Dataset): int =
  if ds.data.len == 0:
    0
  else:
    ds.data[0].len

template colIndices*(ds: Dataset): untyped = 0 ..< ds.ncols

template rowIndices*(ds: Dataset): untyped = 0 ..< ds.nrows


proc `[]`*(ds: Dataset, i: int, j: int): float = ds.data[i][j]

proc `$`*(ds: Dataset): string = "Dataset(" & $ds.nrows & "x" & $ds.ncols & ")"

proc getRow*(ds: Dataset, i: int): Vector =
  result = newSeq[float](ds.ncols)
  for j in ds.colIndices:
    result[j] = ds[i,j]

proc getCol*(ds: Dataset, i: int): Vector =
  result = newSeq[float](ds.nrows)
  for j in ds.rowIndices:
    result[j] = ds[j,i]

proc isValidSubspace*(ds: Dataset, s: Subspace): bool =
  let subspaceSeq = s.asSeq # subspace.toSeq(s) #s.toSeq()
  let min = subspaceSeq.min
  let max = subspaceSeq.max
  result = min >= 0 and max < ds.ncols

proc appendRow*(ds: var Dataset, row: Vector) =
  if ds.data.len != 0:
    assert(ds.ncols == row.len)
  ds.data.add(row)

proc appendCol*(ds: var Dataset, col: Vector) =
  if ds.data.len != 0:
    assert(ds.nrows == col.len)
  else:
    ds.data = newSeq[seq[float]](col.len)
    for i in 0 ..< col.len:
      ds.data[i] = @[]
  for i in ds.rowIndices:
    ds.data[i].add(col[i])


proc rbind*(datasets: varargs[Dataset]): Dataset =
  let ncolsAll = datasets.map((d: Dataset) => d.ncols).toHashSet
  assert(ncolsAll.len == 1)
  result = newDataset()
  for ds in datasets:
    for row in ds.rowIndices:
      result.appendRow(ds.getRow(row))

proc cbind*(datasets: varargs[Dataset]): Dataset =
  let nrowsAll = datasets.map((d: Dataset) => d.nrows).toHashSet
  assert(nrowsAll.len == 1)
  result = newDataset()
  for ds in datasets:
    for col in ds.colIndices:
      result.appendCol(ds.getCol(col))





proc loadDataset*(filename: string, hasHeader = false, silent = false): Dataset =

  var s = newFileStream(filename, fmRead)

  if s == nil:
    quit(&"Error: Cannot open file '{filename}'")

  # simple heuristic to extract the separator
  var firstline = readLine(newFileStream(filename, fmRead))
  var sep = if firstline.count(",") > firstline.count(";"): ',' else: ';'

  var parser: CsvParser
  parser.open(s, filename, separator=sep)

  var lineNum = 1
  if hasHeader:
    discard parser.readRow()

  var ds = newDataset()

  while readRow(parser):
    try:
      let valuesOrig = toSeq(parser.row.items)
      let valuesPrsd = valuesOrig.map((s: string) => s.strip(true,true).parseFloat)

      ds.appendRow(valuesPrsd)

    except ValueError:
      if not silent:
        echo &"Warning: Could not parse CSV line number {lineNum}"
    lineNum += 1

  parser.close()
  result = ds


