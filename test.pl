package Test;

use strict;
use lib '.';
use md2bl;

our $has_error = 0;

sub succeed {
    print(".");
}

sub fail {
    my ($test_name, $actual, $expected) = @_;
    print("\e[1m\e[31m$test_name failed.\n\e[m");
    print("\e[31mactual: $actual\n");
    print("expected: $expected\n\e[m");
    $has_error = 1;
}

sub exec_test {
    my ($test_name, $inputs, $expected) = @_;
    for (my $i = 0; $i < @$inputs; $i++) {
        my $actual = md2bl::md2bl($inputs->[$i]);
        if ($actual ne $expected->[$i]) {
            fail($test_name, $actual, $expected->[$i]);
        }
    }
    succeed();
}

sub exec_test_refarray {
    my ($test_name, $inputs, $expected) = @_;
    for (my $i = 0; $i < scalar(@$inputs); $i++) {
        my @actuals = ();
        foreach my $item (@{$inputs->[$i]}) {
            my $result = md2bl::md2bl($item);
            if ($result eq "") {
                next;
            }
            push(@actuals, $result);
        }
        for (my $j = 0; $j < scalar(@{$expected->[$i]}); $j++) {
            if ($actuals[$j] ne $expected->[$i]->[$j]) {
                fail($test_name, $actuals[$j], $expected->[$i]->[$j]);
            }
        }
    }
    succeed();
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
    exec_test_refarray($test_name, $inputs, $expected);
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

sub test_italic {
    my @inputs = (
        "これは*斜体文字*です。",
        "これは_斜体文字_ではありません。",
        "これは _斜体文字_ です。",
        "_斜体文字_ です。",
    );
    my @expected = (
        "これは'''斜体文字'''です。",
        "これは_斜体文字_ではありません。",
        "これは'''斜体文字'''です。",
        "'''斜体文字'''です。",
    );
    exec_test((caller(0))[3], \@inputs, \@expected);
}

sub test_strikethrough {
    my @inputs = (
        "これは~~打ち消し線~~です。",
    );
    my @expected = (
        "これは%%打ち消し線%%です。",
    );
    exec_test((caller(0))[3], \@inputs, \@expected);
}

sub test_table {
    my $test_name = (caller(0))[3];
    my $inputs = [
        [
            "| header1 | header2 |",
            "| --- | --- |",
            "| data1 | data2 |",
        ],
    ];
    my $expected = [
        [
            "| header1 | header2 |h",
            "| data1 | data2 |",
        ],
    ];
    exec_test_refarray($test_name, $inputs, $expected);
}

sub test_code {
    my $test_name = (caller(0))[3];
    my $inputs = [
        [
            "```java",
            "    package helloworld;",
            "    public class Hello {",
            "        public String sayHello {",
            "            return \"Hello\";",
            "        }",
            "    }",
            "```"
        ],
        [
            "```",
            "    const hoge = 100;",
            "    const fuga = hoge * 2",
            "    console.log(`fuga is \$\{fuga\}.`)",
            "```",
        ],
    ];
    my $expected = [
        [
            "{code:java}",
            "    package helloworld;",
            "    public class Hello {",
            "        public String sayHello {",
            "            return \"Hello\";",
            "        }",
            "    }",
            "{/code}",
        ],
        [
            "{code}",
            "    const hoge = 100;",
            "    const fuga = hoge * 2",
            "    console.log(`fuga is \$\{fuga\}.`)",
            "{/code}",
        ],
    ];
    exec_test_refarray($test_name, $inputs, $expected);
}

sub test_index {
    my $test_name = (caller(0))[3];
    my @inputs = (
        '[toc]',
    );
    my @expected = (
        '#contents',
    );
    exec_test($test_name, \@inputs, \@expected);
}

sub test_br {
    my $test_name = (caller(0))[3];
    my @inputs = (
        'aaa<br>bbb',
    );
    my @expected = (
        'aaa&br;bbb',
    );
    exec_test($test_name, \@inputs, \@expected);
}

# test_.+ 形式の名前を持つ関数を動的に実行する。順不同。
foreach my $entry ( keys %Test:: ) {
    no strict 'refs';
    if (defined &{"Test::$entry"} && $entry =~ /^test_/) {
        &{"Test::$entry"}();
    }
}

print("\n");

if ($has_error) {
    exit(1);
}

print("\e[42m\e[37m\e[1mAll tests are OK!!\e[m\n");

