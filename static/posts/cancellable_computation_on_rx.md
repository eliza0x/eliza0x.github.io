仕事でC#つかってWPF書いてます、ユーザー(UI)から飛んでくる重い計算のリクエストの扱いで少し困ったのでメモ。

具体的にはObservableで次々流れてくるリクエストの最新版だけを計算して、それ以外の計算はキャンセルする処理を書いてました。

```C#
Observable
    .Range(0, 10)
    .Select(i =>
    	Observable.StartAsync(async ct =>
            await Task.Run(() => HeavyFunction(i, ct)))
        .Switch())
    .Subscribe(o => /* somthing... */);
```

こういうふうに書くと, Task.Run内の計算が終わる前に次の値が流れた来た場合, SwitchでOnCompleteが呼ばれてCancellationTokenが呼ばれます。

Rxは難しいが、たぶんRxでやろうとしてることが難しいから仕方ないと思う。

