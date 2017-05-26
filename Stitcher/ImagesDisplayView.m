//
//  ImagesDisplayView.m
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ImagesDisplayView.h"
#import <Masonry/Masonry.h>


#define IDENTIFIER_IMGES_CELL @"images_cell"


@interface ImagesDisplayView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray<UIImage *> *images;

@end

@implementation ImagesDisplayView

- (instancetype)initWithImages: (NSArray<UIImage *> *)images {
    self = [super initWithHeight:120];
    if (self != nil) {
        _images = [NSMutableArray new];
        [_images addObjectsFromArray:images];
        
        [self setup];
    }
    return self;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_IMGES_CELL forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 1;
    if (indexPath.row == _images.count) {
        imageView.image = [UIImage imageNamed:@"ic_add"];
    } else {
        imageView.image = _images[indexPath.row];
    }
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    if (indexPath.row != _images.count) {
        UIImageView *deleteIcon = [[UIImageView alloc] init];
        deleteIcon.image = [UIImage imageNamed:@"ic_delete"];
        [cell addSubview:deleteIcon];
        
        [deleteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell);
            make.top.equalTo(cell);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _images.count) {
        // TODO: 将 9 这个样的配置写到一个文件内
        // TODO: 通知到 EditViewController 去新增图片
        //        [[PickerManager shared] startChoosePhotosWith:9 completion:^(NSArray<UIImage *> *images) {
        //            NSLog(@"%@", images);
        //
        //        }];
    } else {
        [_images removeObjectAtIndex:indexPath.row];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        // TODO: 通知到 EditViewController
    }
}


#pragma mark - Private Functions

- (void)setup {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(90, 90);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    [layout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollsToTop = NO;
    _collectionView.bounces = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:IDENTIFIER_IMGES_CELL];
    [self.displayView addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.displayView);
    }];
}

@end
