//
//  RoundButton.h
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundButton : UIButton

@property(nonatomic, assign) BOOL isHighlight;

- (instancetype)initWithTitle: (NSString *)title;

- (void)highlight;

- (void)unhighlight;

@end
