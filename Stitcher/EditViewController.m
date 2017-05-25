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
#import "RoundButton.h"
#import "TemplateHelper.h"
#import <Masonry/Masonry.h>
#import "FinishViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define TAG_START_VIEW 1000

#pragma mark - EditViewController

@interface EditViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIView *container;
@property(nonatomic, assign) CGSize containerSize;

@property(nonatomic, strong) ClipTemplate *template;
@property(nonatomic, strong) NSMutableArray<ImageClipView *> *clipViews;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _clipViews = [[NSMutableArray alloc] initWithCapacity:8];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self setupTemplate];
    [self setupOthersWidget];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    NSLog(@"");
}

#pragma mark - Private Functions

- (void)setupTemplate {

    // setup container
    _container = [[UIView alloc] init];
    _container.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_container];

    CGFloat spaceTop = 80;
    CGFloat spaceWidth = 30;
    CGFloat containerWidth = SCREEN_WIDTH - 2 * spaceWidth;
    CGFloat containerHeight = OUTPUT_IMG_HEIGHT / OUTPUT_IMG_WIDTH * containerWidth;
    NSLog(@"container width %lf height %lf", containerWidth, containerHeight);
    _containerSize = CGSizeMake(containerWidth, containerHeight);
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(containerWidth);
        make.top.equalTo(self.view).offset(spaceTop);
        make.height.mas_equalTo(containerHeight);
    }];
    
    // template and shapes points array data
    _template = [TemplateHelper generateTemplateWithFileName:@"d01"]; // TODO: 根据选择的图片数选初始化模板
    
    // generate shapes
    for (ClipShape *shape in _template.shapes) {
        ImageClipView *view = [[ImageClipView alloc] initWithPoints:shape.clipPoints];
        view.tag = TAG_START_VIEW + [_template.shapes indexOfObject:shape];
        view.userInteractionEnabled = YES;
        [_container addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
        [view addGestureRecognizer:tapGesture];
        
        [_clipViews addObject:view];
    }
    
    // shapes make constraints
    int idx = 0;
    for (ImageClipView *view in _clipViews) {
        ClipShape *shape = [_template.shapes objectAtIndex:idx];
        UIEdgeInsets inset = [TemplateHelper getEdgeInsetsWithShape:shape containerSize:_containerSize];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_container).insets(inset);
        }];
        idx++;
    }
}

- (void)setupOthersWidget {
    
    //
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onBackAction:)];
    self.navigationItem.leftBarButtonItem = backBar;
    
    UIBarButtonItem *finishBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishAction:)];
    self.navigationItem.rightBarButtonItem = finishBar;
    
    // other ui
    RoundButton *button = [[RoundButton alloc] initWithTitle:@"选模板"];
    [button addTarget:self action:@selector(onChangeTemplateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
}

- (void)reloadTemplateWithName: (NSString *)name {
    
    _template = [TemplateHelper generateTemplateWithFileName:name];
    
    int idx = 0;
    for (ImageClipView *view in _clipViews) {
        ClipShape *shape = [_template.shapes objectAtIndex:idx];
        UIEdgeInsets inset = [TemplateHelper getEdgeInsetsWithShape:shape containerSize:_containerSize];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_container).insets(inset);
        }];
        idx++;
    }
}

- (void)onTapAction: (UITapGestureRecognizer *)sender {
    NSLog(@"on tap action");
    NSLog(@"-> %ld", sender.view.tag);
    
}

- (void)onChangeTemplateAction: (UIButton *)sender {
    NSLog(@"onChangeTemplateAction");
    
    [self reloadTemplateWithName:@"d03"];
}

- (void)onBackAction: (UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFinishAction: (UIBarButtonItem *)sender {
    
    NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:_clipViews.count];
    for (ImageClipView *view in _clipViews) {
        UIImage *image = [ClipHelper clipImageWithSize:view.bounds.size
                                                 image:view.sourceImage
                                            pathPoints:[view getClipFramePoints]
                                             drawFrame:[view getClipFrame]];
        [images addObject:image];
    }
    
    NSMutableArray<NSValue *> *places = [NSMutableArray arrayWithCapacity:_template.shapes.count];
    for (ClipShape *shape in _template.shapes) {
        NSValue *rect = [NSValue valueWithCGRect:[TemplateHelper getMergeRectWithShape:shape]];
        [places addObject:rect];
    }
    
    CGSize outputSize = CGSizeMake(OUTPUT_IMG_WIDTH, OUTPUT_IMG_HEIGHT);
    UIImage * targetImage = [ClipHelper mergeImagesWithSize:outputSize
                                                imagesArray:images
                                                placesArray:places];
    NSLog(@"output: %lf %lf", targetImage.size.width, targetImage.size.height);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *finishVC = [[FinishViewController alloc] initWithImage:targetImage];
        [self showViewController:finishVC sender:self];
    });
}


@end


