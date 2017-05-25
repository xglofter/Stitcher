//
//  FinishViewController.m
//  Stitcher
//
//  Created by Richard on 2017/5/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "FinishViewController.h"
#import "TemplateHelper.h"
#import <Masonry/Masonry.h>

@interface FinishViewController ()

@property(nonatomic, strong) UIImage *targetImage;
@property(nonatomic, strong) UIImageView *targetImageView;

@end

@implementation FinishViewController

- (instancetype)initWithImage: (UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _targetImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _targetImageView = [[UIImageView alloc] initWithImage:_targetImage];
    [_targetImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_targetImageView];
    
    [_targetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(100, 50, 100, 50));
    }];
    
    CGFloat spaceTop = 20 + self.navigationController.navigationBar.frame.size.height
                          + self.navigationController.navigationBar.frame.origin.y;
    [_targetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(spaceTop);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(150 * OUTPUT_IMG_WIDTH / OUTPUT_IMG_HEIGHT);
        make.height.mas_equalTo(150);
    }];
    
//    UIImageWriteToSavedPhotosAlbum(_targetImage, nil, nil, nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
