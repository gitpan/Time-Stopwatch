# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..8\n"; }
END {print "not ok 1\n" unless $loaded;}
use Time::Stopwatch;
$loaded = 1;
print <<"NOTE" unless Time::Stopwatch::HIRES;

 ! As Time::HiRes could not be loaded, resolution will be !
 ! limited to one second.  Some tests will be skipped.    !

NOTE
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

# Does the timer work at all?
test2: {
    tie my $timer, 'Time::Stopwatch';
    my $start = $timer;
    sleep(1);
    print $start < $timer ? "ok" : "not ok", " 2\n";
};

# Can we supply an initial value?
test3: {
    tie my $timer, 'Time::Stopwatch', 32;
    print $timer >= 32 ? "ok" : "not ok", " 3\n";
};

# How about assignment?
test4: {
    tie my $timer, 'Time::Stopwatch';
    $timer = 64;
    print $timer >= 64 ? "ok" : "not ok", " 4\n";
};

# Are fractional times preserved?
test5: {
    tie my $timer, 'Time::Stopwatch', 2.5;
    print $timer != int($timer) ? "ok" : "not ok", " 5\n";
};

# Can we do real fractional timing?
test6: {
    print "ok 6\t# skipped, no Time::HiRes\n"
	and next unless Time::Stopwatch::HIRES;
    tie my $timer, 'Time::Stopwatch', 1;
    select(undef,undef,undef,0.25);
    print $timer != int($timer) ? "ok" : "not ok", " 6\n";
};

# Is it accurate to one second?
test7: {
    tie my $timer, 'Time::Stopwatch', 2;
    sleep(2);
    print int($timer+.5) == 4 ? "ok" : "not ok", " 7\n";
};

# Is it accurate to 1/100 seconds?
test8: {
    print "ok 8\t# skipped, no Time::HiRes\n"
        and next unless Time::Stopwatch::HIRES;
    tie my $timer, 'Time::Stopwatch';
    select(undef,undef,undef,1.28);
    print int(100*$timer+.5) == 128 ? "ok" : "not ok", " 8\n";
};

__END__


