//
//  DatabaseController.m
//  Heaters1
//
//  Created by Alex on 12/27/15.
//  Copyright © 2015 Alex. All rights reserved.
//

#import "DatabaseController.h"
#import "AppDelegate.h"

@implementation DatabaseController
+ (DatabaseController *)sharedManager {
    static DatabaseController *sharedManager = nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        sharedManager = [DatabaseController manager];
        [sharedManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [sharedManager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [sharedManager.requestSerializer setValue:@"123456" forHTTPHeaderField:@"api-key"];
        [sharedManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];

    });
    return sharedManager;
}

#pragma mark - USER APIs

-(void)test:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock {
    NSString *urlStr = API_TEST;
    [self POST:urlStr parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)userSignUp:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock {
    [self POST:API_SIGNUP parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)imageSave:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock {
    [self POST:API_IMAGE_SAVE parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)imageComment:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock {
    [self POST:API_IMAGE_COMMENT parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}
-(void)imageFavorite:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock {
    [self POST:API_IMAGE_FAVORITE parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}
-(void)imageOwn:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock {
    [self POST:API_IMAGES_OWN parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}
-(void)imagePublic:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock {
    [self POST:API_IMAGES_PUBLIC parameters:[params mutableCopy] onSuccess:completionBlock onFailure:failureBlock];
}

-(void)imageAllPublic:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock {
    [self POST:API_IMAGES_ALL_PUBLIC parameters:[params mutableCopy] onSuccess:(SuccessBlock)completionBlock onFailure:failureBlock];
}

#pragma mark - Post and Get Function

- (void)POST:(NSString *)url
  parameters:(NSMutableDictionary*)parameters
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
//        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        [commonUtils showAlert:@"Error" withMessage:@"Please try again later"];
        failureBlock(nil);
        return;
    }
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSMutableDictionary * tempDic;
    if (parameters == nil) {
        tempDic = [NSMutableDictionary dictionary];
    }else{
        tempDic= [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
//    [tempDic setObject:[User sharedInstance].strToken forKey:@"token"];
    parameters = tempDic;

    
    NSLog(@"POST url : %@", url);
    NSLog(@"POST param : %@", parameters);
    NSLog(@"Debug____________POST_____________!pause");
    
    [self POST:url
          parameters:parameters
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
              NSData* data = (NSData*)responseObject;
              NSError* error = nil;
              NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
              NSLog(@"POST success : %@", dict);
              
              completionBlock(dict);
              
        
          }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
              NSLog(@"POST Error  %@", error);
//              [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];
//              [commonUtils showAlert:@"Error" withMessage:@"Please try again later"];
              failureBlock(nil);
          }
    ];
    
  }

- (void)POST:(NSString *)url
  parameters:(NSMutableDictionary*)parameters
      vImage:(NSData*)vImage
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
//        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        [commonUtils showAlert:@"Error" withMessage:@"Please try again later"];

        failureBlock(nil);
        return;
    }
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    NSLog(@"POST url : %@", url);
    NSLog(@"POST param : %@", parameters);
    NSLog(@"Debug____________POST_____________!pause");
    
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (vImage != nil) {
            [formData appendPartWithFormData:vImage name:@"vImage"];
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData* data = (NSData*)responseObject;
        NSError* error = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"POST success : %@", dict);
        
       completionBlock(dict);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"POST Error  %@", error);
//        [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];
        [commonUtils showAlert:@"Error" withMessage:@"Please try again later"];

        failureBlock(nil);
    }];
}


- (void)GET:(NSString *)url
 parameters:(NSMutableDictionary*)parameters
  onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock
{
    // Check out network connection
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
//        [SHAlertHelper showOkAlertWithTitle:@"Error" message:@"We are unable to connect to our servers.\rPlease check your connection."];
        [commonUtils showAlert:@"Error" withMessage:@"Please try again later"];

        failureBlock(nil);
        return;
    }
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    NSLog(@"GET url : %@", url);
    NSLog(@"GET param : %@", parameters);
    
    [self GET:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData* data = (NSData*)responseObject;
        NSError* error = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"GET success : %@", dict);
        completionBlock(dict);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"GET Error  %@", error);
//        [SHAlertHelper showOkAlertWithTitle:@"Connection Error" andMessage:@"Error occurs while connecting to web-service. Please try again!" andOkBlock:nil];
        [commonUtils showAlert:@"Error" withMessage:@"Please try again later"];
        failureBlock(nil);
    }];
}

@end
