//
//  ClipTemplate.m
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ClipTemplate.h"
#import "ClipShape.h"

@implementation ClipTemplateData

@end

@implementation ClipTemplate

- (instancetype)initWithData: (ClipTemplateData *)data {
    self = [super init];
    if (self != nil) {
        _shapes = [[NSMutableArray alloc] initWithCapacity:data.shapeNumber];
        
        for (int i = 0; i < data.shapeNumber; ++i) {
            NSArray *tempPoints = [data.vertexPoints objectAtIndex:i];
            UIEdgeInsets insets = [[data.edgeInsets objectAtIndex:i] UIEdgeInsetsValue];
            ClipShape *shape = [[ClipShape alloc] initWithPoints:tempPoints edgeInsets:insets];
            [_shapes addObject:shape];
        }
    }
    return self;
}

@end
