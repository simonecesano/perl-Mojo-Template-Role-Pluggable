    use strict;
    use warnings;
    use ExtUtils::MakeMaker;
     
    WriteMakefile(
        NAME         => 'Mojo::Template::Role::Pluggable',
        AUTHOR       => q{Simone Cesano <scesano@cpan.org>},
        VERSION_FROM => 'lib/Mojo/Template/Role/Pluggable.pm ',
        ABSTRACT     => 'Allows use of plugins in templates; provides "layout" and "include" keywords',
        ( $ExtUtils::MakeMaker::VERSION >= 6.3002
            ? ( 'LICENSE' => 'perl' )
            : () ),
        PL_FILES  => {},
        PREREQ_PM => {
		      'Mojo::Template'  => 0,
		      'Mojo::Loader' => 0,
		      'Mojo::File' => 0,
		      'Mojo::Util' => 0,
		      'Mojolicious::Plugins' => 0,
		      'Carp' => 0,		      
        },
        TEST_REQUIRES => {
        },
    );
