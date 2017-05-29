//
//  HighLightView.h
//  Stitcher
//
//  Created by Richard on 2017/5/29.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighLightView : UIView

@property(nonatomic, strong) NSArray<NSValue *> *clipPoints;

- (instancetype)initWithPoints: (NSArray<NSValue *> *)points;

@end
