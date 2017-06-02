//
//  UIImage+Color.m
//  Stitcher
//
//  Created by Richard on 2017/6/1.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

- (instancetype)initWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 2, 2);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
