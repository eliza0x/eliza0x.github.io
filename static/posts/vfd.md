この記事は[Kosen14s Advent Calender 2017 24日目](https://adventar.org/calendars/2388)の記事です。

ごめんなさい！ここ最近色々忙しくしていたので投稿が遅くなってしまいました。

ところで皆さん蛍光表示管ってご存知ですか？こんなやつなんですけど。

![蛍光表示管](/static/images/vfd_sample.png)

<s>画像検索で出て来た素材を使っているのには目をつぶってください</s>

ニキシー管よりは新しいそうですが、LED等よりは古そうですね、構造的には真空管に近いので、駆動するのに大電圧が必要になってしまうので苦労します。

このグリーンの何とも言えない光にメチャメチャロマンを感じたので何か作ってみたくなったのでジャンクの9桁の蛍光表示管を買ってしまいました。

## 問題発生

ところで勝ったはいいものの

<b>何を作ったらいいんだ</b>

おいオタクそういうとこやぞ、取り敢えず定番の時計でも作ってみることにしましょう。

## 作業風景

手抜きとも言う

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">蛍光表示管動作テスト <a href="https://t.co/VEe14V5g0a">pic.twitter.com/VEe14V5g0a</a></p>&mdash; いらいざ (@Eliza_0x) <a href="https://twitter.com/Eliza_0x/status/944538597293662208?ref_src=twsrc%5Etfw">2017年12月23日</a></blockquote>

取り敢えず動いて安心です。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">マルチプレクサの挙動が思っていたのと逆でなすすべもなくぼんやりしている <a href="https://t.co/hJI2ItMqLJ">pic.twitter.com/hJI2ItMqLJ</a></p>&mdash; いらいざ (@Eliza_0x) <a href="https://twitter.com/Eliza_0x/status/944582026409021442?ref_src=twsrc%5Etfw">2017年12月23日</a></blockquote>

蛍光表示管には脚が22本も生えているんですが、全部マイコンから直接制御するには足が足りないので、3-to-8デコーダや、シフトレジスタを用いて制御しました。3-to-8デコーダを初めて使ったのですが、予想したいたものと出力が逆で驚きました。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">回路のガバってた部分直したらちゃんと輝度が出て喜んでます <a href="https://t.co/ubPu7ZhHsT">pic.twitter.com/ubPu7ZhHsT</a></p>&mdash; いらいざ (@Eliza_0x) <a href="https://twitter.com/Eliza_0x/status/944924026543079424?ref_src=twsrc%5Etfw">2017年12月24日</a></blockquote>
朝起きて昨日試しに組んだ回路をみたら、蛍光表示管をトランジスタのEからの出力で駆動していたので、Cからの出力に変更したら輝度がきちんとでるようになった。

## 回路図

ガバいとおもうけどゆるして

![蛍光表示管](/static/images/vfd_circuit.svg)

kicadで書きました、ブログに挙げるなら可愛いfritzingで書けばよかったと後悔。

## 現状

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">お分かりいただけただろうか <a href="https://t.co/eUYUVZH2Aw">pic.twitter.com/eUYUVZH2Aw</a></p>&mdash; いらいざ (@Eliza_0x) <a href="https://twitter.com/Eliza_0x/status/945001888725975041?ref_src=twsrc%5Etfw">2017年12月24日</a></blockquote>

人生は、つらく、きびしい

## あとがき

かっこいいものができたらツイッターでじまんします。
