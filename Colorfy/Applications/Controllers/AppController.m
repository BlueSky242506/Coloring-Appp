//
//  AppController.m

#import "AppController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Utility Data
        _appMainColor = RGBA(144, 144, 144, 1.0f);//RGBA(254, 242, 91, 1.0f);
        _appTextColor = RGBA(144, 144, 144, 1.0f);//RGBA(41, 43, 48, 1.0f);
        _appThirdColor = RGBA(61, 155, 196, 1.0f);
        
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode

        _statsVelocityHistoryPeriod = @"30";
        
        _isFromSignUpSecondPage = NO;
        _isNewBarkUploaded = NO;
        _isMyProfileChanged = NO;
        
        _selectedSegmentItem = 0;
        
        // Data
        _currentUser = [[NSMutableDictionary alloc] init];        
        _categoryImageArray = [[NSMutableArray alloc] init];
        _allImages = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDictionary*) requestApi:(NSMutableDictionary *)params withFormat:(NSString *)url {
    return [AppController jsonHttpRequest:url jsonParam:params];
}

+ (id) jsonHttpRequest:(NSString*) urlStr jsonParam:(NSMutableDictionary *)params {
    NSString *paramStr = [commonUtils getParamStr:params];
    //NSLog(@"\n\nparameter string : \n\n%@", paramStr);
    NSData *requestData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = nil;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSHTTPURLResponse *response = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

    return [[SBJsonParser new] objectWithString:responseString];
}

-(void) facebookLogin:(UIViewController *) viewController progressView:(MBProgressHUD *) progressView{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"email"] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Process error");
            [progressView hide:YES];
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
            [progressView hide:YES];
        } else {
            NSLog(@"Logged in with token : @%@", result.token);
            [progressView hide:YES];
            if ([result.grantedPermissions containsObject:@"email"]) {
                [self fetchUserFacebookInfo:progressView];
            }
        }
    }];
}

- (void)fetchUserFacebookInfo: (MBProgressHUD *)progressBar {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, gender, bio, location, friends, hometown, friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"facebook fetched info : %@", result);
                 _tempFB = (NSDictionary *)result;
                 [self dataRefreshFB:progressBar];
             } else {
                 NSLog(@"Error %@",error);
                 [progressBar hide:YES];
             }
         }];
    }
}

-(void) dataRefreshFB:(MBProgressHUD *) progressView {
    NSString *fbId = [_tempFB objectForKey:@"id"];
    NSString *username = [_tempFB objectForKey:@"name"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:fbId forKey:@"facebook_id"];
    [userInfo setObject:username forKey:@"user_name"];
    
    [[DatabaseController sharedManager] userSignUp:userInfo onSuccess:^(id json) {
        NSLog(@"Database Data : %@", json);
        NSDictionary *temp = json;
        NSString *status = [temp objectForKey:@"status"];
        if ([status intValue] == 2) {
            [commonUtils showVAlertSimple:@"You already registered" body:@"" duration:1.0];
            [commonUtils setUserDefaultDic:@"RegisteredUser" withDic:userInfo];
            NSDictionary *userInformation = [[temp objectForKey:@"current_user"] objectAtIndex:0];
            NSString *userId = [userInformation objectForKey:@"user_id"];
            appController.currentUserId = userId;
        } else if ([status intValue] == 1) {
            NSDictionary *userInformation = [[temp objectForKey:@"current_user"] objectAtIndex:0];
            NSString *userId = [userInformation objectForKey:@"user_id"];
            appController.currentUserId = userId;
            [commonUtils setUserDefaultDic:@"RegisteredUser" withDic:userInformation];
            [commonUtils showVAlertSimple:@"" body:@"You registered successfully" duration:1.0];
        } else {
            [commonUtils showVAlertSimple:@"Please check your FB account!" body:nil duration:1.0];
            [progressView hide:YES];
        }
    } onFailure:^(id json) {
        NSLog(@"Database Data1 : %@", json);
        [progressView hide:YES];
        [commonUtils showVAlertSimple:@"Connection error" body:@"please try again later" duration:1.0];
    }];
}

@end
