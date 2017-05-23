//
//  EditViewController.m
//  Stitcher
//
//  Created by Richard on 2017/5/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "EditViewController.h"
#import "ImageClipView.h"
#import "ClipHelper.h"
#import "TemplateHelper.h"
#import "ClipShape.h"
#import <Masonry/Masonry.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface EditViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIView *container;

@property(nonatomic, strong) UIImageView *tempClipImg;
@property(nonatomic, strong) UIButton *tempButton;

@property(nonatomic, strong) ImageClipView *view1;
@property(nonatomic, strong) ImageClipView *view2;
@property(nonatomic, strong) ImageClipView *view3;
@property(nonatomic, strong) ImageClipView *view4;

@property(nonatomic, strong) ClipShape *shape1;
@property(nonatomic, strong) ClipShape *shape2;
@property(nonatomic, strong) ClipShape *shape3;
@property(nonatomic, strong) ClipShape *shape4;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setup];
}

#pragma mark: - Private Functions

- (void)setup {
    // points array data
    
    // TODO: 将顶点数据转化成模板：ClipTemplate, ClipShape

    double data1[8] = {0,0, 0.6,0, 1,0.714, 0,1};
    UIEdgeInsets insets1 = UIEdgeInsetsMake(0, 0, 0.3, 0.5);
    _shape1 = [[ClipShape alloc] initWithPoints:data1 length:4 edgeInsets:insets1];

    double data2[8] = {0,0, 1,0, 1,0.6, 0.286,1};
    UIEdgeInsets insets2 = UIEdgeInsetsMake(0, 0.3, 0.5, 0);
    _shape2 = [[ClipShape alloc] initWithPoints:data2 length:4 edgeInsets:insets2];
    
    double data3[8] = {0,0.4, 0.714,0, 1,1, 0,1};
    UIEdgeInsets insets3 = UIEdgeInsetsMake(0.5, 0, 0, 0.3);
    _shape3 = [[ClipShape alloc] initWithPoints:data3 length:4 edgeInsets:insets3];
    
    double data4[8] = {0,0.286, 1,0, 1,1, 0.4,1};
    UIEdgeInsets insets4 = UIEdgeInsetsMake(0.3, 0.5, 0, 0);
    _shape4 = [[ClipShape alloc] initWithPoints:data4 length:4 edgeInsets:insets4];
    
    // setup all subviews
    
    _container = [[UIView alloc] init];
    _container.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_container];
    
    _view1 = [[ImageClipView alloc] initWithPoints:_shape1.clipPoints];
    _view1.tag = 1001;
    _view1.userInteractionEnabled = YES;
    [_container addSubview:_view1];
    
    _view2 = [[ImageClipView alloc] initWithPoints:_shape2.clipPoints];
    _view2.tag = 1002;
    _view2.userInteractionEnabled = YES;
    [_container addSubview:_view2];
    
    _view3 = [[ImageClipView alloc] initWithPoints:_shape3.clipPoints];
    _view3.tag = 1003;
    _view3.userInteractionEnabled = YES;
    [_container addSubview:_view3];
    
    _view4 = [[ImageClipView alloc] initWithPoints:_shape4.clipPoints];
    _view4.tag = 1004;
    _view4.userInteractionEnabled = YES;
    [_container addSubview:_view4];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [_view1 addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [_view2 addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [_view3 addGestureRecognizer:tapGesture3];
    
    UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [_view4 addGestureRecognizer:tapGesture4];
    
    // make constraints
    
    CGFloat spaceTop = 50;
    CGFloat spaceWidth = 30;
    CGFloat containerWidth = SCREEN_WIDTH - 2 * spaceWidth;
    CGFloat containerHeight = OUTPUT_IMG_HEIGHT / OUTPUT_IMG_WIDTH * containerWidth;
    NSLog(@"container width %lf height %lf", containerWidth, containerHeight);
    CGFloat spaceLineBorder = 4;
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(containerWidth);
        make.top.equalTo(self.view).offset(spaceTop);
        make.height.mas_equalTo(containerHeight);
    }];
    
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(spaceLineBorder + _shape1.edgeInsets.top * containerHeight);
        make.left.equalTo(_container).offset(spaceLineBorder + _shape1.edgeInsets.left * containerWidth);
        make.bottom.equalTo(_container).offset(-spaceLineBorder - _shape1.edgeInsets.bottom * containerHeight);
        make.right.equalTo(_container).offset(-spaceLineBorder - _shape1.edgeInsets.right * containerWidth);
    }];
    
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(spaceLineBorder + _shape2.edgeInsets.top * containerHeight);
        make.left.equalTo(_container).offset(spaceLineBorder + _shape2.edgeInsets.left * containerWidth);
        make.bottom.equalTo(_container).offset(-spaceLineBorder - _shape2.edgeInsets.bottom * containerHeight);
        make.right.equalTo(_container).offset(-spaceLineBorder - _shape2.edgeInsets.right * containerWidth);
    }];
    
    [_view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(spaceLineBorder + _shape3.edgeInsets.top * containerHeight);
        make.left.equalTo(_container).offset(spaceLineBorder + _shape3.edgeInsets.left * containerWidth);
        make.bottom.equalTo(_container).offset(-spaceLineBorder - _shape3.edgeInsets.bottom * containerHeight);
        make.right.equalTo(_container).offset(-spaceLineBorder - _shape3.edgeInsets.right * containerWidth);
    }];
    
    [_view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container).offset(spaceLineBorder + _shape4.edgeInsets.top * containerHeight);
        make.left.equalTo(_container).offset(spaceLineBorder + _shape4.edgeInsets.left * containerWidth);
        make.bottom.equalTo(_container).offset(-spaceLineBorder - _shape4.edgeInsets.bottom * containerHeight);
        make.right.equalTo(_container).offset(-spaceLineBorder - _shape4.edgeInsets.right * containerWidth);
    }];
    
    // template ui
    
    _tempClipImg = [[UIImageView alloc] init];
    _tempClipImg.backgroundColor = [UIColor whiteColor];
    _tempClipImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_tempClipImg];
    
    [_tempClipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(150 * OUTPUT_IMG_WIDTH / OUTPUT_IMG_HEIGHT);
        make.height.mas_equalTo(150);
    }];
    
    _tempButton = [[UIButton alloc] init];
    _tempButton.backgroundColor = [UIColor orangeColor];
    [_tempButton setTitle:@"OK" forState:UIControlStateNormal];
    [_tempButton addTarget:self action:@selector(onFinishAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tempButton];
    
    [_tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).offset(100);
        make.left.equalTo(_tempClipImg.mas_right).offset(30);
        make.right.equalTo(self.view).offset(-50);
        make.height.mas_equalTo(40);
    }];
}

