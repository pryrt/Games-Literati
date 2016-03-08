#!/usr/bin/perl
########################################################################
# filestr:
#	use techniques from v5.8.5 `perldoc -f open`, for "in memory"
#	(FILEIO on \$string) and the 'saves, redirects, and restores
#	"STDOUT" and "STDERR"' section soon thereafter
########################################################################
# Subversion Info
#       $Author: pryrt $
#       $Date: 2016-03-04 19:54:24 -0800 (Fri, 04 Mar 2016) $
#       $Revision: 101 $
#       $URL: https://subversion.assembla.com/svn/pryrt/trunk/perl/Literati/t/import_wordlist.t $
#       $Header: https://subversion.assembla.com/svn/pryrt/trunk/perl/Literati/t/import_wordlist.t 101 2016-03-05 03:54:24Z pryrt $
#       $Id: import_wordlist.t 101 2016-03-05 03:54:24Z pryrt $
########################################################################

use 5.6.0;

use warnings;
use strict;
use Test::More tests => 2;

use File::Basename qw/dirname/;
use Cwd qw/abs_path chdir/;
my $scdir = dirname($0);
#print STDERR "scdir = $scdir\n";
chdir($scdir);
#print $ENV{PWD}."\n";

use Games::Literati;
my $wordlistLength = 0;
my $expect;

#   TEST1: default './wordlist'; count the number of words imported
Games::Literati::_var_init();                                   # call routine to force import of wordlist
$wordlistLength = scalar(keys %{Games::Literati::valid});       # count number of words in resultant array
$expect = 21;
is( $wordlistLength, $expect , "import default '$Games::Literati::WordFile'; expect $expect, got $wordlistLength");

#   TEST2: change $WordFile; count the number of words imported (different length file)
$Games::Literati::WordFile = './wordlist.2';
%{Games::Literati::valid} = (); # clear valid list
undef $Games::Literati::words;  # clear word-length \array
Games::Literati::_var_init();                                   # call routine to force import of wordlist
$wordlistLength = scalar(keys %{Games::Literati::valid});       # count number of words in resultant array
$expect = 2;
is( $wordlistLength, $expect , "import changed '$Games::Literati::WordFile'; expect $expect, got $wordlistLength");
1;