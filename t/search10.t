BEGIN {
    if($ENV{PERL_CORE}) {
        chdir 't';
        @INC = '../lib';
    }
}

# Time-stamp: "2004-05-23 22:38:58 ADT"

use strict;
use warnings;

#sub Pod::Simple::Search::DEBUG () {5};

use Pod::Simple::Search;
use Test;
BEGIN { plan tests => 11 }

print "# ", __FILE__,
 ": Testing the surveying of a single specified docroot...\n";

my $x = Pod::Simple::Search->new;
die "Couldn't make an object!?" unless ok defined $x;

print "# Testing the surveying of a single docroot...\n";

$x->inc(0);

use File::Spec;
use Cwd;
my $cwd = cwd();
print "# CWD: $cwd\n";

sub source_path {
    my $file = shift;
    if ($ENV{PERL_CORE}) {
        return "../lib/Pod/Simple/t/$file";
    } else {
        return $file;
    }
}

my $here;
if(     -e ($here = source_path('testlib1'))) {
  #
} elsif(-e ($here = File::Spec->catdir($cwd, 't', 'testlib1'))) {
  #
} else {
  die "Can't find the test corpus";
}
print "# OK, found the test corpus as $here\n";
ok 1;

print $x->_state_as_string;
#$x->verbose(12);

use Pod::Simple;
*pretty = \&Pod::Simple::BlackBox::pretty;

my($name2where, $where2name) = $x->survey($here);

my $p = pretty( $where2name, $name2where )."\n";
$p =~ s/, +/,\n/g;
$p =~ s/^/#  /mg;
print $p;

my $ascii_order;
if(     -e ($ascii_order = source_path('ascii_order.pl'))) {
  #
} elsif(-e ($ascii_order = File::Spec->catfile($cwd, 't', 'ascii_order.pl'))) {
  #
} else {
    print STDERR __FILE__, ": ", __LINE__, ": ascii_order='$ascii_order'; curdir=", $cwd, "; ", File::Spec->catfile($cwd, 't', 'ascii_order.pl'), "\n";
  die "Can't find ascii_order.pl";
}

require $ascii_order;

{
my $names = join "|", sort ascii_order values %$where2name;
ok $names, "Blorm|Zonk::Pronk|hinkhonk::Glunk|hinkhonk::Vliff|perlflif|perlthng|squaa|squaa::Glunk|squaa::Vliff|zikzik";
}

{
my $names = join "|", sort ascii_order keys %$name2where;
ok $names, "Blorm|Zonk::Pronk|hinkhonk::Glunk|hinkhonk::Vliff|perlflif|perlthng|squaa|squaa::Glunk|squaa::Vliff|zikzik";
}

ok( ($name2where->{'squaa'} || 'huh???'), '/squaa\.pm$/');

ok grep( m/squaa\.pm/, keys %$where2name ), 1;

###### Now with recurse(0)

print "# Testing the surveying of a single docroot without recursing...\n";

$x->recurse(0);
($name2where, $where2name) = $x->survey($here);

$p = pretty( $where2name, $name2where )."\n";
$p =~ s/, +/,\n/g;
$p =~ s/^/#  /mg;
print $p;

{
my $names = join "|", sort ascii_order values %$where2name;
ok $names, "Blorm|squaa|zikzik";
}

{
my $names = join "|", sort ascii_order keys %$name2where;
ok $names, "Blorm|squaa|zikzik";
}

ok( ($name2where->{'squaa'} || 'huh???'), '/squaa\.pm$/');

ok grep( m/squaa\.pm/, keys %$where2name ), 1;

ok 1;

__END__

