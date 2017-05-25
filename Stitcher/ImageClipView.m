//
//  ImageClipView.m
//  Stitcher
//
//  Created by Richard on 2017/5/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ImageClipView.h"
#import <Masonry/Masonry.h>

const static int TAG_IMAGEVIEW = 200;

@interface ImageClipView () <UIScrollViewDelegate>

@property(nonatomic, strong) UIView *container;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) NSArray<NSValue *> *clipPoints;

@end

@implementation ImageClipView

- (instancetype)initWithPoints: (NSArray<NSValue *> *)points {
    self = [super init];
    if (self != nil) {
        _clipPoints = points;
        [self setup];
    }
    return self;
}

- (void)setImage: (UIImage *)image {
    // TODO
}

- (CGRect)getClipFrame {
    
    CGPoint offset = _scrollView.contentOffset;
    CGFloat zoom = _scrollView.zoomScale;
    CGSize contentSize = _scrollView.contentSize;
    CGSize frameSize = _scrollView.frame.size;
    
    NSLog(@"offset: %lf %lf, zoom: %f", offset.x, offset.y, zoom);
    NSLog(@"content size: %lf %lf", contentSize.width, contentSize.height);
    NSLog(@"frame size: %lf %lf", frameSize.width, frameSize.height);
    
    CGFloat originX = offset.x / zoom;
    CGFloat originY = offset.y / zoom;
    CGFloat sizeW = frameSize.width / zoom;
    CGFloat sizeH = frameSize.height / zoom;
    
    return CGRectMake(originX, originY, sizeW, sizeH);
}

- (NSArray *)getClipFramePoints {
    
    NSMutableArray<NSValue *> *points = [[NSMutableArray alloc] initWithCapacity:_clipPoints.count];
    for (int i = 0; i < _clipPoints.count; i++) {
        [points addObject:[NSValue valueWithCGPoint:[self pointToFrameAtIndex:i]]];
    }
    return points;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self isPointInClipArea:point];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self applyMask];
    
    // TODO: 将图片设置到合适位置显示
    
    CGFloat scaleX = self.bounds.size.width / _sourceImage.size.width;
    CGFloat scaleY = self.bounds.size.height / _sourceImage.size.height;
    
    _scrollView.minimumZoomScale = (scaleX < scaleY) ? scaleY : scaleX;
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:TAG_IMAGEVIEW];
}


#pragma mark - Private Functions

- (void)setup {
    
    _container = [[UIView alloc] init];
    [self addSubview:_container];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.bouncesZoom = YES;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    [_container addSubview:_scrollView];
    
    _sourceImage = [UIImage imageNamed:@"cat.jpg"];  // TODO: 改为选择
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_sourceImage];
    imageView.tag = TAG_IMAGEVIEW;
    [_scrollView addSubview:imageView];
    
    _scrollView.contentSize = imageView.bounds.size;

    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_container);
    }];
}

- (void)applyMask {
    CGSize size = self.bounds.size;
    
    NSAssert(!(size.width == 0 && size.height == 0), @"container size can't be zero.");
    
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i < _clipPoints.count; i++) {
        CGPoint point = [self pointToFrameAtIndex:i];
        if (i == 0) {
            CGPathMoveToPoint(path, NULL, point.x, point.y);
        } else {
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
        }
    }
    CGPathCloseSubpath(path);
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path;
    
    self.layer.mask = maskLayer;
}

// 判断点是否在四边形内部
- (BOOL)isPointInClipArea: (CGPoint)point {
    
    CGFloat px = point.x;
    CGFloat py = point.y;
    
    CGPoint point0 = [self pointToFrameAtIndex:0];
    CGPoint point1 = [self pointToFrameAtIndex:1];
    CGPoint point2 = [self pointToFrameAtIndex:2];
    CGPoint point3 = [self pointToFrameAtIndex:3];
    
    // AB X AP = (b.x - a.x, b.y - a.y) x (p.x - a.x, p.y - a.y)
    //         = (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x);
    // BC X BP = (c.x - b.x, c.y - b.y) x (p.x - b.x, p.y - b.y)
    //         = (c.x - b.x) * (p.y - b.y) - (c.y - b.y) * (p.x - b.x);
    
    CGFloat a = (point1.x - point0.x)*(py - point0.y) - (point1.y - point0.y)*(px - point0.x);
    CGFloat b = (point2.x - point1.x)*(py - point1.y) - (point2.y - point1.y)*(px - point1.x);
    CGFloat c = (point3.x - point2.x)*(py - point2.y) - (point3.y - point2.y)*(px - point2.x);
    CGFloat d = (point0.x - point3.x)*(py - point3.y) - (point0.y - point3.y)*(px - point3.x);
    
    if ((a > 0 && b > 0 && c > 0 && d > 0) || (a < 0 && b < 0 && c < 0 && d < 0)) {
        return YES;
    }
    return NO;
}

- (CGPoint)pointToFrameAtIndex: (int)idx {
    CGPoint point = [[_clipPoints objectAtIndex:idx] CGPointValue];
    CGSize size = self.bounds.size;
    point.x *= size.width;
    point.y *= size.height;
    return point;
}

@end
