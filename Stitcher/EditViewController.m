//
//  EditViewController.m
//  Stitcher
//
//  Created by Richard on 2017/5/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "EditViewController.h"
#import "StitcherConfig.h"
#import "TemplateContainerView.h"
#import "TemplateHelper.h"
#import "RoundButton.h"
#import <Masonry/Masonry.h>
#import "FinishViewController.h"
#import "ImagesDisplayView.h"
#import "TemplateDisplayView.h"
@import PicturePicker;


#pragma mark - EditViewController

@interface EditViewController () <TemplateDisplayViewDelegate, ImagesDisplayViewDelegate> {
    BOOL isFirstEnter;
}

@property(nonatomic, strong) TemplateContainerView *container;

@property(nonatomic, strong) RoundButton *imagesButton;
@property(nonatomic, strong) RoundButton *templateButton;
@property(nonatomic, strong) RoundButton *orderButton;

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
    _imagesButton = [[RoundButton alloc] initWithTitle:@"增/减图片"];
    [_imagesButton addTarget:self action:@selector(onImagesAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imagesButton];
    _templateButton = [[RoundButton alloc] initWithTitle:@"选模板"];
    [_templateButton addTarget:self action:@selector(onChangeTemplateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_templateButton];
    _orderButton = [[RoundButton alloc] initWithTitle:@"排序"];
    [_orderButton addTarget:self action:@selector(onChangeOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderButton];
    
    [_imagesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).offset(50);
        make.right.equalTo(_templateButton.mas_left).offset(-20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    [_templateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container.mas_bottom).offset(50);
        make.left.equalTo(_templateButton.mas_right).offset(20);
        make.width.mas_equalTo(90);
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
        display.delegate = self;
        [display show];
    }
}

- (void)onChangeTemplateAction {
    NSLog(@"onChangeTemplateAction");

    NSArray *names = [TemplateHelper getTemplateNamesWithNumber:_container.choosedImages.count];
    NSString *name = [_container currentTemplateName];
    TemplateDisplayView *display = [[TemplateDisplayView alloc] initWithNames:names currName: name];
    display.delegate = self;
    [display show];
}

- (void)onChangeOrderAction {
    
    // TODO: 移动时，当前那个子图形需要设为不可见，被拖走
    
    if (_container.stateMode == TemplateContainerOnEdit) {
        [_container setState:TemplateContainerOnOrder];
        [_orderButton highlight];
    } else if (_container.stateMode == TemplateContainerOnOrder) {
        [_container setState:TemplateContainerOnEdit];
        [_orderButton unhighlight];
    }
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
    // TODO: 需要更新子图形的缩放大小以及位置
    [_container reloadTemplateWithName:name];
}

#pragma mark - ImagesDisplayViewDelegate

- (void)imagesDisplayRemoved: (NSInteger)index {
    [_container removeImageAtIndex:index];
}

- (void)imagesDisplayToAdd {
    [self gotoPickImages];
}


@end



