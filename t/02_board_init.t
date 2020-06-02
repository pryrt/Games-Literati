#!/usr/bin/perl
########################################################################
# board_init.t:
#   Verify that each _${gamename}_init() properly sets up the
#   right bonus grid and correct scores for each letter tile
# v0.042: add in n_rows, n_cols, numTilesPerHand testing
########################################################################

use 5.006;

use warnings;
use strict;
use Test::More tests => 4*5;

use File::Basename qw/dirname/;
use Cwd qw/abs_path chdir/;
my $scdir = dirname($0);
chdir($scdir);

use Games::Literati 0.040 qw(:infoFunctions);

my ($exp,$got);

$exp = <<"EOS";
    ##########################################################################
    # Scrabble                                                               #
    ##########################################################################
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14        #
    # 0   [TW][__][__][DL][__][__][__][TW][__][__][__][DL][__][__][TW] # 0   #
    # 1   [__][DW][__][__][__][TL][__][__][__][TL][__][__][__][DW][__] # 1   #
    # 2   [__][__][DW][__][__][__][DL][__][DL][__][__][__][DW][__][__] # 2   #
    # 3   [DL][__][__][DW][__][__][__][DL][__][__][__][DW][__][__][DL] # 3   #
    # 4   [__][__][__][__][DW][__][__][__][__][__][DW][__][__][__][__] # 4   #
    # 5   [__][TL][__][__][__][TL][__][__][__][TL][__][__][__][TL][__] # 5   #
    # 6   [__][__][DL][__][__][__][DL][__][DL][__][__][__][DL][__][__] # 6   #
    # 7   [TW][__][__][DL][__][__][__][DW][__][__][__][DL][__][__][TW] # 7   #
    # 8   [__][__][DL][__][__][__][DL][__][DL][__][__][__][DL][__][__] # 8   #
    # 9   [__][TL][__][__][__][TL][__][__][__][TL][__][__][__][TL][__] # 9   #
    # 10  [__][__][__][__][DW][__][__][__][__][__][DW][__][__][__][__] # 10  #
    # 11  [DL][__][__][DW][__][__][__][DL][__][__][__][DW][__][__][DL] # 11  #
    # 12  [__][__][DW][__][__][__][DL][__][DL][__][__][__][DW][__][__] # 12  #
    # 13  [__][DW][__][__][__][TL][__][__][__][TL][__][__][__][DW][__] # 13  #
    # 14  [TW][__][__][DL][__][__][__][TW][__][__][__][DL][__][__][TW] # 14  #
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14        #
    ##########################################################################
EOS
Games::Literati::var_init(15,15,7);
Games::Literati::_scrabble_init();
$got = Games::Literati::_text_bonus_board();
is( $got, $exp, "check Scrabble bonuses");
$exp = 'a1b3c3d2e1f4g2h4i1j8k5l1m3n1o1p3q10r1s1t1u1v4w4x8y4z10';
$got = join('', map { "$_$Games::Literati::values{$_}"} ('a'..'z'));
is( $got, $exp, "check Scrabble letter-scores");
is( n_rows,         15 , "check Scrabble n_rows");
is( n_cols,         15 , "check Scrabble n_cols");
is( numTilesPerHand, 7 , "check Scrabble numTilesPerHand");

