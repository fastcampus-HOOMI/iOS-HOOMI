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
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *firstName;

@end

@implementation NetworkObject

+ (instancetype) requestInstance {
    
    static NetworkObject *networkObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkObject = [[NetworkObject alloc] init];
        
    });
    
    return networkObject;
    
}


- (void)initSignInUserID:(NSString *)userID password:(NSString *)password {
    
    self.userID = userID;
    self.password = password;
    
}

- (void)initSignUpUserID:(NSString *)userID lastName:(NSString *)lastName firstName:(NSString *)firstName password:(NSString *)password {
    
    self.userID = userID;
    self.password = password;
    self.lastName = lastName;
    self.firstName = firstName;

}

- (void)requestSignIn {

    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:self.userID forKey:@"username"];
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
                          NSLog(@"%ld", (long)statusCode);
                          if (statusCode == 200) {
                              NSLog(@"로그인 성공");
                              
                              NSString *token = [responseObject objectForKey:@"token"];
//                              NSLog(@"token : %@", token);
                              [self saveSessionValue:token];
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotifiaction object:nil];
                              
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
    
}

- (void)requestSignUp {
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:self.userID forKey:@"username"];
    [bodyParams setObject:self.firstName forKey:@"first_name"];
    [bodyParams setObject:self.lastName forKey:@"last_name"];
    [bodyParams setObject:self.password forKey:@"password"];
    
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
                          [[NSNotificationCenter defaultCenter] postNotificationName:SignUpSuccessNotification object:nil];
                          
                      }
                  }];
    
    [uploadTask resume];
    
}

- (void)requestFacebookSignUpToken:(NSString *)token {
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:token forKey:@"access_token"];

    //json 으로 변경 필요

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:FacebookLoginUrl parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
                          NSLog(@"Facebook Error: %@", error);
                        
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginFailNotification object:nil];
                          
                      } else {
                          NSLog(@"jwt token : %@", [responseObject objectForKey:@"token"]);

                          [self saveSessionValue:[responseObject objectForKey:@"token"]];
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotifiaction object:nil];
                          
                      }
                  }];
    
    [uploadTask resume];
    
}

- (void)requestSaveJob:(NSString *)job Token:(NSString *)token {
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:job forKey:@"job"];
    
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
                          [self saveSessionValue:responseObject];
                          [[NSNotificationCenter defaultCenter] postNotificationName:SignUpSuccessNotification object:nil];
                          
                      }
                  }];
    
    [uploadTask resume];
    
}

- (void)requestHitContent {
    
    NSLog(@"requestHitcontent");
    
    NSString *tokenParam = [@"JWT " stringByAppendingString:[self loadSessionValue]];
    
    NSLog(@"%@", tokenParam)
    ;
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:tokenParam forKey:@"Authorization"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:LoadHitContentUrl parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
                          
                      } else {
                          NSLog(@"data : %@", responseObject);
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:LoadHitContentSuccessNotification object:nil];
                          
                      }
                  }];
    
    [uploadTask resume];
    
    
}




- (void)saveSessionValue:(NSString *)session {
    
//    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.zzzbag.Hoomi"];
//    keychain[@"session"] = session;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:session forKey:@"session"];
    
   
}

- (NSString *)loadSessionValue {
    
    // 불러올 때
//    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.zzzbag.Hoomi"];
//    NSString *token = [keychain stringForKey:@"session"];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"session"];
    
    return token;
    
}

   /************************************/
  /*    contents 받아오기 / 업로드 관련    */
 /************************************/

// 이미지 리스트 받아오기 cheesing
-(void)requestImageList {
    
    NSLog(@"request Detail");
    
    /* Header에 Authorization 값에 JWT Token */
    NSString *tokenParam = @"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6IiIsImV4cCI6MTQ2ODQ5NTA5MywidXNlcm5hbWUiOiJoamg1NDg4QGdtYWlsLmNvbSIsIm9yaWdfaWF0IjoxNDY4NDkxNDkzLCJ1c2VyX2lkIjoxNn0.L1RY0Eq_aktAGRxwuF4T1sL3EXLBQkgb0Pf2Eyyy0a0";
    NSLog(@"%@", tokenParam)
    ;
//    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
//    [bodyParams setObject:tokenParam forKey:@"Authorization"];
    
    /* requestURL -> request */
    NSString *URLString = JobHistoryURL;
    NSURL *requestURL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"GET"];
    [request setURL:requestURL];
    [request addValue:tokenParam forHTTPHeaderField: @"Authorization"];

    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response : %@", response);
        NSLog(@"error : %@", error);
        
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if ([dict[@"code"] isEqualToNumber:@200]) {
                NSLog(@"success");
                
                // 노티피게이션 보내기
                [[NSNotificationCenter defaultCenter] postNotificationName:ImageListUpdataNotification object:nil];
                
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:ImageListFailNotification object:nil];
            }
            NSLog(@"받아온 정보 %@", dict);
        }
    }];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataTask resume];
    
}



@end
