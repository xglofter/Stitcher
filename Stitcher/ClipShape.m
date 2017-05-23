//
//  ClipShape.m
//  Stitcher
//
//  Created by Richard on 2017/5/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ClipShape.h"

@implementation ClipShape

- (instancetype)initWithPoints: (double [])points
                        length: (int)len
                    edgeInsets: (UIEdgeInsets)insets
{
    self = [super init];
    if (self != nil) {
        // init clip points data
        _clipPoints = [[NSMutableArray alloc] initWithCapacity:len];
        _edgeInsets = insets;
        _mergeFrame = CGRectMake(insets.left, insets.bottom,
                                 1 - insets.right - insets.left, 1 - insets.top - insets.bottom);
        
        for (int i = 0; i < len * 2; i += 2) {
            NSValue *value = [NSValue valueWithCGPoint:CGPointMake(points[i], points[i + 1])];
            NSLog(@"%@", value);
            [_clipPoints addObject:value];
        }
    }
    return self;
}

@end
