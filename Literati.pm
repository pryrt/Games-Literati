package Games::Literati;

use strict;
use Carp;

require Exporter;

our @ISA        = qw( Exporter );
our @EXPORT_OK  = qw( find %valid scrabble literati);

our $VERSION = 0.01;
our %valid = ();
our @bonus;
our @onboard;
our %values;
our %solutions;
our $words;
our $bingo_bonus;
our @wilds;

sub scrabble {
    _var_init();
    _init();
    display();
    search(shift, shift);
}

sub literati {
    _var_init();
    _literati_init();
    display();
    search(shift, shift);
}

sub _var_init {
    open (my $fh, "./wordlist" ) || croak "Can not open wordfile.\n";
    
    print "Hashing words...\n";
    while (<$fh>) {
	chomp;
	$valid{$_} = 1;
	push @{$words->[length $_]}, $_;
    }
    
}

sub check {
    no warnings;
    my @words    = @{ pop @_ };  
    for my $w (@words) {
	if ($valid{$w} == 1) {
	    print qq|"$w" is valid.\n|;
	}
	else {
	    print qq|"$w" is invalid.\n|;
	}
    }
}

sub find {
    no warnings;
    my $args     = shift;
    my $letters  = $args->{letters};
    my $re       = $args->{re} || "//";
    my $internal = $args->{internal} || 0;
    my $len;
    my $hint;
    my $check_letters;
    my @results;
    my ($min_len, $max_len) = (split ",", $args->{len});
    $min_len ||= 2;
    $max_len ||= 7;
    
    croak "Not enough letters.\n" unless (length($letters) > 1);


    LINE: for (keys %valid) {
        $len = length $_;
        next LINE if ($len > $max_len || $len < $min_len);
        $check_letters = $letters;
	
        next LINE unless (eval $re);
	$hint = "";

        for my $l (split //, $_) {
            next LINE unless ( $check_letters =~ s/$l// or 
			       ($check_letters =~ s/\?// and $hint .= "($l)") );
        }
	unless ($internal) {
	    print "$_ $hint\n";
	}
	else {
	    push @results, $_;
	}

    }
    return \@results if $internal;
}

sub _find {
    my $letters  = shift;
    my $len      = shift;
    my $re       = shift;
    my $check_letters;
    my @results;
    my @v;

  LINE: for (@{$words->[$len]}) {
      $check_letters = $letters;

      next LINE unless /^$re$/;
   
      @v = ();
      for my $l (split //, $_) {
            next LINE unless ( ( $check_letters =~ s/$l// and push @v, $values{$l} ) or 
			       ( $check_letters =~ s/\?// and push @v, 0 ) );
        }
     
        
	push @results, { "trying" => $_, "values" => [ @v ] };
    }
    return \@results;
}

sub _init {

    $bonus[0][0]   = "TW";
    $bonus[0][7]   = "TW";
    $bonus[0][14]  = "TW";
    $bonus[7][0]   = "TW";
    $bonus[7][14]  = "TW";
    $bonus[14][0]  = "TW";
    $bonus[14][7]  = "TW";
    $bonus[14][14] = "TW";

    $bonus[1][1]   = "DW";
    $bonus[1][13]  = "DW";
    $bonus[2][2]   = "DW";
    $bonus[2][12]  = "DW";
    $bonus[3][3]   = "DW";
    $bonus[3][11]  = "DW";
    $bonus[4][4]   = "DW";
    $bonus[4][10]  = "DW";
    $bonus[7][7]   = "DW";
    $bonus[10][4]  = "DW";
    $bonus[10][10] = "DW";
    $bonus[11][3]  = "DW";
    $bonus[11][11] = "DW";
    $bonus[12][2]  = "DW";
    $bonus[12][12] = "DW";
    $bonus[13][1]  = "DW";
    $bonus[13][13] = "DW";    

    $bonus[0][3]   = "DL";
    $bonus[0][11]  = "DL";
    $bonus[2][6]   = "DL";
    $bonus[2][8]   = "DL";
    $bonus[3][0]   = "DL";
    $bonus[3][7]   = "DL";
    $bonus[3][14]  = "DL";    
    $bonus[6][2]   = "DL";
    $bonus[6][6]   = "DL";
    $bonus[6][8]   = "DL";
    $bonus[6][12]  = "DL";   
    $bonus[7][3]   = "DL";
    $bonus[7][11]  = "DL";   
    $bonus[8][2]   = "DL";
    $bonus[8][6]   = "DL";
    $bonus[8][8]   = "DL";
    $bonus[8][12]  = "DL";  
    $bonus[11][0]  = "DL";
    $bonus[11][7]  = "DL";
    $bonus[11][14] = "DL";
    $bonus[12][6]  = "DL";
    $bonus[12][8]  = "DL";
    $bonus[14][3]  = "DL";
    $bonus[14][11] = "DL";
    
    $bonus[1][5]   = "TL";
    $bonus[1][9]   = "TL";
    $bonus[5][1]   = "TL";
    $bonus[5][5]   = "TL";
    $bonus[5][9]   = "TL";
    $bonus[5][13]  = "TL";
    $bonus[9][1]   = "TL";
    $bonus[9][5]   = "TL";
    $bonus[9][9]   = "TL";
    $bonus[9][13]  = "TL";
    $bonus[13][5]  = "TL";
    $bonus[13][9]  = "TL";

    for my $row (0..14) {
        for my $col (0..14) {
	    $onboard[$row][$col] = '.';
        }
    }

    %values = (
	a=>1,
	b=>3,
	c=>3,
	d=>2,
	e=>1,
	f=>4,
	g=>2,
	h=>4,
	i=>1,
	j=>8,
	k=>5,
	l=>1,
	m=>3,
	n=>1,
	o=>1,
	p=>3,
	q=>10,
	r=>1,
	s=>1,
	t=>1,
	u=>1,
	v=>4,
	w=>4,
	x=>8,
	y=>4,
	z=>10
	       );
    $bingo_bonus = 50;
}

sub display {
    my $f = shift;
    my ($t, $r, $c) = @_;

    for my $row (0..14) {
	print sprintf "%02d ", $row if $f; 
	for my $col (0..14) {	    
	    $onboard[$row][$col] ||= '.';
	    
	    print $onboard[$row][$col];
	    
	}
	print "\n";
    }

}

sub search {
    my $use_min = shift;
    my $use     = shift;
    my $input;
    my $best = 0;
  INPUT:
    for my $row (0..14) {
	print "row $row:\n";
	$input = <STDIN>;
	chomp $input;
	if (length($input) > 15) {
	    print "over board!\n";
	    goto INPUT;
	}
	
	$onboard[$row]=[split //, $input];
    }
    print "---------Scrabble/Literati----------\n";
    display();
  INVALID:
    print "Is the above correct?\n";
  
    $input = <STDIN>;
    goto INVALID unless ($input =~ /yes|no/);
    goto INPUT unless ($input =~ /yes/);

  WILD:
    print "wild tiles are at:[Row1,Col1 Row2,Col2 ...]\n";
    $input = <STDIN>;
    chomp $input;
    
    @wilds = (); 
    goto TILES unless $input;
    my @w = (split /\s/, $input);
    for (@w) {
	my ($r, $c) = split (/,/, $_);
	unless (defined $onboard[$r][$c] && $onboard[$r][$c] ne '.') { 
	    print "Invalid wild tile positions, please re-enter.\n";
	    goto WILD;
	}
	$wilds[$r][$c] = 1;
    }
  TILES: 
    print "Enter tiles:\n";
    $input = <STDIN>;
    chomp $input;
    
    print "\nLooking for solutions for $input(in X axis)...\n";
    display();
    _mathwork($input, "x", $use_min, $use);
    _rotate_board();

    print "\nLooking for solutions for $input(in Y axis)...\n";
    _mathwork($input, "y", $use_min, $use);
    _rotate_board();
  
    my @args;
    for my $key (sort {$solutions{$b} <=> $solutions{$a}} keys %solutions) {
	last if ++$best > 10;
	 
	print "Possible Ten Best Solution $best: $key, score $solutions{$key}\n";

    }

}

sub _mathwork {
    no warnings;
    $|=1;
    my %found;
    my $letters = shift;
    my @letters = split //, $letters;
    my $rotate  = ($_[0] eq "y");
    my $use_min = $_[1] || 1;
    my $use     = $_[2] || scalar @letters;
    my $go_on   = 0;
    my $actual_letters;
    my $solution;

    while ($use >= $use_min) {
	print "using $use tiles:\n";

	for my $row (0..14) {
	    for my $col (0..15-$use) {
		next if $onboard[$row][$col] ne '.';
		$go_on = 0;
		$actual_letters = $letters;
		my @thisrow = @{$onboard[$row]};
		
		my $count   = $use;
		my $column  = $col;
		
		while ($count) {
		    if ($column > 14) {$go_on = 0; last};
		    
		    unless ($go_on) {
			if (
			    $onboard[$row][$col] ne '.'   ||
			    ($column > 0  && $onboard[$row][$column-1] ne '.')  ||
			    ($column < 14 && $onboard[$row][$column+1] ne '.')  ||
			    ($row > 0     && $onboard[$row-1][$column] ne '.')  ||
			    ($row < 14    && $onboard[$row+1][$column] ne '.')  ||
			    ($row == 7    && $column == 7)) {
			    $go_on = 1;			
			}
		    }
		    if ( $thisrow[$column] eq '.' ) {
			$thisrow[$column] = '/';
			$count --;
		    }
		    $column ++;
		}
		next if $column > 15;
		next unless $go_on == 1;
		
		my $str = "";
		my $record;
		map { $str .= $_ } @thisrow;
	
		for (split (/\./, $str)) {
		    next unless /\//;
		    $record = $str = $_;
		    ~s/\//./g;
		    $str =~ s/\///g;
		    $actual_letters .= $str;
		   
		    my $length  = length $_;

		    unless (defined $found{"$actual_letters,$_"}) {
		
			$found{"$actual_letters,$_"} = _find($actual_letters, $length, $_);
		    }
		   
		    for my $tryin (@{$found{"$actual_letters,$_"}}) {
		

		
			my @values = @{ $tryin->{values} };
			my $index  = index ($record, "/");
			my $fail   = 0;
			my $replace;
			my $score  = 0;
			my $v;
			my $trying = $tryin->{trying};
			
		
			for my $c ($col..$col + $length - 1 - $index) {
			    $str = '';
			    for my $r (0..14) {
				if ($r == $row) {
				    $str    .= substr ($record, $index, 1);
				    $replace = substr ($trying, $index, 1);
				    $v       = $values[$index++];
				}
				else {
				    $str .= $onboard[$r][$c];
				}
			    }

			   
			    for (split /\./, $str) {				
				next unless /\//;
				next if (length($_) == 1);
				my $t_score = 0;
				my $cc = $c - index ($_, "/") - 1;
				while (/(\w)/g) {
				    unless ( $wilds[$row][$cc+pos()] ) {
				
				    }
				    else {
					$t_score += $values{$1}; 
				    }

				};
				s/\//$replace/;
			
				if ($valid{$_}) {
				    
				    if ($bonus[$row][$c] eq "TL") {
					$score += $t_score + $v * 3;
				    }
				    elsif ($bonus[$row][$c] eq "DL") {
					$score += $t_score + $v * 2;
				    }
				    elsif ($bonus[$row][$c] eq "DW") {
					$score += ($t_score + $v) * 2;
				    }
				    elsif ($bonus[$row][$c] eq "TW") {
					$score += ($t_score + $v) * 3;
				    }
				    else {
					$score += $t_score + $v;
				    }
				}
				else {
				    $fail = 1;
				}
			    }
			    last if $fail;
		
			}
			next if $fail;
		
			my $col_index = 0 - index ($record, "/");			
			my $t_score = 0;
			my $t_flag  = '';			
			my $cc = 0;
		
			for (split //, $trying) {
			    if ($onboard[$row][$col+$col_index] eq '.') {
				if ($bonus[$row][$col+$col_index] eq "TL") {
				    $t_score += $values[$cc] * 3;
				}
				elsif ($bonus[$row][$col+$col_index] eq "DL") {
				    $t_score += $values[$cc] * 2;
				}
				elsif ($bonus[$row][$col+$col_index] eq "DW") {
				    $t_score += $values[$cc];
				    $t_flag .=  "*2";
				   
				}
				elsif ($bonus[$row][$col+$col_index] eq "TW") {
				    $t_score += $values[$cc];
				    $t_flag .=  "*3";
				}
				else {
				    $t_score += $values[$cc];
				}
				
			      
			    }
			    else {
				unless ($wilds[$row][$col+$col_index]) {
				    $t_score += $values{$_};
				}
			    }
			    $cc ++;
			    $col_index ++;
			}

			$score += eval "$t_score$t_flag";
			$score += $bingo_bonus if $use == 7;
			
			$solution = ($rotate?"column" : "row") .
			    " $row become: '$trying' starting at " .
			    ($rotate?"row" : "column") . 
			    " $col " .
			    ($use == 7? "(BINGO!!!!)" : "");
			
			print "($score)\t$solution\n";
			$solutions{"$solution using $use tile(s)"} = $score;
			
		    }
		}

	    }
	}
	$use --;
    }
   		    
}


sub _rotate_board {

    for my $row (0..13)  {
	for my $col ($row+1..14) {

	    ($onboard[$col][$row], $onboard[$row][$col]) = ($onboard[$row][$col], $onboard[$col][$row]);
	}
    }
}

sub _literati_init {
    $bonus[0][3]   = 'TW';
    $bonus[0][6]   = 'TL';
    $bonus[0][8]   = 'TL';
    $bonus[0][11]  = 'TW';
  
    $bonus[1][2]   = 'DL';
    $bonus[1][5]   = 'DW';
    $bonus[1][9]   = 'DW';
    $bonus[1][12]  = 'DL';
 
    $bonus[2][1]   = 'DL';
    $bonus[2][4]   = 'DL';
    $bonus[2][10]  = 'DL';
    $bonus[2][13]  = 'DL';

    $bonus[3][0]   = 'TW';
    $bonus[3][3]   = 'TL';
    $bonus[3][7]   = 'DW';
    $bonus[3][11]  = 'TL';
    $bonus[3][14]  = 'TW';

    $bonus[4][2]   = 'DL';
    $bonus[4][6]   = 'DL';
    $bonus[4][8]   = 'DL';
    $bonus[4][12]  = 'DL';

    $bonus[5][1]   = 'DW';
    $bonus[5][5]   = 'TL';
    $bonus[5][9]   = 'TL';
    $bonus[5][13]  = 'DW';

    $bonus[6][0]   = 'TL';
    $bonus[6][4]   = 'DL';
    $bonus[6][10]  = 'DL';
    $bonus[6][14]  = 'TL';

    $bonus[7][3]   = 'DW';
    $bonus[7][11]  = 'DW';

    $bonus[8][0]   = 'TL';
    $bonus[8][4]   = 'DL';
    $bonus[8][10]  = 'DL';
    $bonus[8][14]  = 'TL';

    $bonus[9][1]   = 'DW';
    $bonus[9][5]   = 'TL';
    $bonus[9][9]   = 'TL';
    $bonus[9][13]  = 'DW';

    $bonus[10][2]  = 'DL';
    $bonus[10][6]  = 'DL';
    $bonus[10][8]  = 'DL';
    $bonus[10][12] = 'DL';

    $bonus[11][0]  = 'TW';
    $bonus[11][3]  = 'TL';
    $bonus[11][7]  = 'DW';
    $bonus[11][11] = 'TL';
    $bonus[11][14] = 'TW';
    
    $bonus[12][1]  = 'DL';
    $bonus[12][4]  = 'DL';
    $bonus[12][10] = 'DL';
    $bonus[12][13] = 'DL';

    $bonus[13][2]  = 'DL';
    $bonus[13][5]  = 'DW';
    $bonus[13][9]  = 'DW';
    $bonus[13][12] = 'DL';

    $bonus[14][3]  = 'TW';
    $bonus[14][6]  = 'TL';
    $bonus[14][8]  = 'TL';
    $bonus[14][11] = 'TW';

    $bingo_bonus   = 35;

    for my $row (0..14) {
        for my $col (0..14) {
            $onboard[$row][$col] = '.';
        }
    }

    %values = (
        a=>1,
        b=>2,
        c=>1,
        d=>1,
        e=>1,
        f=>3,
        g=>1,
        h=>2,
        i=>1,
        j=>5,
        k=>3,
        l=>1,
        m=>1,
        n=>1,
        o=>1,
        p=>2,
        q=>5,
        r=>1,
        s=>1,
        t=>1,
        u=>1,
        v=>4,
        w=>4,
        x=>5,
        y=>3,
        z=>5 
               );

}
1;

__END__

=pod

=head1 NAME

B<Games::Literati> -- Literati resolver

=head1 SYNOPSIS

    use Games::Literati;

=head1 DESCRIPTION

B<Games::Literati> helps you find out B<ALL> solutions for a given
board and tiles.  Similarly it can be used to play Scrabble. 

The documentation of standalone functions will be added.

To used it to play the games:

	use Games::Literati;

	literati(min_tiles, max_tiles);

enter the data prompted then the best 10 solution will be displayed.

	literati(3,7);
	literati();      # use 1-7 tiles.
	scrabble();

It is recommended to pre-write everything into a file. and run the 
program via command-line.

In the file, the first 1-15 lines represent board situation, followed 
with "yes", followed by wild tile positions, if none, place a empty 
line here, then followed by tiles (can be less than 7), use ? to 
represent wild tiles. 

<B>make sure to put `wordlist' in the working directory when running.
the program.

For example, the file is named `t':

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
    .........e
    ........broils
    yes
    7,8 10,14 7,14
    eurmsss
    <file end with a CR>

    from the command line:

    perl -e'use Games::Literati qw(literati); literati()' < t

    [....] 
    using 7 tiles:
    using 6 tiles:
    (9)     row 3 become: 'cussers' starting at column 8
    (9)     row 12 become: 'russets' starting at column 4
    using 5 tiles:
    (8)     row 3 become: 'cruses' starting at column 8
    (8)     row 3 become: 'curses' starting at column 8

    [...]

     Possible Ten Best Solution 1: column 3 become: 
     'susses' starting at row 10  using 5 tile(s), score 24
     Possible Ten Best Solution 2: column 3 become: 'serums' 
     starting at row 10  using 5 tile(s), score 24
     Possible Ten Best Solution 3: column 14 become: 'muser' 
     starting at row 1  using 4 tile(s), score 15
    [...]

    or

    perl -e'use Games::Literati qw(scrabble); scrabble()' < t

    [...]
    Possible Ten Best Solution 1: row 14 become: 'embroils' 
    starting at column 6  using 2 tile(s), score 36
    Possible Ten Best Solution 2: column 2 become: 'spumes' 
    starting at row 8  using 5 tile(s), score 22
    [...]


    Example 2:

    From beginning of the game, create file 't' like this:
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    ...............
    yes
   
    ?omment


    $perl -e'use Games::Literati qw(literati); literati()' < t

    [...]
    using 7 tiles:
    (47)    row 7 become: 'comment' starting at column 1 (BINGO!!!!)
    (47)    row 7 become: 'memento' starting at column 1 (BINGO!!!!)
    (47)    row 7 become: 'metonym' starting at column 1 (BINGO!!!!)
    (47)    row 7 become: 'momenta' starting at column 1 (BINGO!!!!)
    (47)    row 7 become: 'momento' starting at column 1 (BINGO!!!!)
    [...]
    

    $ perl -e'use Games::Literati qw(scrabble);scrabble()' < t
    
    [...]
    (76)    row 7 become: 'comment' starting at column 1 (BINGO!!!!)
    (76)    row 7 become: 'memento' starting at column 1 (BINGO!!!!)
    (72)    row 7 become: 'metonym' starting at column 1 (BINGO!!!!)
    [...]

    good luck!:)

    
=head1 AUTHOR

I<chichengzhang@hotmail.com>.

=cut

