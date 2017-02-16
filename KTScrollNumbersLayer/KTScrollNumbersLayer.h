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

- (void)animationFromString:(NSString *)toString;
- (void)startAnimation;
- (void)stopAnimation;

@end
