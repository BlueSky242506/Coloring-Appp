//
//  CommentViewController.m
//  Colorfy
//
//  Created by MacVictory on 8/24/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()<UITextFieldDelegate, UIScrollViewDelegate> {
    
    IBOutlet UILabel *commentUserName;
    IBOutlet UITextView *commentContent;
    IBOutlet UITextField *txtCommentInput;
    IBOutlet UIButton *commentSendBtn;
    IBOutlet UIScrollView *mainScrollView;
    
    float keyboardHeight;
    
}

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    keyboardHeight = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // uncomment for non-ARC:
    // [super dealloc];
}

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendCommentBtnClick:(id)sender {
    NSString *commentStr = txtCommentInput.text;
    NSString *userName = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_name"];
    commentUserName.text = userName;
    commentContent.text = commentStr;
    
    NSString *current_user_id = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:current_user_id forKey:@"user_id"];
    [params setObject:self.imageId forKey:@"image_id"];
    [params setObject:commentStr forKey:@"comment_description"];
    [[DatabaseController sharedManager] imageComment:params onSuccess:^(id json) {
        NSLog(@"Database Data : %@", json);
        NSDictionary *temp = json;
        if ([[temp objectForKey:@"status"] intValue] == 1) {
            NSLog(@"comment registered exactly!");
        }
    } onFailure:^(id json) {
        NSLog(@"Database Data1 : %@", json);
        [commonUtils showVAlertSimple:@"Connection error" body:@"Please try again later" duration:1.2];
    }];    
}

#pragma mark - UIText field delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    if ([txtCommentInput.text isEqualToString:@""]) {
        commentSendBtn.enabled = false;
    } else {
        commentSendBtn.enabled = true;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    commentSendBtn.enabled = false;
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"%f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat offset = keyboardHeight;
    [mainScrollView setContentOffset:CGPointMake(0, offset) animated:YES];
    
}

@end
