//
//  ImageClipView.h
//  Stitcher
//
//  Created by Richard on 2017/5/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageClipView : UIView

@property(nonatomic, strong) UIImage *sourceImage;
@property(nonatomic, strong) NSArray<NSValue *> *clipPoints;

/**
 使用剪切的四边形路径点进行初始化
 
 @param points 四边形顺时针顶点数组
 @return ImageClipView 实例
 
 @note: points 记录点为 0~1.0 的相对位置，根据具体的 frame 值可以来推算具体顶点位置
 */
- (instancetype)initWithPoints: (NSArray<NSValue *> *)points;


///**
// 设置父容器大小
//
// @param size 容器大小
// 
// @note: clipPoints 顶点值是父容器中的相对位置，只有设置父容器大小后，才能推算出每个顶点的具体位置
// */
//- (void)setContainerSize: (CGSize)size;

/**
 设置资源图片
 
 @param image 源图片
 */
- (void)setImage: (UIImage *)image;


/**
 获取编辑以后切图的范围

 @return 在本图片中的切图范围，使用 CGRect 表示
 */
- (CGRect)getClipFrame;

@end