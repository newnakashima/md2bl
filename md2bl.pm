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

    # 空白行を詰める
    $line = delete_empty_line($line);

    # リンク記法を変換
    $line = link2link($line);

    # 太字記法を変換
    $line = bold($line);

    # イタリックを変換
    $line = italic($line);

    # 見出しの記法を変換。*を変換したあとに行う
    $line = hash2ast($line);

    # 打ち消し線を変換
    $line = strikethrough($line);

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
    $input =~ s/(.*)\[(.*?)\]\((.*?)\)(.*)/\1\[\[\2>\3\]\]\4/;
    return $input;
}

sub bold {
    my $input = shift;
    $input =~ s/(\*\*)([^\*]*?)(\*\*)/''\2''/g;
    return $input;
}

sub italic {
    my $input = shift;
    $input =~ s/\*([^\*]*?)\*/'''\1'''/g;
    $input =~ s/(^|\s)_([^_]*?)_\s/'''\2'''/g;
    return $input;
}

sub strikethrough {
    my $input = shift;
    $input =~ s/~~([^~]*?)~~/%%\1%%/g;
    return $input;
}

1;
