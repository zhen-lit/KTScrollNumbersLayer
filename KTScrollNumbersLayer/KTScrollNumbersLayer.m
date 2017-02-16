//
//  BANumberAnimatedView.m
//  PersonToPerson
//
//  Created by abel on 16/4/13.
//  Copyright © 2016年 abel. All rights reserved.
//

#import "KTScrollNumbersLayer.h"

@interface KTScrollNumbersLayer() {
    NSMutableArray *numbersMutableArray;
    NSMutableArray *charsMutableArray;
    NSMutableArray *scrollLayersMutableArray;
    NSMutableArray *scrollLabelsMutableArray;
    NSMutableArray *imageViewsMutableArray;
    NSMutableArray *numberLabelsMutableArray;
}

@property (assign, nonatomic) KTScrollNumbersLayerType type;
@property (strong, nonatomic) NSString *fromString;
@property (strong, nonatomic) NSString *toString;
@property (assign, nonatomic) CFTimeInterval duration;
@property (strong, nonatomic) UIColor *textColor;

@end

@implementation KTScrollNumbersLayer

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.duration = 1.5;
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    
    numbersMutableArray = [NSMutableArray new];
    charsMutableArray = [NSMutableArray new];
    scrollLayersMutableArray = [NSMutableArray new];
    scrollLabelsMutableArray = [NSMutableArray new];
    imageViewsMutableArray = [NSMutableArray new];
    numberLabelsMutableArray = [NSMutableArray new];
}

- (void)setToString:(NSString *)toString {
    _toString = toString;
}

- (void)setFromString:(NSString *)fromString {
    _fromString = fromString;
}

- (void)animationFromString:(NSString *)toString {
    [self setToString:toString];
    [self startAnimation];
}

- (void)startAnimation {
    [self prepareAnimations];
    [self createAnimations];
    _fromString = _toString;
}

- (void)stopAnimation {
    for(CALayer *layer in scrollLayersMutableArray){
        [layer removeAnimationForKey:@"JTNumberScrollAnimatedView"];
    }
}

- (void)prepareAnimations {
    for(UILabel *label in scrollLabelsMutableArray){
        [label.layer removeFromSuperlayer];
    }
    
    for (UIImageView *imageView in imageViewsMutableArray) {
        [imageView removeFromSuperview];
    }
    
    [numbersMutableArray removeAllObjects];
    [charsMutableArray removeAllObjects];
    [scrollLayersMutableArray removeAllObjects];
    [scrollLabelsMutableArray removeAllObjects];
    [imageViewsMutableArray removeAllObjects];
    [numberLabelsMutableArray removeAllObjects];

    [self installData];
}

- (void)installData {

    if ([self.fromString isEqualToString:self.toString]) {
        return;
    }
    NSMutableArray *toMutableArray = [NSMutableArray array];
    NSMutableArray *fromMutableArray = [NSMutableArray array];
    toMutableArray = [self interceptWithString:self.toString];
    fromMutableArray = [self interceptWithString:self.fromString];
    for (NSInteger index = 0; index < toMutableArray.count; index++) {
        if (toMutableArray.count > 0 && fromMutableArray.count > 0) {
            long tempInt = [[toMutableArray objectAtIndex:index] count] - [[fromMutableArray objectAtIndex:index] count];
            if (tempInt > 0) {
                //补全位置
                for (int inde = 0; inde < tempInt; inde++) {
                    [[fromMutableArray objectAtIndex:index] insertObject:@"0" atIndex:0];
                }
            } else {
                //隐藏位数
                for (int ind = 0; ind < labs(tempInt); ind++) {
                    [[fromMutableArray objectAtIndex:index] removeObjectAtIndex:0];
                }
            }
        }
        //处理from从nil开始
        if (self.fromString.length > 0) {
            [charsMutableArray addObjectsFromArray:[fromMutableArray objectAtIndex:index]];
        } else {
            [charsMutableArray addObjectsFromArray:[toMutableArray objectAtIndex:index]];
        }
    }
    
    [self createScrollLayers];
}

//根据特殊字符截取
- (NSMutableArray *)interceptWithString:(NSString *)string  {
    NSMutableArray *interceptArray = [NSMutableArray new];
    NSInteger location = 0;
    for (NSInteger index = 0; index < string.length; index ++) {
        NSString *temp = [string substringWithRange:NSMakeRange(index, 1)];
        char numberChar = [temp characterAtIndex:0];
        if (numberChar < '0' || numberChar > '9') {
            [interceptArray addObject:[self splitWithStringAttribute:[string substringWithRange:NSMakeRange(location, index + 1 - location)]]];
            location = index + 1;
        }
    }
    return interceptArray;
}

//分割
- (NSMutableArray *)splitWithStringAttribute:(NSString *)stringAttribute {
    NSMutableArray *splitArray = [NSMutableArray new];
    for (NSInteger i = 0; i < stringAttribute.length; i++) {
        [splitArray addObject:[stringAttribute substringWithRange:NSMakeRange(i, 1)]];
    }
    return splitArray;
}

