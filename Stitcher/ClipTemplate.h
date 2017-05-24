//
//  ClipTemplate.h
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef struct ClipTemplateData {
//    int shapeNumber;          // 子图形个数 eg. 3 表示由三个子图形组成
//    int *vertexPointNumber;   // 所有子图形的顶点个数数组 eg. [4, 4, 5] 表示两个四边形和一个五边形
//    double *vertexPoints;     // 所有顶点位置的二维数组 eg. [0,0, 0,0.5, ...] 取值在 0~1 为相对值
//    UIEdgeInsets *edgeInsets; // 子图形的边界距离数组 eg. [(0, 0, 0.2, 0.5), ...] 取值在 0~1 为相对值
//} ClipTemplateData;

#pragma mark: - ClipTemplateData

@interface ClipTemplateData : NSObject

/**
 子图形个数
 eg. 3 表示由三个子图形组成
 */
@property(nonatomic, assign) NSInteger shapeNumber;

/**
 所有顶点位置的二维数组，成员为 NSValue => CGPoint
 eg. [(0,0), (0,0.5), ...] 分量取值在 0~1 为相对值
 */
@property(nonatomic, strong) NSArray<NSArray<NSValue *> *> *vertexPoints;


/**
 子图形的边界距离数组，成员为 NSValue => UIEdgeInsets
 eg. [(0, 0, 0.2, 0.5), ...] 取值在 0~1 为相对值
 */
@property(nonatomic, strong) NSArray<NSValue *> *edgeInsets;

@end


#pragma mark: - ClipTemplate

@class ClipShape;

@interface ClipTemplate : NSObject

@property(nonatomic, strong) NSMutableArray<ClipShape *> *shapes;

- (instancetype)initWithData: (ClipTemplateData *)data;

@end
