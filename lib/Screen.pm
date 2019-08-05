#!/usr/bin/perl
package Screen;

use strict;
use warnings;

my @screens = ();
my $cmd_lock = '/usr/bin/xtrlock';

sub detect_screens
{
    my $screen_count = 0;

    my @output = `/usr/bin/xrandr | grep " connected "`;
    chomp @output;

    undef @screens;
    @screens = ();

    foreach my $line ( @output )
    {
        if( $line =~ /\s(\d+)x(\d+)\+(\d+)\+(\d+)\s/ )
        {
            my ($w, $h, $x, $y) = ($1, $2, $3, $4);

            push( @screens, {(
                n       => $screen_count++,
                w       => $w,
                h       => $h,
                x       => $x,
                y       => $y,
                primary => $line =~ /primary/ || 0,
                name    => ($line =~ /^(\S+)\s/ ? $1 : 'unknown')
            )} );
        }
    }

    return @screens;
}

sub lock_screen
{
    my @output = `$cmd_lock & sleep 1s; /usr/bin/xset s activate`;
    return chomp @output;
}

sub set_primary_screen
{
    my $target = shift;

    my @output = `/usr/bin/xrandr --output $target --primary`;
    return chomp @output;
}

1;
