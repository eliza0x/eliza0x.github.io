今季は月曜日に大学の授業でめぼしいものがなかったため一つも取りませんでした。毎週三連休です、ギターの練習をしてみたり綿花を育てたり有益に過ごしています。

そんなかんじでたくさん時間が出来たのでちょっと頑張るかとプログラミング言語を作ってみました。Haskell, LLVMで出来ています。構造体を扱えるようになるのが当面の目標です。

- [eliza0x/cotton](https://github.com/eliza0x/cotton/)

mikan, tmpla, ときて自作プログラミング言語第三段です。LLVMの力を借りてようやくX86-64の上で動かすことが出来ました。感無量です。このまま適当に標準入出力を扱えるようになったり、適当にネットワークにつなげるようになると嬉しいですね。文字列とか構造体をいい感じに使いたいので今はGCの勉強をしようかなと思って図書館から本を借りてきたりしました。ネット上の記事を読んでいる限り参照カウンタぐらいなら実装出来るんじゃないかな〜とは思っています。

cottonの何よりイケイケなポイントはその小ささで、本体は1000行ぐらいしかありません、素敵ですね！

## ざっくりとした処理の流れ

- Tokenize
- Parse
- Alpha変換
- 型検査
- K正規化
- Closure変換
- IR -> LLVM IR (Assembly)の変換

以上です、変数の管理周りなど、かなり雑なLLVM IRを吐いていますがきちんと最適化を書けてくれるPASSの存在を確認しているのでたぶん速度的には全く問題が無いです。

LLVM IRの生成を行っているモジュールがかなり難解なコードになっているので整理したいですがなかなかむずかしくて困っています。あとK正規化周りのモジュール結合度も最悪なのでもう少し中間処理で使う構造体の定義をしっかり考え直したほうが良いかもしれませんね。

変数へのレジスタ割当やポインタの計算みたいな泥臭い面倒な処理を書かなくてよかったので今回のコンパイラは割とさくっと書けました。LLVMは偉大。

今回はLLVM IRを生で生成したのですが、Builderを使ったコードに置き換えたいなぁとも考えています。@theoldmoon0602によるとなかなか面白いらしくて勉強になるから一度は触れておけとのことです。

コンパイラを一度作ってみたい人はTAPLの初めの数章を読んで見るとか、min-camlにあたってみるとかすれば割と簡単に作れます。ほんとです。

## 使ったライブラリとか

### extensible

haskellのデータ型に不満があったのでfumievalさんの作った[extensible](https://hackage.haskell.org/package/extensible)を利用してみました。なかなか難解なライブラリで、ドキュメントを読むだけでは使えるようにならなかったので[fumievalさんのブログ](https://hackage.haskell.org/package/extensible)や[攻略Wiki](http://wiki.hask.moe/)とにらめっこしながら使ってみました。現状ではコードが余計に複雑になっただけのようにも思えますが、慣れてくるとかなり便利になる気もします。これは型レベルでゴリゴリやってるライブラリ全般に言えることなんですがエラーメッセージが難解になってしまうのがとてもつらい……。

``` haskell
{-
こんな感じのコードと同じ動きをする。
data Reg
    = Int  Number
    | Str  Str
    | Bool Bool
    | Null Null
-}
type Reg = Variant
    '[ "int"  >: Number
     , "str"  >: Str
     , "bool" >: Bool
     , "null" >: Null
     ]
```

レコード同士での部分型付けが自然に使えたり、フィールド名の重複が許されていたりしてここがすごくありがたいです。というかそのために使っている。

代償として失ったのはネストしたパターンマッチング、ちょっとつらい。

### happy

今回は言語のパースにパーサジェネレータを使ってみようと思って、GHCでも利用されているという[happy](https://www.haskell.org/happy/)を使ってみました。いやぁ、すごい楽、BNFっぽいものを書き下すだけでパーサが出来てしまったのでびっくりしました。完成したものもすごく早いので満足です。

[有志が翻訳したドキュメント](https://sites.google.com/site/paclearner/happy_jp)があったので、それを参考にコードを書きました。

``` 
-- 実際のコードを少し改変したもの
Term    : if Term '{' Stmts '}' else '{' Stmts '}' 
        { If  $2 $4 $8 (pos $1) } 
        | Lower '(' Calls ')'       
        { Call { var = $1, args = $3, pos = pos $1 } }
        | '(' Term ')'              { $2 }
        | '{' Terms '}'             { $2 }
        | str                       { Str $1 }
        | Num                       { Int $1 }
        | Lower                     { Var $1 }
```

欠点として、生のHaskellではないため少し柔軟性に劣る感じがありました。

### alex

今回は式をいきなりパースせずにtokenizeもきちんと行いました、空白や改行の扱いが楽で良かった。おそらくきちんと前処理を行ったほうが計算量も落とせるんじゃないかな。

こちらは有志の翻訳を見つけることが出来なかったので[公式のドキュメント](https://www.haskell.org/alex/doc/html/index.html)を読みました。

トークンを定義してあげるだけで基本的にほとんどやることはないです。楽で良い。

``` 
$digit = 0-9
$opchar = [\!\#\$\%\&\*\+\.\/\<\=\>\?\@\\\^\|\-\~]
$alpha       = [A-Za-z\_]
$upper       = [A-Z]
$lower       = [a-z\_]
$labelchar   = [A-Za-z0-9\_]

tokens :-
    $white+  ;
    "#".*    ;
    "def"    { tok (\p _ -> Def        (Pos p) )       }
    "`"      { tok (\p _ -> BackQuote  (Pos p) )       }
    "'"      { tok (\p _ -> Apostrophe (Pos p) )       }
    "("      { tok (\p _ -> LParen     (Pos p) )       }
    ")"      { tok (\p _ -> RParen     (Pos p) )       }
    "{"      { tok (\p _ -> LBrace     (Pos p) )       }
    "}"      { tok (\p _ -> RBrace     (Pos p) )       }
    "["      { tok (\p _ -> LBracket   (Pos p) )       }
    "]"      { tok (\p _ -> RBracket   (Pos p) )       }
    ","      { tok (\p _ -> Comma      (Pos p) )       }
    ":"      { tok (\p _ -> Colon      (Pos p) )       }
    ";"      { tok (\p _ -> Semicolon  (Pos p) )       }
```

### optparse-declarative

コマンドラインパーサとして[optparse-declarative](https://hackage.haskell.org/package/optparse-declarative)を利用しました。

たった数行書くだけで下のようなイケイケCLIを作ることが出来ます。作者のtanakhさんが書いた[チュートリアル](https://qiita.com/tanakh/items/b6ea4c65d8ed511ac98d)がやさしいのでこれを読むといいでしょう。

```
eliza% cotton --help
Usage: cotton [OPTION...] <COMMAND> [ARGS...]
  foo

Options:
  -?     --help         display this help and exit
  -v[n]  --verbose[=n]  set verbosity level

Commands: 
  run         execute source code
  debug       execute source code (verbose)
```

## おわりに

より詳しいコンパイラ内部の処理の話もいずれ書きたいと思っています。現状仕組みが気になる人は私のソースコードを読んでください、かなり酷いかもしれませんが。

なんとなく思い立ってプログラミング言語が作れるほどライブラリやドキュメントが充実している現状に感謝です。明日は英語の試験、全然勉強してねぇ……。

