//
//  DisplayView.m
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "DisplayView.h"
#import <Masonry/Masonry.h>
#import <PicturePicker/PicturePicker.h>


@interface DisplayView ()

@property(nonatomic, weak) UIWindow *window;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, strong) UIControl *maskView;

@end

@implementation DisplayView

- (instancetype)initWithHeight: (CGFloat)height {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        _window = UIApplication.sharedApplication.keyWindow;
        _height = height;        
        [self _setup]; // 区分子类的 setup 以免调用到子类的
    }
    return self;
}

- (void)show {
    [self layoutIfNeeded];
    
    __weak DisplayView *weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        DisplayView *strongSelf = weakSelf;
        if (strongSelf != nil) {
            strongSelf.maskView.alpha = 0.4;
            [strongSelf.displayView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(strongSelf);
            }];
            [strongSelf layoutIfNeeded];
        }
    } completion:^(BOOL finished) {
        DisplayView *strongSelf = weakSelf;
        [strongSelf.maskView setUserInteractionEnabled:YES];
    }];
}

- (void)hide {
    [self layoutIfNeeded];
    
    [_maskView setUserInteractionEnabled:NO];
    
    __weak DisplayView *weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        DisplayView *strongSelf = weakSelf;
        if (strongSelf != nil) {
            strongSelf.maskView.alpha = 0;
            [strongSelf.displayView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(strongSelf).offset(strongSelf.height);
            }];
            [strongSelf layoutIfNeeded];
        }
    } completion:^(BOOL finished) {
        DisplayView *strongSelf = weakSelf;
        [strongSelf removeFromSuperview];
    }];
}

#pragma mark - Private Functions

- (void)_setup {
    
    [_window addSubview:self];
    
    _maskView = [UIControl new];
    _maskView.alpha = 0;
    _maskView.backgroundColor = [UIColor blackColor];
    [_maskView setUserInteractionEnabled:YES];
    [_maskView addTarget:self action:@selector(onTapOutSideAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskView];
    
    _displayView = [[UIView alloc] initWithFrame:CGRectZero];
    _displayView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_displayView];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_window);
    }];
    
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(_height);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(_height);
    }];
    
}

- (void)onTapOutSideAction {    
    [self hide];
}

@end