$exp = <<"EOS";
    ##################################################################################################
    # SuperScrabble                                                                                  #
    ##################################################################################################
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20        #
    # 0   [4W][__][__][2L][__][__][__][3W][__][__][2L][__][__][3W][__][__][__][2L][__][__][4W] # 0   #
    # 1   [__][2W][__][__][3L][__][__][__][2W][__][__][__][2W][__][__][__][3L][__][__][2W][__] # 1   #
    # 2   [__][__][2W][__][__][4L][__][__][__][2W][__][2W][__][__][__][4L][__][__][2W][__][__] # 2   #
    # 3   [2L][__][__][3W][__][__][2L][__][__][__][3W][__][__][__][2L][__][__][3W][__][__][2L] # 3   #
    # 4   [__][3L][__][__][2W][__][__][__][3L][__][__][__][3L][__][__][__][2W][__][__][3L][__] # 4   #
    # 5   [__][__][4L][__][__][2W][__][__][__][2L][__][2L][__][__][__][2W][__][__][4L][__][__] # 5   #
    # 6   [__][__][__][2L][__][__][2W][__][__][__][2L][__][__][__][2W][__][__][2L][__][__][__] # 6   #
    # 7   [3W][__][__][__][__][__][__][2W][__][__][__][__][__][2W][__][__][__][__][__][__][3W] # 7   #
    # 8   [__][2W][__][__][3L][__][__][__][3L][__][__][__][3L][__][__][__][3L][__][__][2W][__] # 8   #
    # 9   [__][__][2W][__][__][2L][__][__][__][2L][__][2L][__][__][__][2L][__][__][2W][__][__] # 9   #
    # 10  [2L][__][__][3W][__][__][2L][__][__][__][2W][__][__][__][2L][__][__][3W][__][__][2L] # 10  #
    # 11  [__][__][2W][__][__][2L][__][__][__][2L][__][2L][__][__][__][2L][__][__][2W][__][__] # 11  #
    # 12  [__][2W][__][__][3L][__][__][__][3L][__][__][__][3L][__][__][__][3L][__][__][2W][__] # 12  #
    # 13  [3W][__][__][__][__][__][__][2W][__][__][__][__][__][2W][__][__][__][__][__][__][3W] # 13  #
    # 14  [__][__][__][2L][__][__][2W][__][__][__][2L][__][__][__][2W][__][__][2L][__][__][__] # 14  #
    # 15  [__][__][4L][__][__][2W][__][__][__][2L][__][2L][__][__][__][2W][__][__][4L][__][__] # 15  #
    # 16  [__][3L][__][__][2W][__][__][__][3L][__][__][__][3L][__][__][__][2W][__][__][3L][__] # 16  #
    # 17  [2L][__][__][3W][__][__][2L][__][__][__][3W][__][__][__][2L][__][__][3W][__][__][2L] # 17  #
    # 18  [__][__][2W][__][__][4L][__][__][__][2W][__][2W][__][__][__][4L][__][__][2W][__][__] # 18  #
    # 19  [__][2W][__][__][3L][__][__][__][2W][__][__][__][2W][__][__][__][3L][__][__][2W][__] # 19  #
    # 20  [4W][__][__][2L][__][__][__][3W][__][__][2L][__][__][3W][__][__][__][2L][__][__][4W] # 20  #
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20        #
    ##################################################################################################
EOS
Games::Literati::var_init(21,21,7);
Games::Literati::_superscrabble_init();
$got = Games::Literati::_text_bonus_board();
is( $got, $exp, "check SuperScrabble bonuses");
$exp = 'a1b3c3d2e1f4g2h4i1j8k5l1m3n1o1p3q10r1s1t1u1v4w4x8y4z10';
$got = join('', map { "$_$Games::Literati::values{$_}"} ('a'..'z'));
is( $got, $exp, "check SuperScrabble letter-scores");
is( n_rows,         21 , "check SuperScrabble n_rows");
is( n_cols,         21 , "check SuperScrabble n_cols");
is( numTilesPerHand, 7 , "check SuperScrabble numTilesPerHand");

$exp = <<"EOS";
    ##########################################################################
    # Literati                                                               #
    ##########################################################################
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14        #
    # 0   [__][__][__][3W][__][__][3L][__][3L][__][__][3W][__][__][__] # 0   #
    # 1   [__][__][2L][__][__][2W][__][__][__][2W][__][__][2L][__][__] # 1   #
    # 2   [__][2L][__][__][2L][__][__][__][__][__][2L][__][__][2L][__] # 2   #
    # 3   [3W][__][__][3L][__][__][__][2W][__][__][__][3L][__][__][3W] # 3   #
    # 4   [__][__][2L][__][__][__][2L][__][2L][__][__][__][2L][__][__] # 4   #
    # 5   [__][2W][__][__][__][3L][__][__][__][3L][__][__][__][2W][__] # 5   #
    # 6   [3L][__][__][__][2L][__][__][__][__][__][2L][__][__][__][3L] # 6   #
    # 7   [__][__][__][2W][__][__][__][__][__][__][__][2W][__][__][__] # 7   #
    # 8   [3L][__][__][__][2L][__][__][__][__][__][2L][__][__][__][3L] # 8   #
    # 9   [__][2W][__][__][__][3L][__][__][__][3L][__][__][__][2W][__] # 9   #
    # 10  [__][__][2L][__][__][__][2L][__][2L][__][__][__][2L][__][__] # 10  #
    # 11  [3W][__][__][3L][__][__][__][2W][__][__][__][3L][__][__][3W] # 11  #
    # 12  [__][2L][__][__][2L][__][__][__][__][__][2L][__][__][2L][__] # 12  #
    # 13  [__][__][2L][__][__][2W][__][__][__][2W][__][__][2L][__][__] # 13  #
    # 14  [__][__][__][3W][__][__][3L][__][3L][__][__][3W][__][__][__] # 14  #
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14        #
    ##########################################################################
