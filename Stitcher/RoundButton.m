//
//  RoundButton.m
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "RoundButton.h"


@implementation RoundButton

- (instancetype)initWithTitle: (NSString *)title {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        _isHighlight = NO;
        
        self.backgroundColor = [UIColor blackColor];
        self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.layer.borderWidth = 2;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.layer.cornerRadius = self.frame.size.height * 0.5;
}

- (void)highlight {
    self.layer.borderColor = [[UIColor orangeColor] CGColor]; // TODO: 继续封装
    _isHighlight = YES;
}

- (void)unhighlight {
    self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _isHighlight = NO;
}

@end