- (void)createScrollLayers {
    CGFloat width = 30;
    
    CGFloat offsetX = (self.frame.size.width - charsMutableArray.count * width) / 2;
    for(NSUInteger i = 0; i < charsMutableArray.count; ++i){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX + 2  + i * width, 3, 25, 33)];
        unichar numberChar = [[charsMutableArray objectAtIndex:i] characterAtIndex:0];
        if (numberChar >= '0' && numberChar <= '9') {
            if (self.type == KTScrollNumbersLayerTypeNumber) {
                imageView.image = [UIImage imageNamed:@"frame_digital"];
            } else {
                imageView.image = [UIImage imageNamed:@"creditListNumberLabel"];
            }
            [self addSubview:imageView];
            
            [imageViewsMutableArray addObject:imageView];
            
            CAScrollLayer *scrollLayer = [CAScrollLayer layer];
            scrollLayer.frame = CGRectMake(offsetX + i * width, 5, width, 30);
            [scrollLayersMutableArray addObject:scrollLayer];
            [self.layer addSublayer:scrollLayer];
            
            NSString *fromText = @"0";
            if (charsMutableArray.count > i) {
                fromText = [charsMutableArray objectAtIndex:i];
            }
            [self createNumberLayer:scrollLayer withText:fromText];
          
            [numbersMutableArray addObject:[self.toString substringWithRange:(NSRange){i, 1}]];
        } else {
            CAScrollLayer *layer = [CAScrollLayer layer];
            layer.frame = CGRectMake(offsetX + i * width, 5 , 28, 30 );
            [self.layer addSublayer:layer];
            [self createUtilLayer:layer withUtilText:[charsMutableArray objectAtIndex:i]];
        }
    }
}

- (void)createUtilLayer:(CAScrollLayer *)utilLayer withUtilText:(NSString *)utilText {
    CGFloat height = 0;
    UILabel *utilLabel = [self createLabel:utilText];
    utilLabel.font = [UIFont systemFontOfSize:15];
    utilLabel.alpha = 0.7;
    utilLabel.frame = CGRectMake(0, height, CGRectGetWidth(utilLayer.frame), CGRectGetHeight(utilLayer.frame));
    [utilLayer addSublayer:utilLabel.layer];
    [scrollLabelsMutableArray addObject:utilLabel];
    height = CGRectGetMaxY(utilLabel.frame);
}

- (void)createNumberLayer:(CAScrollLayer *)layer withText:(NSString *)numberText {
    
    NSMutableArray *textForScroll = [NSMutableArray array];
    if (!([numberText rangeOfString:@"亿"].length > 0)|| !([numberText rangeOfString:@"万"].length > 0)) {
        [textForScroll addObjectsFromArray:@[numberText, @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
        for (NSInteger index = 0; index <= [numberText integerValue]; index ++) {
            [textForScroll addObject:[NSString stringWithFormat:@"%ld", (long)index]];
        }
    }
    CGFloat height = 0;
    for (NSInteger index = 0; index < textForScroll.count; index ++) {
        NSString *text = textForScroll[index];
        if (_fromString.length != _toString.length && _fromString.length == 0) {
            if (index == 0) {
                text = @"0";
            }
        }
        
        UILabel *textLabel = [self createLabel:text];
        textLabel.frame = CGRectMake(0, height, CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame));
        [layer addSublayer:textLabel.layer];
        [scrollLabelsMutableArray addObject:textLabel];
        height = CGRectGetMaxY(textLabel.frame);
        if (index == 0) {
            [numberLabelsMutableArray addObject:textLabel];
        }
    }
}

- (UILabel *)createLabel:(NSString *)stringText {
    
    UILabel *label = [UILabel new];
    label.textColor = self.textColor;
    label.font = self.font;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = stringText;
    return label;
}

- (void)createAnimations {
    NSInteger count = scrollLayersMutableArray.count;
    if (_fromString.length == _toString.length) {
        while (count > 0) {
            if ([[_fromString substringWithRange:NSMakeRange(_fromString.length - count, 1)] isEqualToString:[_toString substringWithRange:NSMakeRange(_toString.length - count, 1)]]) {
                count--;
            } else {
                break;
            }
        }
    }
    
    for(NSInteger index = 0; index < count; index ++){
        __weak KTScrollNumbersLayer *blockSelf = self;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2 * index * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [blockSelf performAnimation:scrollLayersMutableArray[scrollLayersMutableArray.count - index - 1] duration:(count - index) * 0.3];
        });
    }
}

- (void)performAnimation:(CAScrollLayer *)layer duration:(NSTimeInterval)duration {
    
    [self resetNumber:layer];
    
    CGFloat maxY = [[[layer sublayers] lastObject] frame].origin.y;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue = @0;
    animation.toValue = [NSNumber numberWithFloat:-maxY];
    
    [layer addAnimation:animation forKey:@"JTNumberScrollAnimatedView"];
}

- (void)resetNumber:(CAScrollLayer *)layer {
    for (NSInteger index = 0; index < numberLabelsMutableArray.count; index ++) {
        UILabel *numberLabel = numberLabelsMutableArray[index];
        if ([numberLabelsMutableArray[index] layer].superlayer == layer) {
            [numberLabel removeFromSuperview];
            [self createNumberLayer:layer withText:numbersMutableArray[index]];
            [numberLabel setNeedsDisplay];
            return;
        }
    }
}

@end

