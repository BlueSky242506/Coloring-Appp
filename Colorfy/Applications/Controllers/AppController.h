//  AppController.h
//  Created by BE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppController : NSObject
   

@property (nonatomic, strong) NSString *currentUserId;
@property (nonatomic, strong) NSMutableArray *categoryImageArray, *allImages;
@property (nonatomic, strong) NSString *selectedCategoryName, *selectedCategoryNum;
@property (nonatomic, assign) int selectedSegmentItem;


@property (nonatomic, strong) UIColor *appMainColor, *appTextColor, *appThirdColor;
@property (nonatomic, strong) DoAlertView *vAlert;

@property (nonatomic, strong) NSMutableArray *introSliderImages;
@property (nonatomic, strong) NSMutableDictionary *currentUser, *apnsMessage;
@property (nonatomic, strong) UIImage *postBarkImage, *editProfileImage;

// Temporary Variables
@property (nonatomic, strong) NSString *currentMenuTag, *avatarUrlTemp;
@property (nonatomic, strong) NSMutableDictionary *currentNavBark, *currentNavBarkStat;
@property (nonatomic, assign) BOOL isFromSignUpSecondPage, isNewBarkUploaded, isMyProfileChanged;
@property (nonatomic, strong) NSString *statsVelocityHistoryPeriod;

@property (nonatomic, assign) NSDictionary *tempFB;

+ (AppController *)sharedInstance;

-(void) facebookLogin:(UIViewController *) viewController progressView:(MBProgressHUD *) progressView;


@end