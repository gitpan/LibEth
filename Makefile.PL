use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'LibEth',
    'VERSION_FROM' => 'LibEth.pm', # finds $VERSION
#   'LIBS'	=> ['-L/path/to/libeth -lm -leth'],   # e.g., '-lm'
    'LIBS'	=> ['-lm -leth'],   # e.g., '-lm'
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
);
