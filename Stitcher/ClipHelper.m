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
    UIGraphicsBeginImageContext(size);
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
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1, -1);

    for (int i = 0; i < images.count; i++) {
        CGRect rect = [[places objectAtIndex:i] CGRectValue];
        UIImage *image = [images objectAtIndex:i];
        CGContextDrawImage(context, rect, [image CGImage]);
    }
    
//    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), [image1 CGImage]);
//    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), [image2 CGImage]);
//    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), [image3 CGImage]);
//    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), [image4 CGImage]);
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outImage;
}


@end

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor grayColor];
//    
//    // 1. left image
//    UIImage *imageLeft = [UIImage imageNamed:@"cat.jpg"];
//    
//    CGSize size = CGSizeMake(800, 800);
//    
//    NSValue *leftPoint0 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//    NSValue *leftPoint1 = [NSValue valueWithCGPoint:CGPointMake(size.width/2 - 4, 0)];
//    NSValue *leftPoint2 = [NSValue valueWithCGPoint:CGPointMake(size.width/2 - 4, size.height)];
//    NSValue *leftPoint3 = [NSValue valueWithCGPoint:CGPointMake(0, size.height)];
//    NSArray *leftPaths = [NSArray arrayWithObjects:leftPoint0, leftPoint1, leftPoint2, leftPoint3, nil];
//    CGRect leftFrame = CGRectMake(185, 0, 250, 250);
//    
//    UIImage *outImgLeft = [self clipImageWithSize:size image:imageLeft pathPoints:leftPaths drawFrame:leftFrame];
//    
//    // 2. right-top image
//    UIImage *imageRT = [UIImage imageNamed:@"cat2.jpg"];
//    
//    NSValue *rtPoint0 = [NSValue valueWithCGPoint:CGPointMake(size.width/2 + 4, 0)];
//    NSValue *rtPoint1 = [NSValue valueWithCGPoint:CGPointMake(size.width, 0)];
//    NSValue *rtPoint2 = [NSValue valueWithCGPoint:CGPointMake(size.width, size.height/2 - 4)];
//    NSValue *rtPoint3 = [NSValue valueWithCGPoint:CGPointMake(size.width/2 + 4, size.height/2 - 4)];
//    NSArray *rtPaths = [NSArray arrayWithObjects:rtPoint0, rtPoint1, rtPoint2, rtPoint3, nil];
//    CGRect rtFrame = CGRectMake(-40, 50, 470, 470);
//    
//    UIImage *outImgRT = [self clipImageWithSize:size image:imageRT pathPoints:rtPaths drawFrame:rtFrame];
//    
//    // 3. right-bottom image
//    UIImage *imageRB = [UIImage imageNamed:@"cat3.jpg"];
//    
//    NSValue *rbPoint0 = [NSValue valueWithCGPoint:CGPointMake(size.width/2 + 4, size.height/2 + 4)];
//    NSValue *rbPoint1 = [NSValue valueWithCGPoint:CGPointMake(size.width, size.height/2 + 4)];
//    NSValue *rbPoint2 = [NSValue valueWithCGPoint:CGPointMake(size.width, size.height)];
//    NSValue *rbPoint3 = [NSValue valueWithCGPoint:CGPointMake(size.width/2 + 4, size.height)];
//    NSArray *rbPaths = [NSArray arrayWithObjects:rbPoint0, rbPoint1, rbPoint2, rbPoint3, nil];
//    CGRect rbFrame = CGRectMake(0, 0, imageRB.size.width, imageRB.size.height);
//    
//    UIImage *outImgRB = [self clipImageWithSize:size image:imageRB pathPoints:rbPaths drawFrame:rbFrame];
//    
//    // 4. merge images
//    UIImage *targetImage = [self mergeImagesWithSize:size image1:outImgLeft image2:outImgRT image3:outImgRB];
//    NSLog(@"%lf %lf", targetImage.size.width, targetImage.size.height);
//    
//    //创建UIImageView并显示在界面上
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:targetImage];
//    imgView.backgroundColor = UIColor.whiteColor;
//    imgView.frame = CGRectMake(30, 50, 300, 300);
//    [self.view addSubview:imgView];
//    
//    //    UIImageWriteToSavedPhotosAlbum(targetImage, nil, nil, nil);
//}


