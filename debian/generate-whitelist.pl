#!/usr/bin/perl

use strict;

my %whitelist;

open(my $fw_list, "-|", "find /lib/modules/\`uname -r\` -name '*.ko' | xargs /sbin/modinfo")
    || die("can't enumerate your modules.");

for my $fw (<$fw_list>) {
    chomp($fw);
    if ($fw =~ /^firmware:/) {
        (undef, $fw) = split('\s+', $fw);
	print "%s\n", $fw;
        if (/\//) {
            my @path = split('/', $fw);
            map($whitelist{join('/', @path[0..$_])} = 1, 0..($#path-1));
        }
        $whitelist{$fw} = 1;
    }
}

print join("\n", sort(keys(%whitelist))) . "\n";
