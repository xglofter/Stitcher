//
//  ImagesDisplayView.h
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "DisplayView.h"


@protocol ImagesDisplayViewDelegate <NSObject>

- (void)imagesDisplayRemoved: (NSInteger)index;

- (void)imagesDisplayToAdd;

@end

@interface ImagesDisplayView : DisplayView

@property(nonatomic, weak) id<ImagesDisplayViewDelegate> delegate;

- (instancetype)initWithImages: (NSArray<UIImage *> *)images;

@end
