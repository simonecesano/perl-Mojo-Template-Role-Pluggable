# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.012.
use strict;
use warnings;



use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Allows use of plugins in templates; provides \"layout\" and \"include\" keywords",
  "AUTHOR" => "Simone Cesano <scesano\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Mojo-Template-Role-Pluggable",
  "LICENSE" => "perl",
  "NAME" => "Mojo::Template::Role::Pluggable",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Mojo::File" => 0,
    "Mojo::Loader" => 0,
    "Mojo::Template" => 0,
    "Mojo::Util" => 0,
    "Mojolicious::Plugins" => 0
  },
  "VERSION" => "0.001",
  "test" => {
    "TESTS" => ""
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Mojo::File" => 0,
  "Mojo::Loader" => 0,
  "Mojo::Template" => 0,
  "Mojo::Util" => 0,
  "Mojolicious::Plugins" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
