#! /usr/bin/perl

use LWP::Simple;
use JSON qw( decode_json );

if ($#ARGV >= 0) {
        $url = $ARGV[0];
} else {
	exit;
}

my $json = get $url;
my $decoded_json = decode_json($json);

$timestamp = $decoded_json->[0]->[0]->{'timestamp'};
$time = scalar localtime $timestamp;
$stats = $decoded_json->[0]->[0]->{'stats'};
$rawtotal = $stats->{'rawtotal'};
$total_contributions = $stats->{'numberofcontributions'}->{'total'};
if (!$total_contributions) {
	exit;
}
$average = $rawtotal / $total_contributions;

$output = $average . ' ' . $timestamp . ' ' . $rawtotal . ' ' . $total_contributions . ' ' . $time . "\n";
syswrite (STDOUT, $output, length($output));
