//
//  TemplateDisplayView.m
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "TemplateDisplayView.h"
#import <Masonry/Masonry.h>


#define IDENTIFIER_TEMPLATE_CELL  @"template_cell"
#define TAG_SELECT_CELL           200
#define TAG_UNSELECT_CELL         250

@interface TemplateDisplayView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<NSString *> *names;

@end

@implementation TemplateDisplayView

- (instancetype)initWithNames: (NSArray<NSString *> *)names {
    self = [super initWithHeight:90];
    if (self != nil) {
        _names = names;
        [self setup];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _names.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_TEMPLATE_CELL forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:_names[indexPath.row]];
    [cell addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [collectionView viewWithTag:TAG_SELECT_CELL];
    if (view != nil) {
        view.tag = TAG_UNSELECT_CELL;
        view.backgroundColor = [UIColor clearColor];
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.tag = TAG_SELECT_CELL;
    cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    
    [self.delegate templateDisplayName:_names[indexPath.row]];
}


#pragma mark - Private Functions

- (void)setup {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(70, 70);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    [layout setSectionInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollsToTop = NO;
    _collectionView.bounces = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:IDENTIFIER_TEMPLATE_CELL];
    [self.displayView addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.displayView);
    }];
}


@end
