package md2bl;

use strict;
use Exporter 'import';

sub get_eol {
    my $EOL = '\n';
    if ($^O eq 'msys') {
        $EOL = '\r\n';
    }
    return $EOL;
}

sub md2bl {
    my $line = shift;

    # 番号付き箇条書きを変換
    $line = numbered_list($line);

    # インデント（半角スペース4個）を変換
    $line = indent2minus($line);

    # 太字の記法を変換
    $line = ast2sqt($line);

    # 見出しの記法を変換
    $line = hash2ast($line);

    # 空白行を詰める
    $line = delete_empty_line($line);

    # リンク記法を変換
    $line = link2link($line);

    return $line;
}

sub indent2minus {
    my $input = shift;
    $input =~ s/\s{4}/-/g;
    return $input;
}

sub numbered_list {
    my $input = shift;
    $input =~ s/\d+\./+/;
    if ($input =~ /^(\s{4})+\+/) {
        $input =~ s/\s{4}/+/g;
    }
    return $input;
}

sub ast2sqt {
    my $input = shift;
    $input =~ s/\*\*(.*)\*\*/''\1''/g;
    return $input;
}

sub hash2ast {
    my $input = shift;
    $input =~ /^(#+)\s/;
    my $matched = $1;
    my $asts = $matched;
    $asts =~ s/#/*/g;
    $input =~ s/${matched}/${asts}/;
    return $input;
}

sub delete_empty_line {
    my $input = shift;
    my $EOL = get_eol();
    if ($input !~ /^\s*${EOL}/) {
        return $input;
    } 
    return;
}

sub link2link {
    my $input = shift;
    if ($input =~ /(.*)\[(.*?)\]\((.*?)\)(.*)/) {
        return "$1\[\[$2>$3\]\]$4";
    }
    return $input;
}

1;
