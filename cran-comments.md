## Test environments
* Windows 10, R-devel (local), R-release (R 4.0.2) (local),
* Linux, Ubuntu 16.04 (on travis-ci) R-release, Debian, R-devel
* OS X 9.4 (on travis-ci), R-release

## R CMD check results

- R-devel, R-release (R 4.0.2) : There were no ERRORs, WARNINGs.

2 NOTEs,

  * checking for hidden files and directories ... NOTE
    Found the following hidden files and directories:
    .travis.yml
    These were most likely included in error. See section 'Package
    structure' in the 'Writing R Extensions' manual.

  * checking top-level files ... NOTE
    Non-standard file/directory found at top level:
      'cran-comments.md'


## rhub

- Windows Server 2008 R2 SP1, R-devel, 32/64 bit
- Ubuntu Linux 16.04 LTS, R-release, GCC
- Fedora Linux, R-devel, clang, gfortran
- Ubuntu Linux 16.04 LTS, R-devel, GCC

  * checking for hidden files and directories ... NOTE
    Found the following hidden files and directories:
    .travis.yml
    These were most likely included in error. See section 'Package
    structure' in the 'Writing R Extensions' manual.
      
  * checking top-level files ... NOTE
    Non-standard file/directory found at top level:
    'cran-comments.md'

- Fedora Linux, R-devel, clang, gfortran
- Ubuntu Linux 16.04 LTS, R-devel, GCC

  * checking examples ... NOTE
    Examples with CPU (user + system) or elapsed time > 5s
            user system elapsed
    Spread 1.887  0.072   7.766

