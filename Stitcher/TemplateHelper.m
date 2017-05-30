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

+ (NSArray<NSString *> *)getTemplateNamesWithNumber: (NSInteger)number {
    switch (number) {
        case 2:
            return @[@"b01"];
        case 3:
            return @[@"c01"];
        case 4:
            return @[@"d01", @"d02", @"d03"];
        default:
            return @[];
    }
}


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
    data.templateName = theId;
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
{
    CGFloat top = shape.edgeInsets.top * size.height;
    CGFloat left = shape.edgeInsets.left * size.width;
    CGFloat bottom = shape.edgeInsets.bottom * size.height;
    CGFloat right = shape.edgeInsets.right * size.width;
    return UIEdgeInsetsMake(top, left, bottom, right);
}


+ (CGRect)getMergeRectWithShape: (ClipShape *)shape {
    
    CGFloat originX = OUTPUT_IMG_WIDTH * shape.mergeFrame.origin.x;
    CGFloat originY = OUTPUT_IMG_HEIGHT * shape.mergeFrame.origin.y;
    CGFloat sizeW = OUTPUT_IMG_WIDTH * shape.mergeFrame.size.width;
    CGFloat sizeH = OUTPUT_IMG_HEIGHT * shape.mergeFrame.size.height;
    return CGRectMake(originX, originY, sizeW, sizeH);
}

@end