- (void)onTapAction: (UITapGestureRecognizer *)sender {
    NSLog(@"on tap action");
    NSLog(@"-> %ld", sender.view.tag);
    
}

- (void)onFinishAction: (UIButton *)sender {
    NSLog(@"on finish action");
    
    NSArray<ImageClipView *> *sourceImages = [NSArray arrayWithObjects:_view1, _view2, _view3, _view4, nil];
    NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:4];
    
    for (ImageClipView *view in sourceImages) {

        CGRect clipRect = [view getClipFrame];
        NSLog(@"clip rect: %lf, %lf, %lf, %lf", clipRect.origin.x, clipRect.origin.y, clipRect.size.width, clipRect.size.height);
        
        CGPoint point0 = [[view.clipPoints objectAtIndex:0] CGPointValue];
        CGPoint point1 = [[view.clipPoints objectAtIndex:1] CGPointValue];
        CGPoint point2 = [[view.clipPoints objectAtIndex:2] CGPointValue];
        CGPoint point3 = [[view.clipPoints objectAtIndex:3] CGPointValue];
        
        CGSize size = view.bounds.size;
        point0.x *= size.width;
        point0.y *= size.height;
        point1.x *= size.width;
        point1.y *= size.height;
        point2.x *= size.width;
        point2.y *= size.height;
        point3.x *= size.width;
        point3.y *= size.height;
        NSValue *vpoint0 = [NSValue valueWithCGPoint:point0];
        NSValue *vpoint1 = [NSValue valueWithCGPoint:point1];
        NSValue *vpoint2 = [NSValue valueWithCGPoint:point2];
        NSValue *vpoint3 = [NSValue valueWithCGPoint:point3];
        NSArray *vpoints = [NSArray arrayWithObjects:vpoint0, vpoint1, vpoint2, vpoint3, nil];
        
        UIImage *image = [ClipHelper clipImageWithSize:view.bounds.size
                                                  image:view.sourceImage
                                             pathPoints:vpoints
                                              drawFrame:clipRect];
        [images addObject:image];
    }
    
    CGSize outputSize = CGSizeMake(OUTPUT_IMG_WIDTH, OUTPUT_IMG_HEIGHT);
    
    CGFloat lineWid = 15;
    NSValue *rect1 = [NSValue valueWithCGRect:CGRectMake(outputSize.width * _shape1.mergeFrame.origin.x + lineWid,
                                                         outputSize.height * _shape1.mergeFrame.origin.y + lineWid,
                                                         outputSize.width * _shape1.mergeFrame.size.width - lineWid * 2,
                                                         outputSize.height * _shape1.mergeFrame.size.height - lineWid * 2)];
    NSValue *rect2 = [NSValue valueWithCGRect:CGRectMake(outputSize.width * _shape2.mergeFrame.origin.x + lineWid,
                                                         outputSize.height * _shape2.mergeFrame.origin.y + lineWid,
                                                         outputSize.width * _shape2.mergeFrame.size.width - lineWid * 2,
                                                         outputSize.height * _shape2.mergeFrame.size.height - lineWid * 2)];
    NSValue *rect3 = [NSValue valueWithCGRect:CGRectMake(outputSize.width * _shape3.mergeFrame.origin.x + lineWid,
                                                         outputSize.height * _shape3.mergeFrame.origin.y + lineWid,
                                                         outputSize.width * _shape3.mergeFrame.size.width - lineWid * 2,
                                                         outputSize.height * _shape3.mergeFrame.size.height - lineWid * 2)];
    NSValue *rect4 = [NSValue valueWithCGRect:CGRectMake(outputSize.width * _shape4.mergeFrame.origin.x + lineWid,
                                                         outputSize.height * _shape4.mergeFrame.origin.y + lineWid,
                                                         outputSize.width * _shape4.mergeFrame.size.width - lineWid * 2,
                                                         outputSize.height * _shape4.mergeFrame.size.height - lineWid * 2)];
    NSArray<NSValue *> *places = [NSArray arrayWithObjects:rect1, rect2, rect3, rect4, nil];
    
    UIImage * targetImage = [ClipHelper mergeImagesWithSize:outputSize
                                                imagesArray:images
                                                placesArray:places];
    NSLog(@"output: %lf %lf", targetImage.size.width, targetImage.size.height);
    _tempClipImg.image = targetImage;
}



@end
