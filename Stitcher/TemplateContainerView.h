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

typedef NS_ENUM(NSInteger, TemplateContainerViewState) {
    TemplateContainerOnEdit,
    TemplateContainerOnOrder,
};

@interface TemplateContainerView : UIView

@property(nonatomic, assign) TemplateContainerViewState stateMode;

@property(nonatomic, assign, readonly) CGSize containerSize;

@property(nonatomic, strong) NSMutableArray<UIImage *> *choosedImages;

@property(nonatomic, strong, readonly) NSMutableArray<ImageClipView *> *clipViews;

@property(nonatomic, strong, readonly) ClipTemplate *template;


/**
 初始化

 @param size 容器大小
 @return TemplateContainerView 实例
 */
- (instancetype)initWithSize: (CGSize)size;


/**
 设置模板容器的状态

 @param state 状态，编辑状态，排序状态
 */
- (void)setState: (TemplateContainerViewState)state;


/**
 根据当前选择的图片数去加载模板（默认的模板列表的第一个）
 */
- (void)loadTemplate;


/**
 根据选择的模板名重加载模板

 @param name 模板配置文件名
 
 @note 只改变模板式样，不改变模板内子图形个数
 */
- (void)reloadTemplateWithName: (NSString *)name;


/**
 生成目标拼接图片

 @return 生成的图片
 */
- (UIImage *)generateTargetImage;


/**
 移除掉图片

 @param index 图片 choosedImages 的下标
 */
- (void)removeImageAtIndex: (NSInteger)index;


/**
 当前模板 id 名
 */
- (NSString *)currentTemplateName;


@end
