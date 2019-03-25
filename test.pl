use strict;
use lib '.';
use md2bl;

sub test_indent2minus {
	my @inputs = (
		"- リストレベル1",
		"    - リストレベル2",
		"        - リストレベル3",
	);
	my @expected = (
		"- リストレベル1",
		"-- リストレベル2",
		"--- リストレベル3",
	);
	for (my $i = 0; $i < $#inputs+1; $i++) {
		my $actual = md2bl::md2bl(@inputs[$i]);
		if ($actual ne @expected[$i]) {
			print("test_indent2minus failed.\n");
			print("actual: " . $actual . "\n");
			print("expected: " . @expected[$i] . "\n");
			exit(1);
		}
	}
	print("test_indent2minus succeeded!\n");
}

sub test_ast2sqt {
	my @inputs = (
		"**太字記法**",
	);
	my @expected = (
		"''太字記法''",
	);
	for (my $i = 0; $i < $#inputs+1; $i++) {
		my $actual = md2bl::md2bl(@inputs[$i]);
		if ($actual ne @expected[$i]) {
			print("test_ast2sqt failed.\n");
			print("actual: " . $actual . "\n");
			print("expected: " . @expected[$i] . "\n");
			exit(1);
		}
	}
	print("test_ast2sqt succeeded!\n");
}

sub test_hash2ast {
	my @inputs = (
		"# 見出しレベル1",
		"## 見出しレベル2",
		"### 見出しレベル3",
		"# 文の途中に#があるやつ",
	);
	my @expected = (
		"* 見出しレベル1",
		"** 見出しレベル2",
		"*** 見出しレベル3",
		"* 文の途中に#があるやつ",
	);
	for (my $i = 0; $i < $#inputs+1; $i++) {
		my $actual = md2bl::md2bl(@inputs[$i]);
		if ($actual ne @expected[$i]) {
			print("test_hash2ast failed.\n");
			print("actual: " . $actual . "\n");
			print("expected: " . $expected[$i]. "\n");
			exit();
		}
	}
	print("test_hash2ast succeeded!\n");
}

sub test_delete_empty_line {
	my @inputs = (
		["hoge\n", "\n", "hoge\n"],
		["hoge\n", "  \n", "hoge\n"],
	);
	my @expected = (
		["hoge\n", "hoge\n"],
		["hoge\n", "hoge\n"],
	);
	for (my $i = 0; $i < $#inputs+1; $i++) {
		my @actual;
		foreach my $item ($inputs[$i]) {
			push(@actual, md2bl::md2bl($item));
		}
		for (my $j = 0; $j < $#expected+1; $j) {
			if ($actual[$j] ne $expected[$i][$j]) {
				print("test_delete_empty_line failed.\n");
				print("actual: " . @actual[$j] . "\n");
				print("expected: " . $expected[$i][$j] . "\n");
				exit();
			}
		}
	}
	print("test_delete_empty_line succeeded!\n");

}

test_indent2minus();
test_ast2sqt();
test_hash2ast();
test_delete_empty_line();