EOS
Games::Literati::var_init(15,15,7);
Games::Literati::_literati_init();
$got = Games::Literati::_text_bonus_board();
is( $got, $exp, "check Literati bonuses");
$exp = 'a1b2c1d1e1f3g1h2i1j5k3l1m1n1o1p2q5r1s1t1u1v4w4x5y3z5';
$got = join('', map { "$_$Games::Literati::values{$_}"} ('a'..'z'));
is( $got, $exp, "check Literati letter-scores");
is( n_rows,         15 , "check Literati n_rows");
is( n_cols,         15 , "check Literati n_cols");
is( numTilesPerHand, 7 , "check Literati numTilesPerHand");

$exp = <<"EOS";
    ##########################################################################
    # Words With Friends                                                     #
    ##########################################################################
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14        #
    # 0   [__][__][__][3W][__][__][3L][__][3L][__][__][3W][__][__][__] # 0   #
    # 1   [__][__][2L][__][__][2W][__][__][__][2W][__][__][2L][__][__] # 1   #
    # 2   [__][2L][__][__][2L][__][__][__][__][__][2L][__][__][2L][__] # 2   #
    # 3   [3W][__][__][3L][__][__][__][2W][__][__][__][3L][__][__][3W] # 3   #
    # 4   [__][__][2L][__][__][__][2L][__][2L][__][__][__][2L][__][__] # 4   #
    # 5   [__][2W][__][__][__][3L][__][__][__][3L][__][__][__][2W][__] # 5   #
    # 6   [3L][__][__][__][2L][__][__][__][__][__][2L][__][__][__][3L] # 6   #
    # 7   [__][__][__][2W][__][__][__][__][__][__][__][2W][__][__][__] # 7   #
    # 8   [3L][__][__][__][2L][__][__][__][__][__][2L][__][__][__][3L] # 8   #
    # 9   [__][2W][__][__][__][3L][__][__][__][3L][__][__][__][2W][__] # 9   #
    # 10  [__][__][2L][__][__][__][2L][__][2L][__][__][__][2L][__][__] # 10  #
    # 11  [3W][__][__][3L][__][__][__][2W][__][__][__][3L][__][__][3W] # 11  #
    # 12  [__][2L][__][__][2L][__][__][__][__][__][2L][__][__][2L][__] # 12  #
    # 13  [__][__][2L][__][__][2W][__][__][__][2W][__][__][2L][__][__] # 13  #
    # 14  [__][__][__][3W][__][__][3L][__][3L][__][__][3W][__][__][__] # 14  #
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14        #
    ##########################################################################
EOS
Games::Literati::var_init(15,15,7);
Games::Literati::_wordswithfriends_init();
$got = Games::Literati::_text_bonus_board();
is( $got, $exp, "check Words With Friends bonuses");
$exp = 'a1b4c4d2e1f4g3h3i1j10k5l2m4n2o1p4q10r1s1t1u2v5w4x8y3z10';
$got = join('', map { "$_$Games::Literati::values{$_}"} ('a'..'z'));
is( $got, $exp, "check Words With Friends letter-scores");
is( n_rows,         15 , "check Words With Friends n_rows");
is( n_cols,         15 , "check Words With Friends n_cols");
is( numTilesPerHand, 7 , "check Words With Friends numTilesPerHand");

exit;

1;
