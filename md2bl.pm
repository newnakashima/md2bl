package md2bl;

use strict;
use Exporter 'import';

our $table_mode = 0;
our $code_mode = 0;

sub get_eol {
    my $EOL = '\n';
    if ($^O eq 'msys') {
        $EOL = '\r\n';
    }
    return $EOL;
}

sub md2bl {
    my $line = shift;

    # コード行かどうかチェック
    if (check_code($line)) {
        $code_mode = !$code_mode;
        if ($code_mode) {
            $line = replace_code_lang($line);
        } else {
            $line = replace_code_end($line);
        }
    }

    if ($code_mode) {
        return $line;
    }

    # テーブル記法開始後でボーダーの場合は行を消す
    if ($table_mode && check_border($line)) {
        return;
    } 

    # テーブル記法が始まっているかどうかチェック
    if (!$table_mode && check_table($line)) {
        # ヘッダ行の印をつける
        $line = replace_table($line);
        $table_mode = 1;
    }

    if ($table_mode && check_table_end($line)) {
        $table_mode = 0;
    }

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

sub check_table {
    my $input = shift;
    return $input =~ /^\|.*\|/;
}

sub replace_table {
    my $input = shift;
    $input =~ s/^(\|.*\|)$/\1h/;
    return $input;
}

sub check_border {
    my $input = shift;
    return $input =~ /.*---.*/;
}

sub check_table_end {
    my $input = shift;
    return $input =~ /^[^|]/;
}

sub check_code {
    my $input = shift;
    return $input =~ /```/;
}

sub replace_code_lang {
    my $input = shift;
    $input =~ s/```(.*)$/{code:\1}/;
    $input =~ s/{code:}/{code}/;
    return $input;
}

sub replace_code_end {
    my $input = shift;
    $input =~ s/```/{\/code}/;
    return $input;
}

1;
