//
//  DatabaseController.h
//  Heaters1
//
//  Created by Alex on 12/27/15.
//  Copyright © 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"

//#define SERVER_URL @"http://172.16.1.198:8080/colorfy/api/"
//#define SERVER_IMAGE_URL @"http://172.16.1.198:8080/colorfy/"

#define SERVER_URL @"http://www.backend.benchpts.com/jiggerycolory/api/"
#define SERVER_IMAGE_URL @"http:www.backend.benchpts.com/jiggerycolory/"

#define API_TEST (SERVER_URL @"test")
#define API_SIGNUP (SERVER_URL @"user_signup")
#define API_IMAGE_SAVE (SERVER_URL @"image_save")
#define API_IMAGE_COMMENT (SERVER_URL @"image_comment")
#define API_IMAGE_FAVORITE (SERVER_URL @"image_favorite")
#define API_IMAGES_OWN (SERVER_URL @"own_images")
#define API_IMAGES_PUBLIC (SERVER_URL @"public_images")
#define API_IMAGES_ALL_PUBLIC (SERVER_URL @"public_all_images")

typedef void (^SuccessBlock)(id json);
typedef void (^FailureBlock)(id json);

@interface DatabaseController : AFHTTPRequestOperationManager {

}

+ (DatabaseController *)sharedManager;

-(void)test:(NSDictionary*)params  onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)userSignUp:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)imageSave:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)imageComment:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)imageFavorite:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)imageOwn:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)imagePublic:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;
-(void)imageAllPublic:(NSDictionary*)params onSuccess:(SuccessBlock)completionBlock onFailure:(FailureBlock)failureBlock;

-(void)POST:(NSString *)url
 parameters:(NSMutableDictionary*)parameters
      onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock;

-(void)POST:(NSString *)url
  parameters:(NSMutableDictionary*)parameters
      vImage:(NSData*)vImage
   onSuccess:(SuccessBlock)completionBlock
   onFailure:(FailureBlock)failureBlock;
- (void)GET:(NSString *)url
parameters:(NSMutableDictionary*)parameters
onSuccess:(SuccessBlock)completionBlock
  onFailure:(FailureBlock)failureBlock;

@end