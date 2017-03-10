//
//  CustomImageView.h
//  Colorfy
//
//  Created by Danny Chan on 18/8/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageView : UIView<UIGestureRecognizerDelegate>

@property(nonatomic,retain) UIView * tempView;

-(UIView *) init:(UIImageView *)imgView;

@end
