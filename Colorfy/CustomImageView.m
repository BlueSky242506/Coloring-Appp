//
//  CustomImageView.m
//  Colorfy
//
//  Created by Danny Chan on 18/8/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView


@synthesize tempView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *) init:(UIImageView *)imgView
{
    tempView=[[UIView alloc] init];
    tempView.userInteractionEnabled=YES;
    tempView.multipleTouchEnabled=YES;
    [tempView addSubview:imgView];
    return tempView;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.tempView];
    //[touch.view addGestureRecognizer:panView];
//    if ([[touch.view class] isSubclassOfClass:[UIImageView class]]) {
//
//        UIImageView *imgView=(UIImageView *) touch.view;
//
//    }
}
@end
