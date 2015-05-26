import os
import utils
import dataset
import preprocessing
import testdata
import hics
import slicing
import subspace
import stattest as module_stattest
import typetraits
#import optionals

when false:
  #let ds = loadDataset("/tmp/data.csv")
  let ds = testData2DLinear(1000)
  let preproData = ds.generatePreprocessingData()
  let params = initParameters(numIterations = 100, alpha = 0.05)
  let statTest = initKSTest(ds, preproData, (params.alpha * ds.nrows).toInt)
  let contrast = computeContrast([0,1].toSubspace, ds, preproData, params, statTest)
  debug contrast

let args = commandLineParams()
debug args

const
  version = "0.9.0"

  usage = """
Usage:
  HiCS [options] CSV-IN-FILE

Required Parameters:
  INPUT-CSV-FILE                  CSV input data file.

Options:
  -h, --help                      Print this help message.
  -v, --version                   Print version information.
  -s, --silent                    Disables debug output on stdout.
"""



proc echoUsage(andQuit: bool = true) =
  echo usage
  if andQuit:
    quit 0
    
proc hasArg(checkEither: varargs[string]): bool =
  for s in checkEither:
    if s in args:
      return true
  return false


proc pairExtractor[T](name: string, default: T): T =
  for i in 0 .. args.len-2:
    if args[i] == name:
      let parse = parse[T](args[i+1])
      if parse.okay:
        return parse.value
      else:
        quit ifmt"Value for parameter $name cannot be cast to ${T.name} (value given was: ${args[i+1]})"
  #return default


# "Usage java -jar hics.jar [--numRuns <INT>] [--numCandidates <INT>] [--alpha <DOUBLE>] [--hasHeader] [--onlySubspsace <INT,INT,...>] [--csvOut <FILE>] --csvIn <FILE>")
# "Note: The list of INTs must not contain whitespace and indexing starts at zero, i.e.: 0,3,12,51")


if args.len == 0:
  echoUsage()

if hasArg("-h", "--help"):
  echo usage

if hasArg("-v", "--version"):
  echo "HiCS version ", version

let silent = hasArg("-s", "--silent")
let hasHeader = hasArg("--hasHeader")

let numRuns = pairExtractor("--numRuns", 100)
debug numRuns
