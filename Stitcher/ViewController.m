//
//  ViewController.m
//  Stitcher
//
//  Created by Richard on 2017/5/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "ViewController.h"
#import "RoundButton.h"
#import "EditViewController.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RoundButton *button = [[RoundButton alloc] initWithTitle:@"开始拼图"];
    [button addTarget:self action:@selector(onStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CGFloat spaceTop = 100; //+ self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
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

- (void)onStartAction: (UIButton *)sender {
    
    UIViewController *editVC = [[EditViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:editVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}

@end
