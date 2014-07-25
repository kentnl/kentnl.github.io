#!/usr/bin/env perl
# FILENAME: mk_index.pl
# CREATED: 07/15/14 22:02:49 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Generate project page index.

use strict;
use warnings;
use utf8;

use Path::Tiny;

my (@projects) = grep { defined and $_ !~ /\A\s*\z/ } path('./migrated.txt')->lines_raw({ chomp => 1 });

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
 <img src="https://travis-ci.org/images/icons/github.svg" style="height: 16px; width: 16px;" alt='Github link'>
</a>
EOF
}

sub mk_metacpan_img {
  my ( $id ) = @_;
  return <<"EOF";
<a href="https://metacpan.org/release/$id"><img src="https://metacpan.org/static/icons/apple-touch-icon.png" style="height: 12px; width: 12px;" alt='Metacpan Link'></a>
EOF
}

sub mk_sco_img {
  my ( $id ) = @_;
  return <<"EOF";
<a href="http://search.cpan.org/dist/$id/"><img src="http://st.pimg.net/tucs/img/cpan_banner.png" style="height: 12px; width: 41px;" alt="Search.CPAN.org link"></a>
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

  return mk_dl( [ [ "$id " . mk_metacpan_img($id) . mk_sco_img($id)  => $entry ] ], 'class="item"' );
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
  my $list   = mk_list( [ map { mk_item($_) } sort @projects ] );
  my $title  = '<title>KENTNL Project Statuses</title>';
  my $style  = '<link rel="stylesheet" href="css/main.css" />';
  my $header = '<head>' . $title . $style . '</head>';
  my $html   = '<html>' . $header . '<body>' . $list . '</body></html>';
  return $html;
}

