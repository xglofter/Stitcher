//
//  ClipShape.m
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ClipShape.h"

@implementation ClipShape

- (instancetype)initWithPoints: (NSArray<NSValue *> *)points
                    edgeInsets: (UIEdgeInsets)insets
{
    self = [super init];
    if (self != nil) {
        // init clip points data
        _clipPoints = points;
        _edgeInsets = insets;
        _mergeFrame = CGRectMake(insets.left, insets.bottom,
                                 1 - insets.right - insets.left, 1 - insets.top - insets.bottom);
    }
    return self;
}

@end
