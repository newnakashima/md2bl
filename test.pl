use strict;
use lib '.';
use md2bl;

sub testIndent2minus {
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
			print("testIndent2minus failed.\n");
			print("actual: " . $actual . "\n");
			print("expected: " . @expected[$i] . "\n");
			exit(1);
		}
	}
	print("testIndent2minus succeeded!\n");
}

sub testAst2sqt {
	my @inputs = (
		"**太字記法**",
	);
	my @expected = (
		"''太字記法''",
	);
	for (my $i = 0; $i < $#inputs+1; $i++) {
		my $actual = md2bl::md2bl(@inputs[$i]);
		if ($actual ne @expected[$i]) {
			print("testAst2sqt failed.\n");
			print("actual: " . $actual . "\n");
			print("expected: " . @expected[$i] . "\n");
			exit(1);
		}
	}
	print("testAst2sqt succeeded!\n");
}

sub testHash2ast {
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
			print("testHash2ast failed.\n");
			print("actual: " . $actual . "\n");
			print("expected: " . $expected[$i]. "\n");
			exit();
		}
	}
	print("testHash2ast succeeded!\n");
}

testIndent2minus();
testAst2sqt();
testHash2ast();

