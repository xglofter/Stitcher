//
//  TemplateContainerView.m
//  Stitcher
//
//  Created by Richard on 2017/5/27.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "TemplateContainerView.h"
#import "StitcherConfig.h"
#import <Masonry/Masonry.h>
#import "TemplateHelper.h"
#import "ClipHelper.h"
#import "ImageClipView.h"
#import "ClipTemplate.h"
#import "ClipShape.h"


#define TAG_ORDER_SELECT    100
#define TAG_ORDER_TARGET    150
#define TAG_ORDER_UNSELECT  200

@interface TemplateContainerView ()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation TemplateContainerView

#pragma mark - Lifecycle

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _containerSize = size;
        _clipViews = [[NSMutableArray alloc] initWithCapacity:MAX_CHOOSED_NUMBER];
        _choosedImages = [[NSMutableArray alloc] initWithCapacity:MAX_CHOOSED_NUMBER];
        _stateMode = TemplateContainerOnEdit;
        
        self.backgroundColor = UIColor.whiteColor;

    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_stateMode == TemplateContainerOnEdit) return;
    
    CGPoint point = [touches.anyObject locationInView:self];
    for (ImageClipView *view in _clipViews) {
        CGPoint thePoint = [self convertPoint:point toView:view];
        if ([view pointInside:thePoint withEvent:event]) {
            view.tag = TAG_ORDER_SELECT;
            if (_imageView == nil) {
                _imageView = [[UIImageView alloc] initWithImage:view.sourceImage];
                _imageView.contentMode = UIViewContentModeScaleAspectFill;
                _imageView.frame = CGRectMake(0, 0, 80, 100);
                _imageView.alpha = 0.4;
                [self addSubview:_imageView];
            } else {
                _imageView.image = view.sourceImage;
            }
            _imageView.hidden = YES;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_stateMode == TemplateContainerOnEdit) return;
    
    CGPoint point = [touches.anyObject locationInView:self];
    for (ImageClipView *view in _clipViews) {
        CGPoint thePoint = [self convertPoint:point toView:view];
        if ([view pointInside:thePoint withEvent:event]) {
            if (view.tag != TAG_ORDER_SELECT) {
                [view highlight];
                _imageView.hidden = NO;
                _imageView.center = point;
            } else {
                _imageView.hidden = YES;
            }
        } else {
            [view unhighlight];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_stateMode == TemplateContainerOnEdit) return;
    
    CGPoint point = [touches.anyObject locationInView:self];
    BOOL isNeedExchange = NO;
    for (ImageClipView *view in _clipViews) {
        CGPoint thePoint = [self convertPoint:point toView:view];
        if ([view pointInside:thePoint withEvent:event]) {
            if (view.tag != TAG_ORDER_SELECT) {
                view.tag = TAG_ORDER_TARGET;
                isNeedExchange = YES;
            }
        }
    }

    if (isNeedExchange) {
        NSInteger startIdx = [_clipViews indexOfObject:[self viewWithTag:TAG_ORDER_SELECT]];
        NSInteger endIdx = [_clipViews indexOfObject:[self viewWithTag:TAG_ORDER_TARGET]];
        [_choosedImages exchangeObjectAtIndex:startIdx withObjectAtIndex:endIdx];
        
        int idx = 0;
        for (ImageClipView *view in _clipViews) {
            [view setImage:_choosedImages[idx]];
            idx++;
        }
    }
    
    // clean
    for (ImageClipView *view in _clipViews) {
        view.tag = TAG_ORDER_UNSELECT;
        [view unhighlight];
    }
    _imageView.hidden = YES;
}

#pragma mark - Public Functions

- (void)setState: (TemplateContainerViewState)state {
    _stateMode = state;
    
    for (ImageClipView *view in _clipViews) {
        if (state == TemplateContainerOnEdit) {
            view.scrollView.userInteractionEnabled = YES;
        } else if (state == TemplateContainerOnOrder) {
            view.scrollView.userInteractionEnabled = NO;
        }
    }
}

- (void)loadTemplate {
    
    for (ImageClipView *view in _clipViews) {
        [view removeFromSuperview];
    }
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
        view.tag = TAG_ORDER_UNSELECT;
        [self addSubview:view];
        [view setImage:_choosedImages[idx]];
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

- (void)removeImageAtIndex: (NSInteger)index {
    [_choosedImages removeObjectAtIndex:index];
    [self loadTemplate];
}

- (NSString *)currentTemplateName {
    return _template.templateName;
}

#pragma mark - Private Functions

#pragma mark - Callback Fucntions


@end
