//
//  EditViewController.m
//  Stitcher
//
//  Created by Richard on 2017/5/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "EditViewController.h"
#import "ImageClipView.h"
#import "ClipTemplate.h"
#import "ClipShape.h"
#import "ClipHelper.h"
#import "TemplateHelper.h"
#import <Masonry/Masonry.h>


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface EditViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIView *container;
@property(nonatomic, strong) NSMutableArray<ImageClipView *> *clipViews;
@property(nonatomic, strong) NSMutableArray<ClipShape *> *shapes;
@property(nonatomic, strong) ClipTemplate *template;

@property(nonatomic, strong) UIImageView *tempClipImg;
@property(nonatomic, strong) UIButton *tempButton;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _clipViews = [[NSMutableArray alloc] initWithCapacity:8];
//    _shapes = [[NSMutableArray alloc] initWithCapacity:8];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setup];
}

#pragma mark: - Private Functions

- (void)setup {
    
    // template and shapes points array data
    
    _template = [TemplateHelper generateTemplateWithFileName:@"d03"];
    _shapes = _template.shapes;

    // setup container and all shapes
    
    _container = [[UIView alloc] init];
    _container.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_container];
    
    for (ClipShape *shape in _shapes) {
        ImageClipView *view = [[ImageClipView alloc] initWithPoints:shape.clipPoints];
        view.tag = 1000 + [_shapes indexOfObject:shape];
        view.userInteractionEnabled = YES;
        [_container addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
        [view addGestureRecognizer:tapGesture];
        
        [_clipViews addObject:view];
    }

    // shapes make constraints
    
    CGFloat spaceTop = 50;
    CGFloat spaceWidth = 30;
    CGFloat containerWidth = SCREEN_WIDTH - 2 * spaceWidth;
    CGFloat containerHeight = OUTPUT_IMG_HEIGHT / OUTPUT_IMG_WIDTH * containerWidth;
    NSLog(@"container width %lf height %lf", containerWidth, containerHeight);
    CGSize containerSize = CGSizeMake(containerWidth, containerHeight);
    CGFloat spaceLineBorder = 4;
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(containerWidth);
        make.top.equalTo(self.view).offset(spaceTop);
        make.height.mas_equalTo(containerHeight);
    }];
    
    int idx = 0;
    for (ImageClipView *view in _clipViews) {
        ClipShape *shape = [_shapes objectAtIndex:idx];
        UIEdgeInsets in = [TemplateHelper getEdgeInsetsWithShape:shape containerSize:containerSize spaceWidth:spaceLineBorder];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_container).insets(in);
        }];
        idx++;
    }
    
    // other ui
    
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
    
    NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:_clipViews.count];
    
    for (ImageClipView *view in _clipViews) {
        UIImage *image = [ClipHelper clipImageWithSize:view.bounds.size
                                                 image:view.sourceImage
                                            pathPoints:[view getClipFramePoints]
                                             drawFrame:[view getClipFrame]];
        [images addObject:image];
    }
    
    CGFloat lineWid = 15;
    NSMutableArray<NSValue *> *places = [NSMutableArray arrayWithCapacity:_shapes.count];
    for (ClipShape *shape in _shapes) {
        NSValue *rect = [NSValue valueWithCGRect:[TemplateHelper getMergeRectWithShape:shape
                                                                            spaceWidth:lineWid]];
        [places addObject:rect];
    }
    
    CGSize outputSize = CGSizeMake(OUTPUT_IMG_WIDTH, OUTPUT_IMG_HEIGHT);
    UIImage * targetImage = [ClipHelper mergeImagesWithSize:outputSize
                                                imagesArray:images
                                                placesArray:places];
    NSLog(@"output: %lf %lf", targetImage.size.width, targetImage.size.height);
    _tempClipImg.image = targetImage;
}



@end
