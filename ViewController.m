//
//  ViewController.m
//  KTScrollNumbersLayer
//
//  Created by 谭林振 on 2017/2/16.
//  Copyright © 2017年 谭林振. All rights reserved.
//

#import "ViewController.h"
#import "KTScrollNumbersLayer/KTScrollNumbersLayer.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) KTScrollNumbersLayer *scrollNumbersLayer;
@property (strong, nonatomic) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollNumbersLayer = [[KTScrollNumbersLayer alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    self.scrollNumbersLayer.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.scrollNumbersLayer];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = (CGRect){140, 180, 60, 60};
    self.button.layer.cornerRadius = 0.6;
    [self.button setTitle:@"点我呀" forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(setTotalCount) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTotalCount {
    NSString *fromString = [NSString stringWithFormat:@"%d亿%d万", rand()%1000, rand()%1000];
    NSString *toString = [NSString stringWithFormat:@"%d亿%d万", rand()%1000, rand()%1000];
    NSLog(@"%@----%@", fromString, toString);
//    [self.scrollNumbersLayer animationFromString:toString];
    [self.scrollNumbersLayer animationFromString:fromString toString:toString];
}

@end
