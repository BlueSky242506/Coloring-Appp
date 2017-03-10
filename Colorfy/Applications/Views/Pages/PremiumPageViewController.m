//
//  PremiumPageViewController.m
//  Colorfy
//
//  Created by Mac729 on 7/2/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "PremiumPageViewController.h"

@interface PremiumPageViewController ()

@property (strong, nonatomic) IBOutlet UIButton *paySelectBtn;
@property (strong, nonatomic) IBOutlet UIButton *paymentBtn;


@end

@implementation PremiumPageViewController{
    int payFlag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    payFlag = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeBtn:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)freeTrialBtnClick:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)paymentBtnClick:(id)sender {
//    if (payFlag == 0) {
//        <#statements#>
//    }else{
//        
//    }
}

- (IBAction)paySelectBtnClick:(id)sender {
    if (payFlag == 0) {
        
        [_paySelectBtn setTitle:@"GO MONTHLY" forState:UIControlStateNormal];
        [_paymentBtn setTitle:@"$39.95/ YEAR" forState:UIControlStateNormal];
        payFlag = 1;
    }else{
        [_paySelectBtn setTitle:@"GO YEARLY AND SAVE 71%" forState:UIControlStateNormal];
        [_paymentBtn setTitle:@"$7.98/ MONTH" forState:UIControlStateNormal];
        payFlag = 0;
    }
}

@end
