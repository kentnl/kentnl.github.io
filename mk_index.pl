#!/usr/bin/env perl
# FILENAME: mk_index.pl
# CREATED: 07/15/14 22:02:49 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Generate project page index.

use strict;
use warnings;
use utf8;

use Path::Tiny;

my (@projects) = grep { defined and $_ !~ /\A\s*\z/ } split /\n/m, <<'EOF';

Dist-Zilla-Plugin-Bootstrap-lib
Dist-Zilla-Plugin-Git-NextRelease
Dist-Zilla-Plugin-Prereqs-Recommend-MatchInstalled
Dist-Zilla-PluginBundle-Author-KENTNL
Dist-Zilla-Role-Bootstrap
Path-ScanINC
Test-CPAN-Changes-ReallyStrict

EOF

path('./index.html')->spew_raw( mk_page(@projects) );

sub mk_coveralls_img {
  my ( $id, $branch ) = @_;
  return <<"EOF";
<a href='https://coveralls.io/r/kentnl/$id?branch=$branch'>
 <img src='https://coveralls.io/repos/kentnl/$id/badge.png?branch=$branch' alt='Coverage Status' />
</a>
EOF
}

sub mk_travis_img {
  my ( $id, $branch ) = @_;
  return <<"EOF";
<a href="https://travis-ci.org/kentnl/$id">
 <img src="https://travis-ci.org/kentnl/$id.svg?branch=$branch" alt='Travis Status' />
</a>
EOF
}

sub mk_github_img {
  my ( $id, $branch ) = @_;
  return <<"EOF";
<a href="https://github.com/kentnl/$id/tree/$branch">
 <img src="https://travis-ci.org/images/icons/github.svg" style="height: 16px; width: 16px;" alt='Gihub link'>
</a>
EOF
}

sub mk_dl {
  my ( $hash, $infix ) = @_;
  $infix ||= '';
  if ( length $infix ) {
    $infix =~ s/\A\s*/ /msx;
  }
  my @lines;
  for my $node ( @{$hash} ) {
    my ( $title, $value ) = @{$node};
    push @lines, '<dt>' . $title . '</dt>' . qq[\n] . '<dd>' . $value . '</dd>' . qq[\n];
  }
  return '<dl' . $infix . '>' . qq[\n]. ( join qq[\n], @lines ) . qq[\n] . '</dl>';
}

sub mk_coveralls {
  my ($id) = @_;
  my @nodes;
  push @nodes, [ 'master'       => mk_coveralls_img( $id, 'master' ) ];
  push @nodes, [ 'build/master' => mk_coveralls_img( $id, 'build/master' ) ];
  push @nodes, [ 'releases'     => mk_coveralls_img( $id, 'releases' ) ];

  return mk_dl( \@nodes, 'class="coveralls items"', );
}

sub mk_travis {
  my ($id) = @_;
  my @nodes;
  push @nodes, [ 'master'       => mk_travis_img( $id, 'master' ) ];
  push @nodes, [ 'build/master' => mk_travis_img( $id, 'build/master' ) ];
  push @nodes, [ 'releases'     => mk_travis_img( $id, 'releases' ) ];

  return mk_dl( \@nodes, 'class="travis items"', );
}

sub mk_github {
  my ($id) = @_;
  my @nodes;
  push @nodes, [ 'master'       => mk_github_img( $id, 'master' ) ];
  push @nodes, [ 'build/master' => mk_github_img( $id, 'build/master' ) ];
  push @nodes, [ 'releases'     => mk_github_img( $id, 'releases' ) ];

  return mk_dl( \@nodes, 'class="travis items"', );
}

sub mk_item {
  my ($id) = @_;

  my @nodes;
  push @nodes, [ 'Github'    => mk_github($id) ];
  push @nodes, [ 'Travis'    => mk_travis($id) ];
  push @nodes, [ 'Coveralls' => mk_coveralls($id) ];

  my $entry = mk_dl( \@nodes, 'class="results"' );

  return mk_dl( [ [ $id => $entry ] ], 'class="item"' );
}

sub mk_list {
  my ($list) = @_;
  my @lines;
  for my $item ( @{$list} ) {
    push @lines, '<li>' . qq[\n] . $item . qq[\n]. '</li>' . qq[\n];
  }
  return '<ul>' . qq[\n] . ( join q[], @lines ). qq[\n] . '</ul>' . qq[\n];
}

sub mk_page {
  my (@projects) = @_;
  my $list        = mk_list( [ map { mk_item($_) } sort @projects ] );
  my $title       = '<title>KENTNL Project Statuses</title>';
  my $style_sheet = <<'EOF';

dl.results {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  justify-content: center;
}

dl.results > dt {
  width: 10%;
  height: 24px;
}
dl.results > dd {
  width: 85%;
  margin: auto;
}

.items dt {
  padding: 0 5px;
  display: inline-block;
  width: 80px;
  height: 20px;
  margin: 0;
  text-align: right;
}
.items dd a {
  height: 20px;
  display: inline-block;
}
.items dd {
  display: inline-block;
  padding: 0 5px;
  margin: 0;
  height: 20px;
  width: 120px;
  -moz-margin-start: 0;
}

EOF
  my $style  = '<style>' . $style_sheet . '</style>';
  my $header = '<head>' . $title . $style . '</head>';
  my $html   = '<html>' . $header . '<body>' . $list . '</body></html>';
  return $html;
}

