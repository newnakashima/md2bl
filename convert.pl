main() if $0 eq __FILE__;

use strict;
use lib '.';
use md2bl;

sub main {
	if ($#ARGV+1 < 1) {
		die "引数にマークダウンファイルを指定してください";
	}
	my $file = @ARGV[0];
	my $backlog = "";
	open(IN, $file) or die "$!";
	while (<IN>) {
		$backlog .= md2bl::md2bl($_);
	}
	close (IN);

	print $backlog;
}

