#!/usr/bin/perl
package Screen;

use strict;
use warnings;

my @screens = ();
my $desktop;
my $cmd_xrandr = '/usr/bin/xrandr';
my $cmd_lock = '/usr/bin/xtrlock';
my $primary = 0;

sub primary_screen_number
{
    if( scalar @screens == 0 )
    {
        detect_screens()
    }
    return $primary;
}

sub detect_screens
{
    my $screen_count = 0;

    my @output = `$cmd_xrandr | grep " connected "`;
    chomp @output;

    undef @screens;
    @screens = ();

    foreach my $line ( @output )
    {
        if( $line =~ /\s(\d+)x(\d+)\+(\d+)\+(\d+)\s/ )
        {
            my ($w, $h, $x, $y) = ($1, $2, $3, $4);
            my $p = $line =~ /primary/ || 0;
            $primary = $primary || $p;

            push( @screens, {(
                n       => $screen_count++,
                w       => $w,
                h       => $h,
                x       => $x,
                y       => $y,
                primary => $p,
                name    => ($line =~ /^(\S+)\s/ ? $1 : 'unknown')
            )} );
        }
    }

    return @screens;
}

sub detect_desktop
{
    my @output = `$cmd_xrandr | grep " current "`;
    chomp @output;

    undef $desktop;

    foreach my $line ( @output )
    {
        if( $line =~ /current\s(\d+)\sx\s(\d+),/ )
        {
            my ($w, $h) = ($1, $2);
            $desktop = {(
                w => $w,
                h => $h
            )};
        }
    }

    return $desktop;
}

sub lock_screen
{
    my @output = `$cmd_lock & sleep 1s; /usr/bin/xset s activate`;
    return chomp @output;
}

sub set_primary_screen
{
    my $target = shift;

    my @output = `$cmd_xrandr --output $target --primary`;
    return chomp @output;
}

1;
