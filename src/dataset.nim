
import os, parsecsv, streams, future, sequtils, strutils
import utils

type
  Vector* = seq[float] # not nil

  Dataset* = object
    data: seq[Vector] not nil

proc newDataset(): Dataset =
  Dataset(data: @[])

proc nrows*(ds: Dataset): int =
  ds.data.len

proc ncols*(ds: Dataset): int =
  if ds.data.len == 0:
    0
  else:
    ds.data[0].len

template colIndices*(ds: Dataset): expr = 0 .. <ds.ncols

template rowIndices*(ds: Dataset): expr = 0 .. <ds.nrows


proc `[]`*(ds: Dataset, i: int, j: int): float = ds.data[i][j]

proc getRow*(ds: Dataset, i: int): Vector =
  result = newSeq[float](ds.ncols)
  for j in ds.colIndices:
    result[j] = ds[i,j]

proc getCol*(ds: Dataset, i: int): Vector =
  result = newSeq[float](ds.nrows)
  for j in ds.rowIndices:
    result[j] = ds[j,i]
    


proc appendRow*(ds: var Dataset, row: Vector) =
  if ds.data.len == 0:
    ds.data.add(row)
  else:
    assert(ds.ncols == row.len)
    ds.data.add(row)
    





proc loadDataset*(filename: string, hasHeader = false): Dataset =

  var s = newFileStream(filename, fmRead)

  if s == nil:
    quit("Error -- cannot open the file: " & filename)

  var parser: CsvParser
  parser.open(s, filename, separator=';')

  if hasHeader:
    discard parser.readRow()

  var ds = newDataset()

  while readRow(parser):
    try:
      let valuesOrig = toSeq(parser.row.items)
      let valuesPrsd = valuesOrig.map(proc (s: string): float = s.parseFloat)

      ds.appendRow(valuesPrsd)
    except ValueError:
      discard

  parser.close()

  result = ds
