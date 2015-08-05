## HiCS -- High Contrast Subspaces

Efficient multivariate correlation measure / high contrast subspace miner. 
This is an implementation of the HiCS algorithm presented in our [paper](http://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=0CCsQFjAB&url=http%3A%2F%2Fwww.ipd.uni-karlsruhe.de%2F~muellere%2Fpublications%2FICDE2012.pdf&ei=k5xwVaPDEKPMygOal4K4CQ&usg=AFQjCNEc2ejpiH48prTnAdL7GlqelTLsvA&sig2=5JkANoBp1L8zpoTQBgqfXQ&bvm=bv.94911696,d.bGQ):

_HiCS: High Contrast Subspaces for Density-Based Outlier Ranking._

Note: 
This is not the implementation used in the original publication. 
This implementation is currently work-in-progress.
The implementation does not include the outlier detection component, i.e., it implements only the subspace search step.


### Usage

HiCS can either be used as a Nim library or via a command line frontend.
For the convenience of Windows users I have prepared ready-to-use binaries of the command line frontend. 
There is both a [32 bit](bin/HiCS_x86.exe) and a [64 bit](bin/HiCS_x64.exe) version.

    Usage:
      HiCS [options] --csvIn <FILE>
    
    Options:
      --csvIn <FILE>                  File name of CSV input data (requires delimiter: ';')
      --csvOut <FILE>                 File name of subspace mining output data
      --hasHeader                     Specifies if input CSV has a header row
      --numRuns <INT>                 Number of Monte Carlo iterations to perform (default: 100)
      --numCandidates <INT>           Number of candidates in subspace beam search (default: 500)
      --maxOutputSpaces <INT>         Maximum number of subspaces in the final output (default: 1000)
      --alpha <DOUBLE>                Size of the test statistic specified as a fraction (default 0.1)
      --onlySubspsace <INT,INT,...>]  Using this command will not perform a subspace search.
                                      Instead, HiCS will only compute the contrast of the specified
                                      subspace. Note: The list of INTs must not contain whitespace and
                                      indexing starts at zero. For example: 0,3,12,51 
      -h, --help                      Print this help message.
      -v, --version                   Print version information.
      -s, --silent                    Disables debug output on stdout.



If you are running Linux, compiling from source should probably not be a big problem.


### Compiling from Source

In order to compile from source, you need Nim and its package manager Nimble.
The required steps are:

- Install Nim (ideally by cloning and building [the devel version of Nim](https://github.com/nim-lang/Nim) + adding the `nim` binary to your `PATH`)
- Install Nimble (ideally by cloning and building [Nimble](https://github.com/nim-lang/nimble) + adding the `nimble` binary to your `PATH`)
- Clone this repository and run `nimble build`



### Some Examples

![Figure](/../plots/plots/1Bit1.png?raw=true "Figure")

