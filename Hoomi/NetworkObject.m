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
#import "UICKeyChainStore.h"


@interface NetworkObject()

@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *name;

@property (nonatomic) Singletone *singleTone;


@end

@implementation NetworkObject


- (void)initSignInUserID:(NSString *)userID password:(NSString *)password {
    
    self.userID = userID;
    self.password = password;
    
}

- (void)initSignUpUserID:(NSString *)userID name:(NSString *)name password:(NSString *)password {
    
    self.userID = userID;
    self.password = password;
    self.name = name;

}

- (void)requestSignIn {
    
    self.singleTone = [Singletone requestInstance];

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
                          NSLog(@"error : %@", error);
                          NSLog(@"가입되어있지 않습니다.");
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginFailNotification object:nil];
                          
                      } else {
                          
                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                          NSInteger statusCode = (long)httpResponse.statusCode;
                          NSLog(@"%ld", statusCode);
                          if (statusCode == 201) {
                              NSLog(@"로그인 성공");
                              
                              NSString *token = [responseObject objectForKey:@"token"];
                              NSLog(@"token : %@", token);
                              [self saveSessionValue:token];
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotifiaction object:nil];
                              
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
    
}

- (void)requestSignUp {
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:self.userID forKey:@"email"];
    [bodyParams setObject:self.password forKey:@"password"];
    [bodyParams setObject:self.name forKey:@"name"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:SignUpUrl parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
                          NSLog(@"Error: %@", error);
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:SignUpFailNotification object:nil];
                          
                      } else {
                          NSLog(@"token : %@", responseObject);
//                          [self saveSessionValue:responseObject];
                          [[NSNotificationCenter defaultCenter] postNotificationName:SignUpSuccessNotification object:nil];
                          
                      }
                  }];
    
    [uploadTask resume];
    
}


- (void)saveSessionValue:(NSString *)session {
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.zzzbag.Hoomi"];
    keychain[@"session"] = session;
    
   
}

- (NSString *)loadSessionValue {
    
    // 불러올 때
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.zzzbag.Hoomi"];
    NSString *token = [keychain stringForKey:@"session"];
    NSLog(@"token : %@", token);
    
    return token;
    
}


@end
