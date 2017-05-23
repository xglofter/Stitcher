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
//@property(nonatomic, assign) CGSize containerSize;

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

//- (void)setContainerSize: (CGSize)size {
//    _containerSize = size;
//}

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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self isPointInClipArea:point];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    
//}

#pragma mark - Private Functions

- (void)setup {
    
    _container = [[UIView alloc] init];
    [self addSubview:_container];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.bouncesZoom = YES;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    [_container addSubview:_scrollView];
    
    _sourceImage = [UIImage imageNamed:@"cat.jpg"];
    
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
    
    NSLog(@"applyMask size %lf %lf", self.bounds.size.width, self.bounds.size.height);
    
//    NSValue *point0 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//    NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake(size.width * 2/3 - 2, 0)];
//    NSValue *point2 = [NSValue valueWithCGPoint:CGPointMake(size.width/3 - 2, size.height)];
//    NSValue *point3 = [NSValue valueWithCGPoint:CGPointMake(0, size.height)];
//    NSArray *points = [NSArray arrayWithObjects:point0, point1, point2, point3, nil];
//    [self applyMaskToView:_container pathPoints:points];
    
    CGPoint point0 = [[_clipPoints objectAtIndex:0] CGPointValue];
    CGPoint point1 = [[_clipPoints objectAtIndex:1] CGPointValue];
    CGPoint point2 = [[_clipPoints objectAtIndex:2] CGPointValue];
    CGPoint point3 = [[_clipPoints objectAtIndex:3] CGPointValue];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point0.x * size.width, point0.y * size.height);
    CGPathAddLineToPoint(path, NULL, point1.x * size.width, point1.y * size.height);
    CGPathAddLineToPoint(path, NULL, point2.x * size.width, point2.y * size.height);
    CGPathAddLineToPoint(path, NULL, point3.x * size.width, point3.y * size.height);
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
    
    CGPoint point0 = [[_clipPoints objectAtIndex:0] CGPointValue];
    CGPoint point1 = [[_clipPoints objectAtIndex:1] CGPointValue];
    CGPoint point2 = [[_clipPoints objectAtIndex:2] CGPointValue];
    CGPoint point3 = [[_clipPoints objectAtIndex:3] CGPointValue];
    
    CGSize size = self.bounds.size;
    point0.x *= size.width;
    point0.y *= size.height;
    point1.x *= size.width;
    point1.y *= size.height;
    point2.x *= size.width;
    point2.y *= size.height;
    point3.x *= size.width;
    point3.y *= size.height;
    
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

@end
