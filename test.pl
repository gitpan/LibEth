# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..8\n"; }
END {print "not ok 1\n" unless $loaded;}
use LibEth;
$loaded = 1;
print "ok 1  It loaded.\n";
printf "ok 2  %f\n", &LibEth::LibEthVersion;
printf "ok 3  %s\n", &LibEth::LibEthVersionName;
printf "ok 4  %s\n", &LibEth::ArabToEthiopic ("1991", 59, 3, 0, "/f");
printf "ok 5  %s\n", &LibEth::ConvertEthiopicString ("beqa! y`seral...", 57, 0, 59, 3, 0, $amh, "/f", 1);
open (TESTLE, "Hello.sera") || die ("!: Can't Open Hello.sera!\n");
$recycle   = 0;
$setId     = -1;
$nestLevel = 0;
$TagOn     = 0;
printf "ok 6  %s\n", &LibEth::ConvertEthiopicFileByLine (\*TESTLE, 57, 0, 59, 3, 0, $amh, "/f", 0, $setId, $nestLevel, $TagOn, $recycle);
close (TESTLE);
open (TESTLE, "Hello.sera") || die ("!: Can't Open Hello.sera!\n");
print "ok 7 (text above is ok)\n", &LibEth::ConvertEthiopicFile (\*TESTLE, 57, 0, 59, 3, 0, $amh, "/f", 0), "\n";
close (TESTLE);
open (TESTLE, "Hello.sera") || die ("!: Can't Open Hello.sera!\n");
printf "ok 8  %s\n", &LibEth::ConvertEthiopicFileToString (\*TESTLE, 57, 0, 59, 3, 0, $amh, "/f", 0);
close (TESTLE);

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

