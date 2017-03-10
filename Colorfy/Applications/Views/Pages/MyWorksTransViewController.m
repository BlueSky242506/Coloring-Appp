//
//  MyWorksTransViewController.m
//  Colorfy
//
//  Created by Mac729 on 7/9/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "MyWorksTransViewController.h"

@interface MyWorksTransViewController ()

@end

@implementation MyWorksTransViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeBtnClick:(id)sender {
    [commonUtils fnHideModalTransparent:self];
}



@end
