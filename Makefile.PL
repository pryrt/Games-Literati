use ExtUtils::MakeMaker;
require 5.006;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
%mm_args = (
    'NAME'		    => 'Games::Literati',
    'VERSION_FROM'	=> 'lib/Games/Literati.pm',
    'PREREQ_PM'		=> {'Exporter' => 0},
    'ABSTRACT_FROM' => 'lib/Games/Literati.pm',
    'AUTHOR'        => 'Peter C. jones <petercj AT cpan.org>, Chicheng Zhang',
);

{
    no warnings;
    if( $ExtUtils::MakeMaker::VERSION >= '6.31' ) {
        $mm_args{LICENSE} = 'perl_5';
    }
    if( $ExtUtils::MakeMaker::VERSION >= '6.46' ) {
        $mm_args{META_MERGE} = {
            'meta-spec' => {
                version => '2',
                url     => 'http://search.cpan.org/perldoc?CPAN::Meta::Spec',
            },
            resources => {
                bugtracker => {
                    web     => 'https://github.com/pryrt/Games-Literati/issues',
                },
                repository => {
                    url     => 'https://github.com/pryrt/Games-Literati.git',
                    web     => 'https://github.com/pryrt/Games-Literati',
                    type    => 'git',
                },
            },
        keywords => [ 'Scrabble', 'Literati', 'Words with Friends', 'tile', 'word', 'game' ],
        };
        # automatically determine the versions for 'provides'; MM->parse_version exists as of MM v6.31, so not a problem with >= 6.46
        #   => this comes out right when printed... but MYMETA.* shows values that look wrong
        my $v = MM->parse_version( $mm_args{VERSION_FROM} );
        $mm_args{META_MERGE}{provides} = {
            'Games::Literati' => {
                file => 'lib/Games/Literati.pm',
                version => $v,
            },
        };
    }
    if( $ExtUtils::MakeMaker::VERSION >= '6.48' ) {
        $mm_args{MIN_PERL_VERSION} = '5.6.0';
    }
    if( $ExtUtils::MakeMaker::VERSION >= '6.64' ) {
        $mm_args{TEST_REQUIRES} = {
            'warnings' => 0,
            'strict' => 0,
            'Test::More' => 0,
            'File::Basename' => 0,
            'Cwd' => 0,
            'IO::String' => 0,
        };
    }
}

WriteMakefile( %mm_args );
