//
//  TemplateHelper.h
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClipTemplate;
@class ClipShape;

#define OUTPUT_IMG_WIDTH ((CGFloat)1082)
#define OUTPUT_IMG_HEIGHT ((CGFloat)1500)

@interface TemplateHelper : NSObject

/**
 根据配置文件名生成模板类

 @param filename 配置文件名
 @return ClipTemplate 模板实例
 */
+ (ClipTemplate *)generateTemplateWithFileName: (NSString *)filename;

/**
 获取 ClipShape 在 UI 面板上的 UIEdgeInsets, 用于界面上布局

 @param shape ClipShape 实例
 @param size UI 面板上的容器大小
 @param spaceWid Shape 间隔
 @return UIEdgeInests
 */
+ (UIEdgeInsets)getEdgeInsetsWithShape: (ClipShape *)shape
                         containerSize: (CGSize)size
                            spaceWidth: (CGFloat)spaceWid;

/**
 获取 ClipShape 合并为最终拼接图的绘制区域，用于 ClipHelper::mergeImagesWithSize

 @param shape ClipShape 实例
 @param spaceWid 拼接图中的 shape 间隔
 @return CGRect
 */
+ (CGRect)getMergeRectWithShape: (ClipShape *)shape
                     spaceWidth: (CGFloat)spaceWid;

@end
