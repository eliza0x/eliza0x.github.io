仕事C#つかってWPF書いてます、ユーザー(UI)から飛んでくる重い計算のリクエストの扱いで少し困ったのでメモ。

具体的にはObservableで次々流れてくるリクエストの最新版だけを計算して、それ以外の計算はキャンセルする処理です。

```C#
Observable
    .Range(0, 10)
    .Select(i =>
        Observable.StartAsync(async ct => {
            await Task.Run(() => SomeFunction(i, ct))
        }).Switch()
    ).Subscribe(o => SomeFunction(o));
```

こういうふうに書くと, Task.Run内の計算が終わる前に次の値が流れた来た場合, SwitchでOnCompleteが呼ばれて, CancellationTokenが呼ばれます。

Rxは難しいが、たぶんRxでやろうとしてることが難しいから仕方ないと思う。
