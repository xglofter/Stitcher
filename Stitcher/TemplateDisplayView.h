//
//  TemplateDisplayView.h
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "DisplayView.h"

@protocol TemplateDisplayViewDelegate <NSObject>

- (void)templateDisplayName: (NSString *)name;

@end

@interface TemplateDisplayView : DisplayView

@property(nonatomic, weak) id<TemplateDisplayViewDelegate> delegate;

- (instancetype)initWithNames: (NSArray<NSString *> *)names;

@end
