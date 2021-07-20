MVVMのコードを書いててScrollViewerのスライダーのOffsetがBindingできないくて困ったので共有

```C#
using System.Windows;
using System.Windows.Controls;

namespace View {
    public static class ScrollViewerBinding {
        #region VerticalOffset
        public static readonly DependencyProperty VerticalOffsetProperty =
            DependencyProperty.RegisterAttached("VerticalOffset", typeof(double),
            typeof(ScrollViewerBinding), new FrameworkPropertyMetadata(double.NaN,
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

## `Behavior<ScrollViewer>` を使った例

追記: `OnVerticalOffsetPropertyChanged` は実験した感じ初期化時の1度しか走らないと思うんだけどよく分からないので、`ScrollChanged` に複数callbackが登録されてしまうかもしれなくて、それは場合によってはそれは嬉しくないのでAttach/DetachのタイミングがはっきりしているBehaviorを使ったほうが良いかもしれない。

```C#
namespace View {
    public class ScrollViewerBehavior : Behavior<ScrollViewer> {
        public static readonly DependencyProperty VerticalOffsetProperty =
            DependencyProperty.Register("VerticalOffset", typeof(double), typeof(LVScrollEventHandlingBehavior), 
                new FrameworkPropertyMetadata(double.NaN, FrameworkPropertyMetadataOptions.BindsTwoWayByDefault, SetPosition)); 

        public double VerticalOffset {
            get { return (double) GetValue(VerticalOffsetProperty); }
            set { SetValue(VerticalOffsetProperty, value); }
        }
        private static void SetPosition(DependencyObject d, DependencyPropertyChangedEventArgs e) {
            if (d is ScrollViewer sv) {
                sv.ScrollToVerticalOffset((double)e.NewValue);
            }
        }
        protected override sealed void OnAttached() {
            base.OnAttached();
            this.AssociatedObject.ScrollChanged += OnScrollChanged;
        }
        protected override sealed void OnDetaching() {
            this.AssociatedObject.ScrollChanged -= OnScrollChanged;
            base.OnDetaching();
        }
        private void OnScrollChanged(object sender, ScrollChangedEventArgs e) {
            if (e.VerticalChange != 0) {
                VerticalOffset = e.VerticalOffset;
            }
        }
    }
}
```

```xaml
<UserControl
    x:Class="Sample.SampleControl"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:i="http://schemas.microsoft.com/expression/2010/interactivity"
    xmlns:local="clr-namespace:View">
    <ScrollViewer>
        <i:Interaction.Behaviors>
            <local:ScrollViewerBehavior VerticalOffset="{Binding ScrollVerticalOffset.Value}"/>
        </i:Interaction.Behaviors>
        <!-- something... -->
    </ScrollViewer>
</UserControl>
```

やっぱり内部の仕様を理解していない私からすると、WPFは勝手に色々生えてくるので難しい

### 参照

- Silverlight3.0で同じ問題について考察してるStackoverflow, Silverlight固有の問題ですごい複雑になってるけどWPFは上記のコードだけでOK <https://stackoverflow.com/questions/2096143/two-way-binding-of-verticaloffset-property-on-scrollviewer>

