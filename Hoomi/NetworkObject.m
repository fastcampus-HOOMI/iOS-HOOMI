//
//  NetworkObject.m
//  Hoomi
//
//  Created by Jyo on 2016. 7. 8..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "NetworkObject.h"
#import "AFNetworking.h"
#import "Singletone.h"

@interface NetworkObject()

@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *name;

@property (nonatomic) Singletone *singleTone;

@end

@implementation NetworkObject

- (void)requestSingleTone {
    
    self.singleTone = [Singletone requestInstance];
}

- (void)initSignInUserID:(NSString *)userID password:(NSString *)password {
    
    self.userID = userID;
    self.password = password;
    [self requestSingleTone];
    
}

- (void)initSignUpUserID:(NSString *)userID name:(NSString *)name password:(NSString *)password {
    
    self.userID = userID;
    self.password = password;
    self.name = name;
    [self requestSingleTone];

}

- (void)requestSignIn {
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:self.userID forKey:@"email"];
    [bodyParams setObject:self.password forKey:@"password"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:LoginUrl parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          // 회원가입 유도
                          NSLog(@"가입되어있지 않습니다.");
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginFailNotification object:nil];
                          
                      } else {
                          
                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                          NSInteger statusCode = (long)httpResponse.statusCode;
                          
                          if (statusCode == 200) {
                              NSLog(@"로그인 성공");
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotifiaction object:nil];
                              
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
    
}

- (void)requestSignUp {
    
    
    
}


@end
