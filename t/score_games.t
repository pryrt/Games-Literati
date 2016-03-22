#!/usr/bin/perl
########################################################################
# filestr:
#	use techniques from v5.8.5 `perldoc -f open`, for "in memory"
#	(FILEIO on \$string) and the 'saves, redirects, and restores
#	"STDOUT" and "STDERR"' section soon thereafter
########################################################################
# Subversion Info
#       $Author: pryrtmx $
#       $Date: 2016-03-07 14:37:10 -0800 (Mon, 07 Mar 2016) $
#       $Revision: 105 $
#       $URL: https://subversion.assembla.com/svn/pryrt/trunk/perl/Literati/t/score_games.t $
#       $Header: https://subversion.assembla.com/svn/pryrt/trunk/perl/Literati/t/score_games.t 105 2016-03-07 22:37:10Z pryrtmx $
#       $Id: score_games.t 105 2016-03-07 22:37:10Z pryrtmx $
########################################################################

use 5.8.0;

use warnings;
use strict;
use Test::More tests => 78;

use File::Basename qw/dirname/;
use Cwd qw/abs_path chdir/;
my $scdir = dirname($0);
#print STDERR "scdir = $scdir\n";
chdir($scdir);
#print $ENV{PWD}."\n";

use Games::Literati qw/literati scrabble wordswithfriends/;

my $input;

sub run_game($) {
    my $game = shift;
    my $stringify = '';

    close STDIN;
    open STDIN, '<', \$input
        or do { warn "set STDIN = <\$input (in-memory): $!"; return undef; };
    open STRINGIFY, '>', \$stringify
        or do { warn "set STRINGIFY = >\$stringify (in-memory): $!"; return undef; };
    select STRINGIFY;
    $| = 1;
    $game->();
    select STDOUT;
    close(STRINGIFY);
    return $stringify;
}

sub search_game($@) {
    my $gamename = shift;
    my $gameref = \&$gamename;
    my $gameout = run_game($gameref);
    my @best = ();

    my $letters = join '', sort split //, (split /\n/, $input)[-1];

    #isnt( $gameout, undef, "$gamename(): Running with input '$letters'" );

    pattern: foreach (@_) {
        my ($score, $dest, $word, $start, $bingo) = ($_->{score},$_->{dest},$_->{word},$_->{start},$_->{bingo});
        isnt( $gameout, undef, "$gamename(): desire '${word}', in ${dest} at ${start}, worth ${score} points, using input='$letters'");
        @best = qw/0 dest word start bingo exact/;
        $best[2] = "$word not found";
        line: foreach ( split /\n/, $gameout ) {
            if( m/^\((\d+)\)\s+(\w+\s+\d+)\s+become:\s+'(.*)'\s+starting at\s+(\w+\s+\d+)\s+(.*)$/gm ) {
                my @match = ($1, $2, $3, $4, 0);
                $match[4] = 1 if '(BINGO!!!!)' eq $5;
                #printf "pos()=%-4d score=%-4d dest=%-12s word=%-12s start=%-12s bingo:%d\n", pos(), @match;

                my $similar = 1 eq 1;
                $similar &&= ${dest}  eq $match[1];
                $similar &&= ${word}  eq $match[2];
                $similar &&= ${start} eq $match[3];

                my $equiv = $similar;
                $equiv &&= ${bingo} eq $match[4]     if defined ${bingo};
                $equiv &&= $similar && ${score} eq $match[0];

                if ($equiv) {
                    @best = (@match, 1); # exact match
                    last line;
                } # equiv

                if ($similar && ($match[0] > $best[0]) ) {  # update @best if it's similar and the current score is better than the previous best score
                    @best = (@match, 0);    # not the right score, but otherwise correct
                } # similar; keep looking for exact
            } # each match
        } # each line

        #print "best = (". join(', ', @best) .")\n";
        is( $best[2], $word , "... Find match for '$word'...");
        is( $best[1], $dest , "... on $dest...");
        is( $best[3], $start , "... starting at $start...");
        if(defined $bingo) {
            is( $best[4] ? 'BINGO' : 'not BINGO', $bingo ? 'BINGO' : 'not BINGO', "... BINGO " . ($bingo?"is":"isn't") . " expected..."  )
        } else {
            ok( 1, "... not testing for BINGO");
        }
        is( $best[0], $score, "... Match score $score for '$word'" );
        #print "\n";
    } # each pattern
}

