//
//  DisplayView.h
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DisplayView : UIView

@property(nonatomic, strong) UIView *displayView;
@property(nonatomic, assign, readonly) BOOL isShow;

- (instancetype)initWithHeight: (CGFloat)height;

- (void)show;

- (void)hide;

@end
