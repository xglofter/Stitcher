//
//  ClipHelper.h
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClipHelper : NSObject

/**
 将图片切片
 
 @param size 目标图片尺寸大小
 @param image 源图片
 @param points 切片路径（四边形顺时针方向顶点 CGPoint 数组）
 @param rect 源图片需要切片的区域（在源图上的位置及大小）
 @return 切片后图片
 
 @note rect 区域大小需要适应 size 的宽高比，否则会出现横向或纵向的压扁 scale
 */
+ (UIImage *)clipImageWithSize: (CGSize)size
                         image: (UIImage *)image
                    pathPoints: (NSArray<NSValue *> *)points
                     drawFrame: (CGRect)rect;



/**
 将子图形拼接

 @param size 目标图片大小
 @param images 子图形
 @param places 绘制位置
 @return 目标图片
 */
+ (UIImage *)mergeImagesWithSize: (CGSize)size
                     imagesArray: (NSArray<UIImage *> *)images
                     placesArray: (NSArray<NSValue *> *)places;

@end
