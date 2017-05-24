//
//  TemplateHelper.m
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "TemplateHelper.h"
#import "ClipTemplate.h"
#import "ClipShape.h"

@implementation TemplateHelper

+ (ClipTemplateData *)parseTemplateFile: (NSString *)filePath {
    NSDictionary *rootDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    if (rootDict == nil) {
        NSLog(@"[Error] %@ can't find file.", filePath);
        return nil;
    }
    
    NSString *theId = [rootDict objectForKey:@"id"];
    NSNumber *numberOfShape = [rootDict objectForKey:@"shape_number"];
    NSArray *vertexPoints = [rootDict objectForKey:@"vertex_points"];
    NSArray *edgeinsets = [rootDict objectForKey:@"edgeinsets"];
    if (theId == nil || numberOfShape == nil || vertexPoints == nil || edgeinsets == nil) {
        NSLog(@"[Error] %@ attributes error.", filePath);
        return nil;
    }
    
    // 获取子图形个数
    NSInteger number = [numberOfShape integerValue];
    if (number != vertexPoints.count || number != edgeinsets.count) {
        NSLog(@"[Error] %@ data number error.", filePath);
        return nil;
    }

    // 获取全部顶点数据
    NSMutableArray<NSArray *> *tempAllShapeVertex = [NSMutableArray arrayWithCapacity:number];
    for (NSArray *currShapeVertex in vertexPoints) {
        NSInteger currShapeVertexCount = currShapeVertex.count;
        if (currShapeVertexCount < 3) {
            NSLog(@"[Error] data vertex number error.");
            return nil;
        }
        NSMutableArray<NSValue *> *tempShapeVertex = [NSMutableArray arrayWithCapacity:currShapeVertexCount];
        for (NSDictionary *pointDict in currShapeVertex) {
            NSNumber *tempX = [pointDict objectForKey:@"x"];
            NSNumber *tempY = [pointDict objectForKey:@"y"];
            if (tempX == nil || tempY == nil) {
                NSLog(@"[Error] data x or y error.");
                return nil;
            }
            CGPoint tempPoint = CGPointMake([tempX floatValue], [tempY floatValue]);
            [tempShapeVertex addObject:[NSValue valueWithCGPoint:tempPoint]];
        }
        [tempAllShapeVertex addObject:tempShapeVertex];
    }
    
    // 获取全部edgeinsets数据
    NSMutableArray<NSValue *> *tempAllEdgeInsets = [NSMutableArray arrayWithCapacity:number];
    for (NSDictionary *currInsets in edgeinsets) {
        NSNumber *tempTop = [currInsets objectForKey:@"top"];
        NSNumber *tempLeft = [currInsets objectForKey:@"left"];
        NSNumber *tempBottom = [currInsets objectForKey:@"bottom"];
        NSNumber *tempRight = [currInsets objectForKey:@"right"];
        if (tempTop == nil || tempLeft == nil || tempBottom == nil || tempRight == nil) {
            NSLog(@"[Error] data top, left, bottom or right error.");
            return nil;
        }
        UIEdgeInsets tempInsets = UIEdgeInsetsMake([tempTop floatValue], [tempLeft floatValue],
                                                   [tempBottom floatValue], [tempRight floatValue]);
        [tempAllEdgeInsets addObject:[NSValue valueWithUIEdgeInsets:tempInsets]];
    }
    
    ClipTemplateData *data = [[ClipTemplateData alloc] init];
    data.shapeNumber = number;
    data.vertexPoints = tempAllShapeVertex;
    data.edgeInsets = tempAllEdgeInsets;
    return data;
}


+ (ClipTemplate *)generateTemplateWithFileName: (NSString *)filename
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:filename ofType:@"plist"];
    ClipTemplateData *data = [self parseTemplateFile:path];
    if (data != nil) {
        return [[ClipTemplate alloc] initWithData:data];
    }
    return nil;
}


+ (UIEdgeInsets)getEdgeInsetsWithShape: (ClipShape *)shape
                         containerSize: (CGSize)size
                            spaceWidth: (CGFloat)spaceWid
{
    CGFloat top = shape.edgeInsets.top * size.height;
    top += (top == 0) ? spaceWid : spaceWid / 2; // 根据是否靠边来判断间隙
    CGFloat left = shape.edgeInsets.left * size.width;
    left += (left == 0) ? spaceWid : spaceWid / 2;
    CGFloat bottom = shape.edgeInsets.bottom * size.height;
    bottom += (bottom == 0) ? spaceWid : spaceWid / 2;
    CGFloat right = shape.edgeInsets.right * size.width;
    right += (right == 0) ? spaceWid : spaceWid / 2;
    return UIEdgeInsetsMake(top, left, bottom, right);
}


+ (CGRect)getMergeRectWithShape: (ClipShape *)shape
                     spaceWidth: (CGFloat)spaceWid
{
    CGFloat originX = OUTPUT_IMG_WIDTH * shape.mergeFrame.origin.x;
    originX += (originX == 0) ? spaceWid : spaceWid / 2; // 根据是否靠边来判断间隙
    CGFloat originY = OUTPUT_IMG_HEIGHT * shape.mergeFrame.origin.y;
    originY += (originY == 0) ? spaceWid : spaceWid / 2;
    CGFloat sizeW = OUTPUT_IMG_WIDTH * shape.mergeFrame.size.width;
    sizeW -= (sizeW == 0) ? spaceWid * 2 : spaceWid * 3 / 2;
    CGFloat sizeH = OUTPUT_IMG_HEIGHT * shape.mergeFrame.size.height;
    sizeH -= (sizeH == 0) ? spaceWid * 2 : spaceWid * 3 / 2;
    return CGRectMake(originX, originY, sizeW, sizeH);
}

@end