#search_game('literati',
#    { word=>'antlers', dest=>'row 7', start=>'column 1', score=>49 },               # all 5 should pass: ignore bingo
#    { word=>'antlers', dest=>'row 7', start=>'column 1', score=>49, bingo=>1 },     # all 5 should pass: look for bingo==true
#    { word=>'antlers', dest=>'row 7', start=>'column 6', score=>49, bingo=>0 },     # force a fail on BINGO, because I am requiring bingo==0
#    { word=>'antlers', dest=>'column 7', start=>'row 7', score=>48 },               # force a fail on SCORE, because I am expecting wrong score=48
#);

##### Initialize IO
open my $oldin, "<&STDIN"	or die "dup STDIN: $!";

##### BOARD#1: compare scrabble/literati/wordswithfriends scores
$input =<<"EOS";
...............
...............
...............
.......c.......
......ai.......
.......s.header
.......t....r..
...jurors..soup
.......o....p.h
.upsilon.f..pea
.......speering
.........s..n.e
.........t..g..
.........e.....
........broils.
yes
7,8 10,14 7,14
eurmsss
EOS

##### SCORE BOARD#2
search_game('literati',
    { word=>'curses', dest=>'row 3', start=>'column 8', score=>8, bingo=>0 },
    { word=>'serums', dest=>'column 3', start=>'row 10', score=>24, bingo=>0 },
    { word=>'embroils', dest=>'row 14', start=>'column 6', score=>11, bingo=>0 },
);

search_game('scrabble',
    { word=>'curses', dest=>'row 3', start=>'column 8', score=>16, bingo=>0 },
    { word=>'serums', dest=>'column 3', start=>'row 10', score=>18, bingo=>0 },
    { word=>'embroils', dest=>'row 14', start=>'column 6', score=>36, bingo=>0 },   # doesn't match example board
);

search_game('wordswithfriends',
    { word=>'curses', dest=>'row 3', start=>'column 8', score=>12, bingo=>0 },
    { word=>'serums', dest=>'column 3', start=>'row 10', score=>36, bingo=>0 },
    { word=>'embroils', dest=>'row 14', start=>'column 6', score=>17, bingo=>0 },
);

##### BOARD#2: BUGFIX https://rt.cpan.org/Public/Bug/Display.html?id=29539  #### vertical 'in'
$input =<<"EOS";
vvvvvvvvvvvvvvv
vvv...vvvvvvvvv
vvv..n.vvvvvvvv
vvv...vvvvvvvvv
vvv...vvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
yes

in
EOS

search_game('literati',
    { word=>'in', dest=>'column 4', start=>'row 2', score=>6 },
    { word=>'in', dest=>'row 2', start=>'column 4', score=>3 },
);

##### BOARD#3: BUGFIX https://rt.cpan.org/Public/Bug/Display.html?id=29539  #### horizontal 'in'
$input =<<"EOS";
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
v....vvvvvvvvvv
v....vvvvvvvvvv
v.n..vvvvvvvvvv
vv.vvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
vvvvvvvvvvvvvvv
yes

in
EOS

search_game('literati',
    { word=>'in', dest=>'row 4', start=>'column 2', score=>6 },
    { word=>'in', dest=>'column 2', start=>'row 4', score=>3 },
);

####### cleanup
close(STDIN);
open STDIN, '<&', $oldin	or die "dup \$oldin back to STDIN: $!";
