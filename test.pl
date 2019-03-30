use strict;
use lib '.';
use md2bl;

sub exec_test {
    my ($test_name, $inputs, $expected) = @_;
    for (my $i = 0; $i < @$inputs; $i++) {
        my $actual = md2bl::md2bl($inputs->[$i]);
        if ($actual ne $expected->[$i]) {
            print("$test_name failed.\n");
            print("actual: $actual\n");
            print("expected: $expected->[$i]\n");
            exit(1);
        }
    }
    print("$test_name succeeded!\n");
}

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
    exec_test((caller(0))[3], \@inputs, \@expected);
}

sub test_numbered_list {
    my @inputs = (
        "1. 番号リストレベル1",
        "1. 番号リストレベル1",
        "    1. 番号リストレベル2",
        "        1. 番号リストレベル3",
        "    1. 番号リストレベル2",
        "2. 番号リストレベル1",
    );
    my @expected = (
        "+ 番号リストレベル1",
        "+ 番号リストレベル1",
        "++ 番号リストレベル2",
        "+++ 番号リストレベル3",
        "++ 番号リストレベル2",
        "+ 番号リストレベル1"
    );
    exec_test((caller(0))[3], \@inputs, \@expected);
}

sub test_ast2sqt {
    my @inputs = (
        "**太字記法**",
    );
    my @expected = (
        "''太字記法''",
    );
    exec_test((caller(0))[3], \@inputs, \@expected);
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
    exec_test((caller(0))[3], \@inputs, \@expected);
}

sub test_delete_empty_line {
    my $test_name = (caller(0))[3];
    my $inputs = [
        ["hoge\n", "\n", "hoge\n"],
        ["hoge\n", "  \n", "hoge\n"],
    ];
    my $expected = [
        ["hoge\n", "hoge\n"],
        ["hoge\n", "hoge\n"],
    ];
    for (my $i = 0; $i < scalar(@$inputs); $i++) {
        my @actual = ();
        foreach my $item (@{$inputs->[$i]}) {
            my $result = md2bl::md2bl($item);
            if ($result eq "") {
                next;
            }
            push(@actual, md2bl::md2bl($item));
        }
        for (my $j = 0; $j < scalar(@$expected); $j++) {
            if (@actual[$j] ne $expected->[$i]->[$j]) {
                print("$test_name failed.\n");
                print("actual: " . @actual[$j] . "\n");
                print("expected: " . $expected->[$i]->[$j] . "\n");
                exit(1);
            }
        }
    }
    print("$test_name succeeded!\n");
}

sub test_link2link {
    my @inputs = (
        "このバグについては、このページ https://backlog.com/ja/ が参考になります。",
        "このバグについては、このページ [Backlog](https://backlog.com/ja/) が参考になります。",
    );
    my @expected = (
        "このバグについては、このページ https://backlog.com/ja/ が参考になります。",
        "このバグについては、このページ [[Backlog>https://backlog.com/ja/]] が参考になります。",
    );
    exec_test((caller(0))[3], \@inputs, \@expected);
}

sub test_bold {
    my @inputs = (
        "これは**太字**です。"
    );
    my @expected = (
        "これは''太字''です。"
    );
    exec_test((caller(0))[3], \@inputs, \@expected);
}

test_indent2minus();
test_numbered_list();
test_ast2sqt();
test_hash2ast();
test_delete_empty_line();
test_link2link();
test_bold();

