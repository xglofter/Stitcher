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
#import "ImagesDisplayView.h"
#import "TemplateDisplayView.h"
#import <PicturePicker/PicturePicker.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define TAG_START_VIEW 1000
#define MIN_CHOOSED_NUMBER 2
#define MAX_CHOOSED_NUMBER 9

#pragma mark - EditViewController

@interface EditViewController () <UIScrollViewDelegate, TemplateDisplayViewDelegate> {
    BOOL isFirstEnter;
}

@property(nonatomic, strong) UIView *container;
@property(nonatomic, assign) CGSize containerSize;

@property(nonatomic, strong) NSMutableArray<UIImage *> *choosedImages;

@property(nonatomic, strong) ClipTemplate *template;
@property(nonatomic, strong) NSMutableArray<ImageClipView *> *clipViews;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirstEnter = YES;
    
    _choosedImages = [[NSMutableArray alloc] initWithCapacity:MAX_CHOOSED_NUMBER];
    _clipViews = [[NSMutableArray alloc] initWithCapacity:MAX_CHOOSED_NUMBER];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self setupContainer];
    [self setupOthersWidget];
    [self loadTemplate];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    NSLog(@"");
}

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
}

- (void)setupOthersWidget {
    
    //
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onBackAction:)];
    self.navigationItem.leftBarButtonItem = backBar;
    
    UIBarButtonItem *finishBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishAction:)];
    self.navigationItem.rightBarButtonItem = finishBar;
    
    // other ui
    RoundButton *imagesButton = [[RoundButton alloc] initWithTitle:@"增/减图片"];
    // UIControlEventTouchDragOutside TODO: 拖放交换位置
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

- (void)loadTemplate {
    
    [_clipViews removeAllObjects];
    _template = nil;
    
    // template and shapes points array data
    NSInteger number = _choosedImages.count;
    NSInteger startASCII = [@"a" characterAtIndex:0];
    NSString *basicFileName = [NSString stringWithFormat:@"%c01", (int)(startASCII + number - 1)];
    _template = [TemplateHelper generateTemplateWithFileName:basicFileName];
    
    // generate shapes
    int idx = 0;
    for (ClipShape *shape in _template.shapes) {
        ImageClipView *view = [[ImageClipView alloc] initWithPoints:shape.clipPoints];
        view.tag = TAG_START_VIEW + idx;
        view.userInteractionEnabled = YES;
        [_container addSubview:view];
        [view setImage:_choosedImages[idx]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
        [view addGestureRecognizer:tapGesture];
        
        [_clipViews addObject:view];
        idx++;
    }
    
    // shapes make constraints
    idx = 0;
    for (ImageClipView *view in _clipViews) {
        ClipShape *shape = [_template.shapes objectAtIndex:idx];
        UIEdgeInsets inset = [TemplateHelper getEdgeInsetsWithShape:shape containerSize:_containerSize];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_container).insets(inset);
        }];
        idx++;
    }
}

/**
 重新加载模板
 
 @note 只改变模板式样，不改变模板内子图形个数
 */
- (void)reloadTemplateWithName: (NSString *)name {
    
    _template = [TemplateHelper generateTemplateWithFileName:name];
    
    int idx = 0;
    for (ImageClipView *view in _clipViews) {
        ClipShape *shape = [_template.shapes objectAtIndex:idx];
        [view setClipPoints:shape.clipPoints];
        UIEdgeInsets inset = [TemplateHelper getEdgeInsetsWithShape:shape containerSize:_containerSize];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_container).insets(inset);
        }];
        idx++;
    }
}


/**
 进行选图
 */
- (void)gotoPickImages {
    NSInteger maxImages = MAX_CHOOSED_NUMBER - _choosedImages.count;
    
    // TODO: 更新 PicturePicker 使得1.不进入就跳动，2.支持最小的选择输入参数
    
    __weak EditViewController *strongSelf = self;
    [[PickerManager shared] startChoosePhotosWith:maxImages completion:^(NSArray<UIImage *> *images) {
        NSLog(@"%@", images);
        [_choosedImages addObjectsFromArray:images];
//        ImagesDisplayView *display = [[ImagesDisplayView alloc] initWithImages:images];
//        [display show];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf loadTemplate];
        });
    }];
}

#pragma mark - Callback Functions

- (void)onTapAction: (UITapGestureRecognizer *)sender {
    NSLog(@"on tap action");
    NSLog(@"-> %ld", sender.view.tag);
    // TODO: 弹出气泡菜单
}

- (void)onImagesAction {
    NSLog(@"onImagesAction");
    
    if (_choosedImages.count == 0) {
        [self gotoPickImages];
    } else {
        ImagesDisplayView *display = [[ImagesDisplayView alloc] initWithImages:_choosedImages];
        [display show];
    }
}

- (void)onChangeTemplateAction {
    NSLog(@"onChangeTemplateAction");
    
    // TODO: 初始化时高亮当前这个
    NSArray *names = [TemplateHelper getTemplateNamesWithNumber:_choosedImages.count];
    TemplateDisplayView *display = [[TemplateDisplayView alloc] initWithNames:names];
    display.delegate = self;
    [display show];
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

#pragma mark - TemplateDisplayViewDelegate

- (void)templateDisplayName:(NSString *)name {
    [self reloadTemplateWithName:name];
}

@end



