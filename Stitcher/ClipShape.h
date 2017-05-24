//
//  ClipShape.h
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClipShape : NSObject

/**
 剪切顶点数据，分量 0~1
 */
@property(nonatomic, strong) NSArray<NSValue *> *clipPoints;

/**
 距离模板边界四周的相对距离，分量 0~1
 */
@property(nonatomic, assign) UIEdgeInsets edgeInsets;


/**
 合并时所在模板的区域，（注意：此区域 origin 在左下角），分量取值 0~1
 */
@property(nonatomic, assign) CGRect mergeFrame;


/**
 初始化 ClipShape 对象

 @param points 剪切顶点数组，顺时针方向 [(x1,y1), (x2,y2), ...]
 @param insets 距离边界的相对值
 @return ClipShape 对象
 
 @note: points 顶点为 0~1 的相对自身宽高的值
        insets 分量为 0~1 的相对模板宽高的值
 */
- (instancetype)initWithPoints: (NSArray<NSValue *> *)points
                    edgeInsets: (UIEdgeInsets)insets;

@end
