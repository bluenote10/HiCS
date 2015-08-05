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

If you are running Windows you can also install the latest stable version of Nim (which should also include Nimble).
I try to maintain this code in a way that it always compiles with both the latest stable and devel versions of Ni.m


### Bivariate Examples

Apart from its goal as a subspace search technique, HiCS can be seen as a multivariate correlation measure.
One of its most important features is that its "contrast notion" is defined consistently for variable sets of any cardinality >2, i.e., in general its focus is on the case of multivariate spaces.
However, it is also interesting to look at the simple, bivariate case to illustrate its properties.
The following example show typical bivarite relationships, including a comparison to other correlation analysis approaches: Pearson and Spearman correlation coefficients, Mutual Information (MI), and the Maximal Information Coefficient (MIC).

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;text-align:center}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;width:50%;text-align:center}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
</style>
<table class="tg">
  <tr>
    <td class="tg-031e"><img src="/../plots/plots/Linear1.png?raw=true" width="80%"></td>
    <td class="tg-031e"><img src="/../plots/plots/Linear2.png?raw=true" width="80%"></td>
  </tr>
  <tr>
    <td class="tg-031e"><img src="/../plots/plots/Linear3.png?raw=true" width="80%"></td>
    <td class="tg-031e"><img src="/../plots/plots/Linear4.png?raw=true" width="80%"></td>
  </tr>
  <tr>
    <td class="tg-031e"><img src="/../plots/plots/ParabolaHalf.png?raw=true" width="80%"></td>
    <td class="tg-031e"><img src="/../plots/plots/Cubic.png?raw=true" width="80%"></td>
  </tr>
  <tr>
    <td class="tg-031e"><img src="/../plots/plots/Exp1.png?raw=true" width="80%"></td>
    <td class="tg-031e"><img src="/../plots/plots/Exp2.png?raw=true" width="80%"></td>
  </tr>
  <tr>
    <td class="tg-031e"><img src="/../plots/plots/Log.png?raw=true" width="80%"></td>
    <td class="tg-031e"><img src="/../plots/plots/Sqrt.png?raw=true" width="80%"></td>
  </tr>
</table>
