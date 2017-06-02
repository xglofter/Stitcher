//
//  UIImage+Color.h
//  Stitcher
//
//  Created by Richard on 2017/6/1.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 获取一张纯色图片
 
 @param color 颜色
 @return 图片
 */
- (instancetype)initWithColor: (UIColor *)color;


@end
