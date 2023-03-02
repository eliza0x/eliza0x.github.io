[BOOM(Barkeley Out of Order Machine)](https://boom-core.org/)はBarkeley Architecture Reserchの設計したCPUで、スーパースカラ、OoO、投機的実行等をサポートしており、[Chisel](https://www.chisel-lang.org/)^[Scala上のDSLとして構築されたハードウェア記述言語]で設計されたRISC-V ISA^[オープンソースのRISC命令セット]のCPU で、設計の上ではMIPS R10000(以降R10K)とAlpha21264のアーキテクチャに大きく影響されているらしい。

[R10Kのアーキテクチャについては以前軽く書いた](https://eliza.link/#/posts/r10k.html)ので、それを参考にしてほしい。

BOOMの資料は[RISCV-BOOM’s documentation](https://docs.boom-core.org/en/latest/sections/intro-overview/boom.html)か[BOOM Specification](https://github.com/ccelio/riscv-boom-doc/raw/gh-pages/boom-spec.pdf)に公式が詳しい資料をまとめてくれている(BOOM Specificationしかよんでいない)。私はキャッシュやバスに関心がなかったので計算に使っているアーキテクチャのみについて調べたが、ざっくりと読んだ感じだとMIPS R10Kのアーキテクチャにほぼ相似していた。

# Architecture概観

RISCV-BOOM’s documentationにアーキテクチャとパイプラインの外観図がある。

![アーキテクチャの外観図](/static/images/boom/architecture.png)

![パイプラインの外観図](/static/images/boom/pipeline.png)


この図を見ると4命令同時発行だが、2命令同時発行版もあるらしい。ぱっと見た感じR10Kとの違いとしてROBの存在が挙げられる。

BOOMは開発中で、本当は10段のステージに分けたいんだけど、6段にしか分けられていないとBOOM Specificationにあるので、もっと性能が上がるのかもしれない。

> Conceptually, BOOM is broken up into 10 stages: Fetch, Decode, Register Rename, Dispatch, Issue, Register Read, Execute, Memory, Writeback, and Commit. However, many of those stages are combined in the current implementation, yielding six stages: Fetch, Decode/Rename/Dispatch, Issue/RegisterRead, Execute, Memory, and Writeback (Commit occurs asynchronously, so I’m not counting that as part of the “pipeline”).

現時点での性能計測は[msyksphinzさんが行ってくれている](https://msyksphinz.hatenablog.com/entry/2016/12/12/000000)。

## Active Listの不在

Register Renaming(RR)は名前依存^[ヘネパタに詳しく書いてるので参照してほしい]を解決してILPを上げる手法のひとつで、RRで投機的実行をサポートする手法は大別するとExplicit Register RenamingとImplicit Register Renamingが存在する。このCPUのアーキテクチャはExplicit Register Renamingをを採用しているらしい。

Explicit Register Renamingでin-flightな命令のdestination registerの管理にR10KではActive Listというリストを管理に使っていたが、BOOMではROBがR10KのActive Listの仕事をしている。たしかにこれを採用すると例外、レジスタ、メモリの開放の処理が簡単そうに見える。

## Issue Policies

BOOMには2つのIssue Policieがある^[BOOM SpecificationのP37, The Issue Unitの章]。

1. Un-ordered Issue Window: R10KスタイルのIssue Window内ではじめに発行可能になった命令を発行するスタイル、効率が悪いと書いてある
2. Age-ordered Issue Window: Issue Window内で最も古い命令から発行するスタイル、電力消費がひどいと書いてある

Age-Ordered Issue Windowはどうやって古さを保持しているんだろうか？実装を読むといいかもしれない。

しかしこれ、Issue WindowをQueueにしてしまえばかんたんだと思うんだけど、詰める処理がどの命令を発行するかが決定した後にしかできないから複雑になって駄目なんだろうか……？

# さいごに

R10Kの批判点などを知らないのでどう改善されたのか等がわからない……(あと資料内でAlpha21264について触れられていないのも気になった)。

ROBのアイデアは実装が楽になりそうなので今作ってるCPUでも採用しようと思う、次はAlpha21264の資料をもう一度読んでみるかR10Kの批判点についての資料を探すか、Mike JohnsonのSuperScala Processorに書かれていたFuture Fileを実装しているらしいAMD K7についての資料を調べてみたい。研究室のボスはSPARCのCPUに実装されていたRegister Windowという仕組みが面白いと言っていたしアレも調べてみたい。

