//
//  SVProgressHUD.h
//
//  Copyright 2011-2014 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//

#import <UIKit/UIKit.h>

@interface SVProgressHUD : UIView

+ (void)showWithStatus:(NSString*)status;
+ (void) dismiss;

@end

