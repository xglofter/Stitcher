//
//  ClipHelper.m
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ClipHelper.h"

@implementation ClipHelper

+ (UIImage *)clipImageWithSize: (CGSize)size
                         image: (UIImage *)image
                    pathPoints: (NSArray<NSValue *> *)points
                     drawFrame: (CGRect)rect
{
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"%lf %lf => %lf %lf", image.size.width, image.size.height, width, height);
    
    NSAssert(points.count == 4, @"pathPoints must be vertex of quadrilateral");
    
    //开始绘制图片
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制Clip区域
    CGPoint point0 = [[points objectAtIndex:0] CGPointValue];
    CGPoint point1 = [[points objectAtIndex:1] CGPointValue];
    CGPoint point2 = [[points objectAtIndex:2] CGPointValue];
    CGPoint point3 = [[points objectAtIndex:3] CGPointValue];
    
    CGContextMoveToPoint(context, point0.x, point0.y);
    CGContextAddLineToPoint(context, point1.x, point1.y);
    CGContextAddLineToPoint(context, point2.x, point2.y);
    CGContextAddLineToPoint(context, point3.x, point3.y);
    CGContextClosePath(context);
    CGContextClip(context);
    
    //坐标系转换
    //因为CGContextDrawImage会使用Quartz内的以左下角为(0,0)的坐标系
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1, -1);
    
    CGFloat drawWidth = (size.width * image.size.width) / rect.size.width;
    CGFloat drawHeight = (size.height * image.size.height) / rect.size.height;
    CGFloat drawX = (rect.origin.x * drawWidth) / image.size.width;
    CGFloat drawY = (image.size.height - rect.origin.y - rect.size.height) * drawHeight / image.size.height;
    NSLog(@"draw: %f %f %f %f", drawX, drawY, drawWidth, drawHeight);
    CGContextDrawImage(context, CGRectMake(-drawX, -drawY, drawWidth, drawHeight), [image CGImage]);
    
    //结束绘画
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outImage;
}

+ (UIImage *)mergeImagesWithSize: (CGSize)size
                     imagesArray: (NSArray<UIImage *> *)images
                     placesArray: (NSArray<NSValue *> *)places
{
    NSAssert(images.count == places.count, @"[mergeImagesWithSize] images and places must be same count.");
    
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0);
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1, -1);

    for (int i = 0; i < images.count; i++) {
        CGRect rect = [[places objectAtIndex:i] CGRectValue];
        UIImage *image = [images objectAtIndex:i];
        CGContextDrawImage(context, rect, [image CGImage]);
    }

    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outImage;
}


@end

