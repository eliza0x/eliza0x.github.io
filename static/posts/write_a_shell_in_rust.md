私が入門した際の記録です、Shellを作りたい人に参考になりそうな情報はあまりないと思います。成果物は[ここ](https://github.com/eliza0x/esh)、esh(今回作ったやつの名前)のeはハンドルネームのelizaとエチュードの頭文字です。

## Shell作れそうな気がするな

私は今大学生でコンピューター科学科のお世話になっている(ところでこの学科名は去年に情報知能学科に変更された、私はCSのほうがカッコいいと思うのだけれど)。大学では二年目にショボめのOSの講義があった。私はそれをダルいなぁと思いながら受講していた。当時先生の板書をぼんやり見ながら「記憶の残っているうちになにか手を動かして習ったことを復習したほうがいいなぁ」と思っていたことを覚えているが、ショボい大学生のわたしは結局何もしなかった。

最近になってネットサーフィンしていると「[Write a Shell in C](https://brennan.io/2015/01/16/write-a-shell-in-c/)」なる記事にたどり着いた。英語を読むのは苦手なのでGithubに公開されているソースコードを読みに行くと

- 行入力読み込み
- パース(パイプやリダイレクトなど構文らしきものを実装しない限り空白分割で良い)
- fork()で子プロセスを作る
- exec()に食わせて`/bin/` 以下のコマンドを実行

しているだけであることがわかった。システムコールはまあドキュメントをちょっと読めば最低限使えるだろうし、パイプやリダイレクト、環境変数など必要そうなものは欠けているがこれを実装すればShellだと名乗れなくもない。まあパイプやリダイレクトは実装できそうな気もするし、それにifなどをデフォルトでわかりやすい構文で作れば個性を出すこともできるだろう、就活も近いのでいいネタだ。

## Rust入門

さあ実装するか、`malloc`,`free`とかもう触りたくないな、C++で書こうかな、いやもうポインタあんまり触りたくないな、そういや前Rust書こうとした事があったけどプロジェクト自体が流れちゃったな、ということでRustで書くことにしました。以前公式ドキュメントをざっくり読んでいたのでRustを書くこと自体はやたら親切なコンパイラ(本当にエラーメッセージが親切)に助けられながらこなすことができました。

結果として面白かったけど後悔と幻滅がちょっとってかんじです。Rustに強い期待と幻想を抱いていたので。セミコロンが `a -> b -> b` の関数みたいな動きをするのは面白いですね、TaPLで命令形言語の型付けについての章で同じことをしていて感心したのを思い出しました。ちょっと不思議に思ったり不便したりしたけどトータルで見ると面白い言語だなって思いました。Rustの自動生成されるドキュメントは読みやすくていいですね。

### lifetimeの罠

文字列を分割する関数を書きたくなりました。

```rust
fn split_line(line: String) -> Vec<&str> {
    line.split_whitespace().collect()
}
```

これ駄目らしいです。まあわかってしまえば簡単なんですが

```rust
fn split_line<'a>(line: &'a String) -> Vec<&'a str> {
    line.split_whitespace().collect()
}
```

で通ります。strがStringの参照なのは分かるのでlineとVecの要素のライフタイムが一緒になってほしいのは当然ですが、概念的にライフタイムを知っていてもまともに書いたのが初めてなので苦労しました。

### print!だとバッファがフラッシュされない罠

プリンタがディスプレイだった時代みたいで楽しいですね。

```rust
print!("hello");
io::stdout().flush().unwrap();
```

そういやC++でも `std::endl` がバッファのフラッシュもしてるって話ありましたね……

### staticがショボい

グローバルでShellの組み込み関数の名前と実態をリンクさせるための連想配列を持ちたかったので

```rust
static buildin_functions: BTreeMap<&str, fn(Vec<&str>) -> i32> = [
    ("cd", cd),
    ("help", help),
    ("exit", exit),
].iter().cloned().collect();
```

みたいに書きたかったけど、`calls in statics are limited to constant functions, tuple structs and tuple variants` って言われて駄目だった。あと関数ポインタも型が合わなくて明示的に `fn(Vec<&str>) -> i32` にキャストしないと駄目らしい。

`static` がショボい問題は検索すると `lazy_static` ってマクロがcrates(ライブラリがまとめられたリポジトリ)にアップロードされてるからそれを使うといいということだった。

結果的に以下のようなコードになった。

```rust
lazy_static! {
    pub static ref BUILDIN_FUNCTIONS: HashMap<&'static str, fn(Vec<&str>) -> i32> = [
        ("cd",   buildin_cd   as fn(Vec<&str>) -> i32),
        ("help", buildin_help as fn(Vec<&str>) -> i32),
        ("exit", buildin_exit as fn(Vec<&str>) -> i32)
    ].iter().cloned().collect();
}
```

### Cとの共存

はじめSystem Callを叩くためにlibcをほぼ生で叩こうかとおもっていた([薄いwrapper](https://docs.rs/libc/0.2.65/libc/)がある)が、どうもポインタっぽいやつが型から見え隠れしていたのでwrapperをさがしたところ[nix](https://docs.rs/nix/0.15.0/nix/)というパッケージがあった。関数型言語らしくwrapされていて、Result型とパターンマッチの強力さを再確認した。

Cだと`fork()`のコードはこうなると思う。

```cpp
pid = fork();
if (pid == 0) {
  // Child process
} else if (pid < 0) {
  // Error forking
} else {
  // Parent process
}
```

nixだとResult型に包まれて帰ってくるので以下のように書ける。

```rust
match fork() {
    Ok(ForkResult::Parent {child, .. }) => 
        // Parent process
    Ok(ForkResult::Child) => 
        // Child process
    Err(_) => 
        // Error forking
}
```

文字列を`execvp`に渡すために`String`を`CString`に変換する作業等があって少々面倒だったが、文字列の配列を渡すためにポインタのポインタを触る羽目にならずにすんで胸をなでおろした。

しかしRustでたまに起こってるっぽい型の暗黙の変換っぽいやつの挙動がよくわかっていない、近いうちにリサーチしたい(Vecがスライスに変換されていたり)。


## おわりに

1時間ちょっともあればpipeまで実装できるかと思っていたのにRustの入門から入ってしまったので昼過ぎに起きたあとから今まで掛かってしまった、そのうえpipeも実装できていない。近いうちに肉付けしようと思っている。

おやすみなさい。

