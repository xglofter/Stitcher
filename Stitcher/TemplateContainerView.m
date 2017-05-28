//
//  TemplateContainerView.m
//  Stitcher
//
//  Created by Richard on 2017/5/27.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "TemplateContainerView.h"
#import <Masonry/Masonry.h>
#import "TemplateHelper.h"
#import "ClipHelper.h"
#import "ImageClipView.h"
#import "ClipTemplate.h"
#import "ClipShape.h"


#define TAG_START_VIEW 1000

@implementation TemplateContainerView

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _containerSize = size;
        _clipViews = [[NSMutableArray alloc] initWithCapacity:MAX_CHOOSED_NUMBER];
        _choosedImages = [[NSMutableArray alloc] initWithCapacity:MAX_CHOOSED_NUMBER];
        
        self.backgroundColor = UIColor.whiteColor;

    }
    return self;
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
        [self addSubview:view];
        [view setImage:_choosedImages[idx]];
        
//        if (idx == 0) {
//            view.container.userInteractionEnabled = YES;
//            view.scrollView.userInteractionEnabled = NO;
//        } else {
//            view.container.userInteractionEnabled = NO;
//            view.scrollView.userInteractionEnabled = NO;
//        }
        
        //        [view addTarget:self action:@selector(onDragInClipView) forControlEvents:UIControlEventTouchDragInside];
        //        [view addTarget:self action:@selector(onDragOutClipView) forControlEvents:UIControlEventTouchDragOutside];
        //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClipView)];
        //        [view addGestureRecognizer:tapGesture];
        //        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDragOutClipView)];
        //        [view addGestureRecognizer:panGesture];
        
        [_clipViews addObject:view];
        idx++;
    }
    
    // shapes make constraints
    idx = 0;
    for (ImageClipView *view in _clipViews) {
        ClipShape *shape = [_template.shapes objectAtIndex:idx];
        UIEdgeInsets inset = [TemplateHelper getEdgeInsetsWithShape:shape containerSize:_containerSize];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(inset);
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
            make.edges.equalTo(self).insets(inset);
        }];
        idx++;
    }
}


- (UIImage *)generateTargetImage {
    
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
    UIImage * outImage = [ClipHelper mergeImagesWithSize:outputSize
                                                imagesArray:images
                                                placesArray:places];
    NSLog(@"output: %lf %lf", outImage.size.width, outImage.size.height);
    return outImage;
}

#pragma mark - Callback Fucntions

- (void)onTapClipView {
    NSLog(@"onTapClipView");
    //    NSLog(@"-> %ld", sender.view.tag);
    // TODO: 弹出气泡菜单
}

- (void)onTapOutClipView {
    NSLog(@"onTapOutClipView");
}

- (void)onDragInClipView {
    NSLog(@"onDragInClipView");
}

- (void)onDragOutClipView {
    NSLog(@"onDragOutClipView");
}


@end
