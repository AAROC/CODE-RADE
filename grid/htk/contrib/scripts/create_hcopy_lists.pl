#!/usr/bin/perl
use warnings;
use strict;
use File::Basename;
use open IO => ':encoding(utf8)';

my $dir_wav = $ARGV[0];
my $dir_mfc = $ARGV[1];
my $list = $ARGV[2];

if ((@ARGV + 0) < 3) {
  print "./create_hcopy_lists.pl <in:dir_wav> <out:dir_mfc> <out:hcopy_list>\n";
  print "\tdir_wav     - directory where audio files reside\n";
  print "\tdir_mfc     - directory where mfccs will be saved to\n";
  print "\thcopy_list  - full path to hcopy list that will be created for you\n";
  exit 1;
}

if (! -d $dir_mfc) {
  print "$dir_mfc doesn't exist! Please create.\n";
  exit 1;
}

my @files = `find $dir_wav -iname "*.wav"`;

my %files;
chomp($dir_mfc=`readlink -f $dir_mfc`);

open LIST, ">$list";

foreach my $file (@files) {
  chomp($file);
  chomp($file=`readlink -f $file`);
  my $basename = basename($file);
  $basename =~ s/\.wav$/\.mfc/g;
  if (exists($files{$basename})) {
    print "WARNING: Non-unique filename encountered! <$basename> Exiting\n";
    close LIST;
    exit 1;
  }
  $files{$basename} = 1;
  print LIST "$file $dir_mfc/$basename\n";
}
close LIST;
