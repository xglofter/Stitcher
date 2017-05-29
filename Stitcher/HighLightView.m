//
//  HighLightView.m
//  Stitcher
//
//  Created by Richard on 2017/5/29.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "HighLightView.h"

@implementation HighLightView

- (instancetype)initWithPoints: (NSArray<NSValue *> *)points {
    self = [super init];
    if (self != nil) {
        _clipPoints = points;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    [self drawLines];
}

- (void)drawLines {
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (int i = 0; i < _clipPoints.count; i++) {
//        CGPoint point = [self pointToFrameAtIndex:i];
        CGPoint point = [[_clipPoints objectAtIndex:i] CGPointValue];
        if (i == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        } else {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }
    CGContextClosePath(context);
    
    CGContextSetLineWidth(context, 4);

    [[UIColor redColor] setStroke];
    [[UIColor clearColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
