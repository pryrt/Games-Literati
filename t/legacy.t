#!/usr/bin/perl
########################################################################
# misc.t:
#   v0.042: add reduce_hand() to miscFunctions
#       make sure that it will shrink the hand_tile string
########################################################################

use 5.008;

use warnings;
use strict;
use Test::More; # tests => 3;

use IO::String;
use File::Basename qw/dirname/;
use Cwd qw/abs_path chdir/;
BEGIN: { chdir(dirname($0)); }

use Games::Literati 0.042 qw/:infoFunctions/;

# test coverage: need to run this legacy subroutine _init()
Games::Literati::var_init(15,15,7);
Games::Literati::_init();

# verify _init worked properly
my $exp = 'a1b3c3d2e1f4g2h4i1j8k5l1m3n1o1p3q10r1s1t1u1v4w4x8y4z10';
my $got = join('', map { "$_$Games::Literati::values{$_}"} ('a'..'z'));
is( $got, $exp, "check legacy _init() by checking: Scrabble letter-scores");
is( n_rows,         15 , "... and Scrabble n_rows");
is( n_cols,         15 , "... and Scrabble n_cols");
is( numTilesPerHand, 7 , "... and Scrabble numTilesPerHand");

done_testing;
