//
//  EditViewController.m
//  Stitcher
//
//  Created by Richard on 2017/5/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "EditViewController.h"
#import "TemplateContainerView.h"
#import "TemplateHelper.h"
#import "RoundButton.h"
#import <Masonry/Masonry.h>
#import "FinishViewController.h"
#import "ImagesDisplayView.h"
#import "TemplateDisplayView.h"
@import PicturePicker;

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//#define TAG_START_VIEW 1000
//#define MIN_CHOOSED_NUMBER 2
//#define MAX_CHOOSED_NUMBER 9

#pragma mark - EditViewController

@interface EditViewController () <UIScrollViewDelegate, TemplateDisplayViewDelegate> {
    BOOL isFirstEnter;
}

@property(nonatomic, strong) TemplateContainerView *container;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirstEnter = YES;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self setupContainer];
    [self setupOthersWidget];
}

//- (void)updateViewConstraints {
//    [super updateViewConstraints];
//    
//    NSLog(@"");
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFirstEnter == YES) {
        isFirstEnter = NO;
        [self gotoPickImages];
    }
    
//    if (_choosedImages.count == 0) {
//    }
}


#pragma mark - Private Functions

- (void)setupContainer {
    CGFloat spaceTop = 80;
    CGFloat spaceWidth = 30;
    CGFloat containerWidth = SCREEN_WIDTH - 2 * spaceWidth;
    CGFloat containerHeight = OUTPUT_IMG_HEIGHT / OUTPUT_IMG_WIDTH * containerWidth;
    NSLog(@"container width %lf height %lf", containerWidth, containerHeight);
    CGSize size = CGSizeMake(containerWidth, containerHeight);
    
    _container = [[TemplateContainerView alloc] initWithSize:size];
    [self.view addSubview:_container];
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(containerWidth);
        make.top.equalTo(self.view).offset(spaceTop);
        make.height.mas_equalTo(containerHeight);
    }];
}

- (void)setupOthersWidget {
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onBackAction:)];
    self.navigationItem.leftBarButtonItem = backBar;
    
    UIBarButtonItem *finishBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishAction:)];
    self.navigationItem.rightBarButtonItem = finishBar;
    
    // other ui
    RoundButton *imagesButton = [[RoundButton alloc] initWithTitle:@"增/减图片"];
    [imagesButton addTarget:self action:@selector(onImagesAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imagesButton];
    RoundButton *templateButton = [[RoundButton alloc] initWithTitle:@"选模板"];
    [templateButton addTarget:self action:@selector(onChangeTemplateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:templateButton];
    
    [imagesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).offset(50);
        make.right.equalTo(templateButton.mas_left).offset(-20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    [templateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
}


/**
 进行选图
 */
- (void)gotoPickImages {
    NSInteger maxImages = MAX_CHOOSED_NUMBER - _container.choosedImages.count;
    
    __weak EditViewController *weakSelf = self;
    [[PickerManager shared] startChoosePhotosWith:maxImages completion:^(NSArray<UIImage *> *images) {
        NSLog(@"%@", images);
        EditViewController *strongSelf = weakSelf;
        // TODO: bug 贴出来顺序是反的
        [strongSelf.container.choosedImages addObjectsFromArray:images];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.container loadTemplate];
        });
    }];
}

#pragma mark - Callback Functions

- (void)onImagesAction {
    NSLog(@"onImagesAction");
    
    if (_container.choosedImages.count == 0) {
        [self gotoPickImages];
    } else {
        ImagesDisplayView *display = [[ImagesDisplayView alloc] initWithImages:_container.choosedImages];
        [display show];
    }
}

- (void)onChangeTemplateAction {
    NSLog(@"onChangeTemplateAction");
    
    // TODO: 初始化时高亮当前这个
    NSArray *names = [TemplateHelper getTemplateNamesWithNumber:_container.choosedImages.count];
    TemplateDisplayView *display = [[TemplateDisplayView alloc] initWithNames:names];
    display.delegate = self;
    [display show];
}

- (void)onBackAction: (UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFinishAction: (UIBarButtonItem *)sender {
    
    UIImage *targetImage = [_container generateTargetImage];
    
    __weak EditViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        EditViewController *strongSelf = weakSelf;
        [strongSelf showViewController:[[FinishViewController alloc] initWithImage:targetImage] sender:self];
    });
}

#pragma mark - TemplateDisplayViewDelegate

- (void)templateDisplayName:(NSString *)name {
    [_container reloadTemplateWithName:name];
}

@end



