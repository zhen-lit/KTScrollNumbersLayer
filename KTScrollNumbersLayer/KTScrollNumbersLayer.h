//
//  BANumberAnimatedView.h
//  PersonToPerson
//
//  Created by abel on 16/4/13.
//  Copyright © 2016年 abel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTScrollNumbersLayerType) {
    KTScrollNumbersLayerTypeCredit,
    KTScrollNumbersLayerTypeNumber,
};

@interface KTScrollNumbersLayer : UIView

@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;
@property (assign, nonatomic) KTScrollNumbersLayerType type;

- (void)animationFromString:(NSString *)toString;
- (void)startAnimation;
- (void)stopAnimation;

@end
