use ExtUtils::MakeMaker;
require 5.006;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
%mm_args = (
    'NAME'		    => 'Games::Literati',
    'VERSION_FROM'	=> 'Literati.pm',
    'PREREQ_PM'		=> {},
    'ABSTRACT_FROM' => 'Literati.pm',
    'AUTHOR'        => 'Peter C. jones <petercj AT cpan.org>, Chicheng Zhang',
    'META_MERGE'    => {
        resources => {
            bugtracker => 'http://rt.cpan.org/Public/Dist/Display.html?Name=Games-Literati',
            repository => 'https://github.com/pryrt/Games-Literati',
        },
        keywords => [ 'Scrabble', 'Literati', 'Words with Friends', 'tile', 'word', 'game' ],
    },
);

{
    no warnings;
    if( $ExtUtils::MakeMaker::VERSION >= '6.31' ) {
        $mm_args{LICENSE} = 'perl';
    }
}

WriteMakefile( %mm_args );