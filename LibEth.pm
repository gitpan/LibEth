package LibEth;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
#
#  Correct the below to where you will install LibEth.so and libeth.so.
#  If already in your load path then comment out altogether.
#
# $ENV{'LD_LIBRARY_PATH'} = '/home2/enh/HTML/cgi';
# $ENV{'LD_PRELOAD'} = '/usr/temp/libeth/play/LibEth/lib/libeth.so.0.3.3';
# $ENV{'LD_LIBRARY_PATH'} = '/usr/temp/libeth/play/LibEth/cgi';
$ENV{'LD_LIBRARY_PATH'} = '/home/web/htdocs/ENH/cgi';

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	LibEthVersion
	LibEthVersionName
	ConvertEthiopicString
	ConvertEthiopicFile
	ConvertEthiopicFileByLine
	ConvertEthiopicFileToString
	ArabToEthiopic
	isLeapYear
	isEthiopicLeapYear
	isEthiopianHoliday
	getEthiopicMonth
	getEthiopicDayOfWeek
	getEthiopicDayName
    isBogusEthiopicDate
    isBogusGregorianDate
	FixedToEthiopic
	EthiopicToFixed
	FixedToGregorian
	GregorianToFixed
    EthiopicToGregorian
    GregorianToEthiopic
);
$VERSION = '0.02';

bootstrap LibEth $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

LibEth - Perl extension for the Ethiopic information processing library.

=head1 SYNOPSIS

  use LibEth;

=head1 DESCRIPTION

LibEth.pm is an interface to the LibEth Ethiopic programmers library.

The GeezLib and GeezDate Perl modules were developed for CGI processing
of Ethiopic web pages under the Ethiopia Online domain.  The LibEth
module has been developed to improve performance of these two packages
by providing access to the LibEth library directly.  The three modules
may be more closely integrated in the forthcoming "Zobel" package.

Version 0.02 of the LibEth module is in fact broken with respect to 
existing GeezLib and GeezDates modules.  This will not be fixed (but
I<you> can do this trivially) as the two modules are being phased out.

There are versions of GeezLib.pm and GeezDates.pm included with the
LibEth C Library that do I<not> depend on LibEth.pm should you find them
useful.

=head1 STATUS

This is the second release of the LibEth module.  The interface to the
LibEth library is the very minimum required to replace (most) of the CPU
heavy subroutines in the GeezLib and GeezDate Perl modules used at
Ethiopia Online for web publishing.

=head1 BUGS

The "LibEthVersionName" routine fails on some machines.  Likely related to
a memory problem.

=head1 AUTHOR

Daniel Yacob,  L<LibEth@EthiopiaOnline.Net|mailto:LibEth@EthiopiaOnline.Net>

=head1 SEE ALSO

perl(1).  L<http://libeth.netpedia.net|http://libeth.netpedia.net>

=cut
