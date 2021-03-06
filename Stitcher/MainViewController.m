//
//  MainViewController.m
//  Stitcher
//
//  Created by Richard on 2017/5/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "MainViewController.h"
#import "RoundButton.h"
#import "EditViewController.h"
#import <Masonry/Masonry.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RoundButton *button = [[RoundButton alloc] initWithTitle:@"模板拼图"];
    [button addTarget:self action:@selector(onTemplateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CGFloat spaceTop = 100;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(spaceTop);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTemplateAction: (UIButton *)sender {
    
    UIViewController *editVC = [[EditViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:editVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}


@end
