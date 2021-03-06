一年もあっという間ですね、去年ICPCで全然分からなくて悔しい思いをしたのがつい最近のようです。本当にあっという間でした。大学の四年間は短いと聞いていたけど、この調子でいくと短いなんてもんじゃなさそうです。

## イカれたメンバーを紹介するぜ

弊学の二軍チーム『Incoming tomoya』です、チーム名はOBのodan氏から借りております。自称ポテンシャルの塊。全員AtCoderで緑なんですけどだいたい水色パフォーマンス出してるみたいです。早く水色になりたい。

### 隊長(xztaityozx)

私の居候している研究室の院生であり、私の師匠でもあります。私との一糸乱れぬ連携はどんな問題であろうとたちまち子猫が毛糸と戯れたような趣を見せ、言外のコミュニケーションは絶え間なく意図せぬ確信を生み、我々を混沌のさなかに誘い込みます。

普段はシェルスクリプトで危険なコマンドを隠蔽して実行させたりする術を研究したりしているみたいです。競技プログラミングではC#をつかっているようです。経験豊富です。

- [ICPC2018国内模擬に参加しました - たいちょーの雑記](http://xztaityozx.hatenablog.com/entry/2018/07/02/235222)

### wheson

競技プログラミングサークルのボスで、学部四年生です。優秀な人で、去年末には既に就職先が決まったと言って居た気がします、時間が歪んでるんでしょうか？自己啓発本を盲信したり、友人に勧めてまわるのはやめたほうが良いと思います。

ICPC直前なので沖縄まで卒業旅行に行ってるみたいです、許しません。競技プログラミングではC++を使っているようです。アルゴリズム等の幅広い知識を持っています。

### いらいざ(eliza0x)

わたしです、二人とくらべると実装力や知識は劣るので天性の才能でカバーしようと思います。コンパイラを作ったりしているので構文解析問題がきたら投げつけられる約束になっています、つらいです。

普段は寝たりギターを弾いたりしています、ツイッターに自作のポエムを投稿するのが趣味です。競技プログラミングではHaskellを使っていますが、信じきれなくなった時だけC++を書くことがあります。

## 文化の壁

無数に立ちはだかっていますが、キリがないので三つに絞ります。

### 入力の壁

USキーボード勢(wheson, eliza0x)とJPキーボード勢(xztaityozx)が居て初めての模擬戦(ICPC国内模擬予選以前に学内で行った)で大変ストレスを味わったため、xztaityozxが解決策を用意してくれていました。

**Fcitxのモード手動切り替え** で対処するのが簡単かつベターっぽいそうです。

つらくない？

### 言語の壁

ICPCでは使用可能な言語が制限されている(C, C++, Java, Python3, etc...)ため、普段C++を書かない人々(eliza0x, xztaityozx)が意図せぬ挙動で苦労しています。コンパイルは通るのに実行した途端に死ぬのやめて。C++に翻弄されることは競技プログラミングの本質ではない。

当然eliza0x, xztaityozxのライブラリも使えないためwhesonのライブラリで挑むことになります。ひょっとして幾何問題が来たらwheson以外太刀打ち出来ないんじゃないのか……

### エディタの壁

運良く全員vimmerなんですが、xztaityozxの設定ファイルを共有したところsurround.vimが無かったり、sがリーダーにバインディングされていたり、ESCに謎のバインディングが施されていてかなり辛かったので、本番は個々人専用のDockerコンテナを建てて作業を行いました。xztaityozxが環境を頑張って整えてくれたので本当に助かりました。

## 模擬予選の記録

ICPCは180分の長丁場になります。時間はwheson氏が記録してくれたものに基づきます。知らない間に記録していたので驚いた。

#### 0min

Aがやるだけっぽそうなので一番実装の早いwhesonが担当することに。この間に私とxztaityozxが問題をよんでおくことに、B問題の日本語が難解だったので数式に起こす。C問題がBNFだったとxztaityozxから報告を受ける。

#### 15min

C問題を読んだ私は少し式を整理したあと再帰降下法を書き始める。書き出しは順調でイケイケになる。

#### 45min~

ここらへんで一通り実装が終わってコンパイルを通すとものすごいエラーが出てパニックになる。黙々と再帰式のlambdaの型をautoから明示的なものに書き換えたり(C++は再帰的に定義されたlambda式の型を推論できないらしい)templateで決定不能と言われた部分を書き換えたりしはじめる、一行治すとエラーメッセージが全くちがったものになるのなんなの。

#### 60min

```
function<int(int)> fact = [=](int n){
    return n==0 ? 1 : n * fact(n-1);
};
```

これ実行すると即死するんですよ、理由がわかりますか？僕は分からなくてここらへんから感情がなくなります。しかも実際のコードは200行ぐらいあったので何が原因かもよくわからないんですよね。黙々とcoutを仕込んで問題箇所の二部探索を初めます。あ、どうも上記のコードで言うfactの呼び出し辺りで死んでいるな、でもfactの呼び出し周りおかしいこと無いしな……。(原因は後で書きます)感情がなくなります。

#### 90min

ここらへんで選手交代を命じられたので書いていたプログラムを印刷してxztaityozxにマシンを譲る。なんでバグってるんだろうな〜〜みたいな話をwhesonに持ちかけるもlambdaを普段使い慣れていないようで虚無みたいな顔をされる。感情がなくなる。

#### 105min

xztaityozxが実装をすすめる横でヤバそうな箇所に口を出したり、実装の相談を受けたりする。私が問題を誤解していたためミスディレクションをけしかける。隊長が些細なバグ(本来intとすべきところをboolと書いていた)を仕込んでいたが当時気付けなかったので選手交代になる。私が永遠にプログラムをバグらせている間に考察が終わっていたらしくwhesonが猛烈な勢いで実装を初める。

#### 130min

whesonの実装が終わるもサンプルケースが合わない。直感でプログラムを書いていたため考察に自信もなかったらしいので一度交代してもらう。

#### 150min

C問題のプログラムで関数呼び出し以外はバグっていない確信を得たので。ラムダ式で書いていた部分を生の関数に書き換えて細かいバグを修正するとACする、この時点で2ACはまずいよなぁみたいな話をする。ストレスで胃が猛烈に痛くなる。感情が少し帰ってくる。

#### 170min

xztaityozxがプログラムのバグを取り除く。隊長が作業をしている後ろでwhesonの考察に間違いがなさそうな事を確認する。

#### 170min〜

whesonが写経のミスに気がつきはじめる。隊長が真横で過呼吸のモノマネをし始める。whesonが本気で動揺しているので感情を殺して永遠に「落ち着いて」を連呼する。

#### 178min

whesonがすごい勢いですべてのバグをfixしACする。本当にかっこいいと思った。直後にイキり始めたのが面白かった。

#### 終了後

学内一位、国内予選突破県内であることを知る。whesonがchocobo相手にイキるかイキらないか悩んで居るのが見ていて面白かった。一年生にC++でこんなコードを書いたら意味のわからない挙動を示したとぼやいて慰めてもらう。

## 感想

xztaityozxのバグは私に起因している上に、私の担当したプログラムでオーバーキル解を使って時間を猛烈に消費して、そのうえバグにも冷静に対処できなかったので反省している。これが本番でなくてよかった。

他の人たちはどうか知らないけど、私自身はチームの雰囲気がすごく気に入っていて、ずっとこの人たちとプログラミング出来たら良いなと思っている。

## バグの原因

追記です、記事公開後に書き忘れていたことに気が付きました。

```
function<int(int)> fact = [&](int n){
    return n==0 ? 1 : n * fact(n-1);
};
```

こうすることで正常に動きます。

```
function<int(int)> fact;
fact = [&](int n){
    return n==0 ? 1 : n * fact(n-1);
};
```

こうすることで理解できるでしょうか？コピーでキャプチャすると右辺の式が代入される前のundefinedのfactがコピーされることで謎の動作を起こしていたようです。来年から弊競技プログラミングチームで一年生に教える言語でC++を選択するのやめませんか。

