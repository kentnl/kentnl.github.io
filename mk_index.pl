#!/usr/bin/env perl
# FILENAME: mk_index.pl
# CREATED: 07/15/14 22:02:49 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Generate project page index.

use strict;
use warnings;
use utf8;

use Path::Tiny;

my @projects;

push @projects, 'Dist-Zilla-Role-Bootstrap';
push @projects, 'Dist-Zilla-PluginBundle-Author-KENTNL';

path('./index.html')->spew_raw(mk_page(@projects));

sub mk_coveralls_img {
  my ( $id, $branch ) = @_;
  return <<"EOF";
<a href='https://coveralls.io/r/kentnl/$id?branch=$branch'><img src='https://coveralls.io/repos/kentnl/$id/badge.png?branch=$branch' alt='Coverage Status' /></a>
EOF
}

sub mk_travis_img {
  my ( $id, $branch ) = @_;
  return <<"EOF";
<a href="https://travis-ci.org/kentnl/$id"><img src="https://travis-ci.org/kentnl/$id.svg?branch=$branch"></a>
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
    push @lines, '<dt>' . $title . '</dt><dd>' . $value . '</dd>';
  }
  return '<dl' . $infix . '>' . ( join q[], @lines ) . '</dl>';
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

sub mk_item {
  my ($id) = @_;

  my @nodes;
  push @nodes, [ 'Travis'    => mk_travis($id) ];
  push @nodes, [ 'Coveralls' => mk_coveralls($id) ];

  my $entry = mk_dl( \@nodes, 'class="results"' );

  return mk_dl( [ [ $id => $entry ] ], 'class="item"' );
}

sub mk_list {
  my ($list) = @_;
  my @lines;
  for my $item ( @{$list} ) {
    push @lines, '<li>' . $item . '</li>';
  }
  return '<ul>' . ( join q[], @lines ) . '</ul>';
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
  text-align: center;
}

dl.results > dt {
  width: 10%;
}
dl.results > dd {
  width: 85%;
  margin: auto;
}

.items dt {
  padding: 5px;
  display: inline-block;
  width: 100px;
  height: 40px;
}
.items dd {
  display: inline-block;
  padding: 5px;
  height: 40px;
  width: 100px;
  -moz-margin-start: 0;
}

EOF
  my $style  = '<style>' . $style_sheet . '</style>';
  my $header = '<head>' . $title . $style . '</head>';
  my $html   = '<html>' . $header . '<body>' . $list . '</body></html>';
  return $html;
}

