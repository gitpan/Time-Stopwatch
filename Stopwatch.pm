package Time::Stopwatch;
$VERSION = '0.03';

# POD documentation after __END__ below

use strict;
use constant HIRES => eval { require Time::HiRes };

sub TIESCALAR {
    my $pkg = shift;
    my $time = (HIRES ? Time::HiRes::time() : time()) - (@_ ? shift() : 0);
    bless \$time, $pkg;
}

sub FETCH { (HIRES ? Time::HiRes::time() : time()) - ${$_[0]}; }
sub STORE { ${$_[0]} = (HIRES ? Time::HiRes::time() : time()) - $_[1]; }

"That's all, folks!"
__END__

=head1 NAME

Time::Stopwatch - Use tied scalars as timers

=head1 SYNOPSIS

    use Time::Stopwatch;
    tie my $timer, 'Time::Stopwatch';

    do_something();
    print "Did something in $timer seconds.\n";

    my @times = map {
        $timer = 0;
        do_something_else();
        $timer;
    } 1 .. 5;

=head1 DESCRIPTION

The C<Time::Stopwatch> module provides a convenient interface to
timing functions through tied scalars.  From the point of view of the
user, scalars tied to the module simply increase their value by one
every second.

Using the module should mostly be obvious from the synopsis.  You can
provide an initial value for the timers either by assigning to them or
by passing the value as a third argument to tie().

If you have the module C<Time::HiRes> installed, the timers created by
C<Time::Stopwatch> will automatically count fractional seconds.  Do
I<not> assume that the values of the timers are always integers.  You
may test the constant C<Time::Stopwatch::HIRES> to find out whether
high resolution timing is enabled.

=head1 CHANGE LOG

=over 4

=item 0.03 (27 Feb 2001)

Modified tests to give more information, reduced subsecond accuracy
test to 1/10 seconds to allow for inaccurate select() implementations.
Tweaked synopsis and README.

=back

=head1 SEE ALSO

C<Time::HiRes>, tie()

=head1 AUTHORS

Copyright 2000-2001, Ilmari Karonen.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Address bug reports and comments to: perl@itz.pp.sci.fi

=cut
