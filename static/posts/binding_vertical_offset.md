MVVMのコードを書いててScrollViewerのスライダーのOffsetがBindingできないくて困ったので共有

```C#
using System.Windows;
using System.Windows.Controls;

namespace View {
  public static class ScrollViewerBinding {
    #region VerticalOffset
    public static readonly DependencyProperty VerticalOffsetProperty =
      DependencyProperty.RegisterAttached(
        "VerticalOffset",
        typeof(double),
        typeof(ScrollViewerBinding),
        new FrameworkPropertyMetadata(double.NaN,
          FrameworkPropertyMetadataOptions.BindsTwoWayByDefault,
          OnVerticalOffsetPropertyChanged));

    public static double GetVerticalOffset(DependencyObject depObj) {
      return (double)depObj.GetValue(VerticalOffsetProperty);
    }

    public static void SetVerticalOffset(DependencyObject depObj, double value) {
      depObj.SetValue(VerticalOffsetProperty, value);
    }

    private static void OnVerticalOffsetPropertyChanged(DependencyObject d, DependencyPropertyChangedEventArgs e) {
      if (d is ScrollViewer scrollViewer) {
        scrollViewer.ScrollToVerticalOffset((double) e.NewValue);
        scrollViewer.ScrollChanged += (s, se) => {
          if (se.VerticalChange != 0) SetVerticalOffset(scrollViewer, se.VerticalOffset);
        };
      }
    }
    #endregion
  }
}
```

これを定義しておくと以下のようなコードで使えるようになる。

```xaml
<UserControl
    x:Class="Sample.SampleControl"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:local="clr-namespace:View">
    <ScrollViewer local:ScrollViewerBinding.VerticalOffset="{Binding ScrollVerticalOffset.Value}">
        <!-- something... -->
    </ScrollViewer>
</UserControl>
```

HorizontalOffsetも同じような感じで定義できると思います。

WPF(というかxaml?)って静的に検証してくれないうえにエラーもまともに吐いてくれないしめちゃめちゃしんどくない？使い方が悪いんだろうか？というかユーザーがリフレクションを書く前提のAPIなのどうにかならなかったのか……

### 参照

- Silverlight3.0で同じ問題について考察してるStackoverflow, Silverlight固有の問題ですごい複雑になってるけどWPFは上記のコードだけでOK <https://stackoverflow.com/questions/2096143/two-way-binding-of-verticaloffset-property-on-scrollviewer>

