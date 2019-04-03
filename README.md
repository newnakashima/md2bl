# Markdown to Backlog

[![CircleCI](https://circleci.com/gh/newnakashima/md2bl.svg?style=svg)](https://circleci.com/gh/newnakashima/md2bl)

Markdown記法をBacklog記法に変換するPerlスクリプトです。

使用例

```
$ git clone https://github.com/newnakashima/md2bl.git
$ cd md2bl
$ ./md2bl example.md
```

結果は下記の通りです

```
#contents
* 見出し1
** 見出し2
*** 見出し3
- リストレベル1
-- リストレベル2
--- リストレベル3
+ 番号付きリストレベル1
++ 番号付きリストレベル2
+++ 番号付きリストレベル3
++ 番号付きリストレベル2
+ 番号付きリストレベル1
[[googleへのリンク>https://www.google.co.jp]]
これは''太字''です。
これは'''斜体'''です。
これも'''斜体'''です。
これは_斜体_ではありません。
'''斜体'''です。
これは%%打ち消し線%%です。
| header1 | header2 | header3 |h
|これは|テーブル|です|
{code:java}
    package helloworld;
    public class Hello {
        public String sayHello {
            return "Hello";
        }
    }
{/code}
普通のコードブロックです。
{code}
    const hoge = 100;
    const fuga = hoge * 2;
    console.log(`fuga is ${fuga}.`);
{/code}
```

