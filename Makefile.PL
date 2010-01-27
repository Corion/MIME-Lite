#!/usr/bin/perl
use ExtUtils::MakeMaker;

#------------------------------------------------------------
# Makefile:
#------------------------------------------------------------

print "MIME::Lite is designed to take advantage of a variety of external modules\n",
      "if they are not present then MIME::Lite will attempt to do its best\n",
      "but its strongly recommend that you install them.\n\n",
      "These modules are:\n",
      "\tMail::Address\n",
      "\tMIME::Types\n",
      "\tMIME::Base64\n",
      "\tMIME::QuotedPrint\n",
      "Some or all of these maybe included with your perl, neverless if you wish\n",
      "I can add these modules to the prereq list which will cause the files to be\n",
      "automatically installed if they arent already present\n";
my %prereq = (
  'File::Spec'          => 0,
  'File::Basename'      => 0,
  'Email::Date::Format' => '1.000', # first release
);
if (prompt("Add prereqs?",'Yes')=~/y/i) {
    %prereq=( %prereq,
              'Mail::Address'     => 1.62,
              'MIME::Types'       => 1.28,
              'MIME::Base64'      => undef,
              'MIME::QuotedPrint' => undef,
            );
}

# Write the Makefile:
WriteMakefile1(
  NAME         => 'MIME::Lite',
  LICENSE => 'perl'
  VERSION_FROM => "lib/MIME/Lite.pm",
  DISTNAME     => "MIME-Lite",
  EXE_FILES    => [@EXES],
  'dist'       => {
    #PREOP    => 'cvu_perl_preop -m MIME::Lite -f',#demerphq
    COMPRESS => 'gzip',
    SUFFIX   => 'gz',
  },
  META_MERGE => {
    resources => {
      repository => 'http://github.com/rjbs/mime-lite'
    }
  }
  'PREREQ_PM'    => \%prereq,
  MIN_PERL_VERSION => '5.004',
  BUILD_REQUIRES => {
    'Test::More' => 0,
  },
);


sub WriteMakefile1 {  #Written by Alexandr Ciornii, version 0.21. Added by eumm-upgrade.
  my %params=@_;
  my $eumm_version=$ExtUtils::MakeMaker::VERSION;
  $eumm_version=eval $eumm_version;
  die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
  die "License not specified" if not exists $params{LICENSE};
  if ($params{BUILD_REQUIRES} and $eumm_version < 6.5503) {
    #EUMM 6.5502 has problems with BUILD_REQUIRES
    $params{PREREQ_PM}={ %{$params{PREREQ_PM} || {}} , %{$params{BUILD_REQUIRES}} };
    delete $params{BUILD_REQUIRES};
  }
  delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
  delete $params{MIN_PERL_VERSION} if $eumm_version < 6.48;
  delete $params{META_MERGE} if $eumm_version < 6.46;
  delete $params{META_ADD} if $eumm_version < 6.46;
  delete $params{LICENSE} if $eumm_version < 6.31;
  delete $params{AUTHOR} if $] < 5.005;
  delete $params{ABSTRACT_FROM} if $] < 5.005;
  delete $params{BINARY_LOCATION} if $] < 5.005;

  WriteMakefile(%params);
}

