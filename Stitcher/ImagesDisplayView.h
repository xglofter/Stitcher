//
//  ImagesDisplayView.h
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "DisplayView.h"


@protocol ImagesDisplayViewDelegate <NSObject>

// TODO

@end

@interface ImagesDisplayView : DisplayView

- (instancetype)initWithImages: (NSArray<UIImage *> *)images;

@end
