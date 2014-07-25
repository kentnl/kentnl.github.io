#!/usr/bin/env perl
# FILENAME: mk_migrations.pl
# CREATED: 07/23/14 17:59:45 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Update migrations lists with ls

use strict;
use warnings;
use utf8;

use Path::Tiny qw(path);
use FindBin;
use JSON;

my $root = path($FindBin::Bin)->absolute;

my @out;

for my $child ( $root->parent->children ) {
  next if $child eq $root;
  push @out, $child->basename;
  my $git = $child->child('.git');
  if ( not -d $git ) {
    warn "No dir $git in $child";
    next;
  }
  if ( -d $git->child('config') ) {
    warn "No git config in $child";
    next;
  }
  if ( grep { $_ =~ /kentfredric/ } $git->child('config')->lines_utf8 ) {
    warn $child->basename . ' is not migrated properly yet, git config is wrong';
  }
}
$root->child('migrated.txt')->spew_raw( join qq[\n], sort @out );
$root->child('data/distributions.json')->spew_raw(JSON->new()->utf8->encode([ sort @out ]));
do $root->child('mk_index.pl');

