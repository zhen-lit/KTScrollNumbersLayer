# KTScrollNumbersLayer

## 介绍
一个能够显示带单位（万～亿）数字滚动的控件，改变显示的数字时，会有一个滚动动画。<br>效果图<br>
![image](https://github.com/gymg/KTScrollNumbersLayer/blob/master/numbers.gif) 
<br>
## 使用
将KTScrollNumbersLayer文件夹中的两个文件复制进工程，在需要使用的地方导入头文件<br>
```Objective-c

#import "KTScrollNumbersLayer.h"

@interface ViewController ()

@property (strong, nonatomic) KTScrollNumbersLayer *scrollLabel;

@end

```
初始化的方法，设置其frame，因为它是根据字体大小自动计算自身的大小
```Objective-c
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollNumbersLayer = [[KTScrollNumbersLayer alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    [self.view addSubview:self.scrollNumbersLayer];
}
@end
```
当想要改变其数值时，调用下面方法即可,当animated参数为NO时不会播放动画
```Objective-c
[self.scrollNumbersLayer animationFromString:toString];
```


