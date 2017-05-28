//
//  TemplateContainerView.h
//  Stitcher
//
//  Created by Richard on 2017/5/27.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClipTemplate;
@class ImageClipView;


@interface TemplateContainerView : UIView

@property(nonatomic, assign, readonly) CGSize containerSize;

@property(nonatomic, strong) NSMutableArray<UIImage *> *choosedImages;

@property(nonatomic, strong, readonly) NSMutableArray<ImageClipView *> *clipViews;

@property(nonatomic, strong, readonly) ClipTemplate *template;


- (instancetype)initWithSize: (CGSize)size;


/**
 根据当前选择的图片数去加载模板（默认的模板列表的第一个）
 */
- (void)loadTemplate;


/**
 根据选择的模板名重加载模板

 @param name 模板配置文件名
 */
- (void)reloadTemplateWithName: (NSString *)name;


/**
 生成目标拼接图片

 @return 生成的图片
 */
- (UIImage *)generateTargetImage;

@end
