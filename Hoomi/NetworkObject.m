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


/* 인기글 컨텐츠 (메인 4개) */
- (void)requestHitContent {
    
    NSLog(@"requestHitContent");
    self.hitContentInforJSONArray = nil;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    /* Http Method */
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:LoadHitContentUrl]];
    
    NSString *tokenParam = [@"JWT " stringByAppendingString:[self loadSessionValue]];
    [request setValue:tokenParam forHTTPHeaderField: @"Authorization"];
    
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            NSLog(@"responesObject : %@", responseObject);
            NSArray *contentsArray = [responseObject objectForKey:@"results"];
            self.hitContentInforJSONArray = contentsArray;
            
            // 노티피게이션 보내기
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadHitContentSuccessNotification object:nil];
            
        }
        else {
            
            NSLog(@"%@", error);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadHitContentFailNotification object:nil];
            
        }
        //        NSLog(@"jobHistoryInforJSONArray : %@", self.jobHistoryInforJSONArray);
                NSLog(@"dic : %@", [responseObject objectForKey:@"results"]);
    }];
    
    [downloadTask resume];
}

/* 인기글 전체 */
-(void)requestjobHistory {
    
    NSLog(@"requestjobHistory");
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    /* URLRquest로 요청서 작성 (어떤 contents 타입 원하는지 설정) */
    //    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    /* Http Method */
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:JobHistoryURL]];
    
    NSString *tokenParam = [@"JWT " stringByAppendingString:[self loadSessionValue]];
    [request setValue:tokenParam forHTTPHeaderField: @"Authorization"];
    
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            NSArray *contentsArray = [responseObject objectForKey:@"results"];
            self.jobHistoryInforJSONArray = contentsArray;
            // 노티피게이션 보내기
            [[NSNotificationCenter defaultCenter] postNotificationName:ContentsListUpdataNotification object:nil];
        }
        else {
            NSLog(@"%@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:ContentsListFailNotification object:nil];
        }
                NSLog(@"jobHistoryInforJSONArray : %@", self.jobHistoryInforJSONArray);
                NSLog(@"dic : %@", [responseObject objectForKey:@"results"]);
    }];
    
    [downloadTask resume];
    
}

/* 인기글 상세 */

-(void)requestDetailJobHistory:(NSString *)hashID {
    
    NSLog(@"requestDetailJobHistory");
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    /* Http Method */
    [request setHTTPMethod:@"GET"];
    NSString *detailResumeURL = [JobHistoryURL stringByAppendingString:hashID];
    [request setURL:[NSURL URLWithString:detailResumeURL]];
    NSString *tokenParam = [@"JWT " stringByAppendingString:[self loadSessionValue]];
    [request setValue:tokenParam forHTTPHeaderField: @"Authorization"];
    
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSLog(@"responseObject : %@", responseObject);
        NSLog(@"response : %@", response);
        
        if (responseObject) {
            NSDictionary *detailPageAllData = responseObject;
            self.jobHistoryDetailInfoJSONDictionary = detailPageAllData;
            
            // 노티피게이션 보내기
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadDetailResumeNotification object:nil];
        }
        else {
            NSLog(@"%@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadDetailResumeFailNotification object:nil];
        }
        NSLog(@"jobHistoryInforJSONArray : %@", self.jobHistoryDetailInfoJSONDictionary);
        NSLog(@"dic : %@", [responseObject objectForKey:@"results"]);
    }];
    
    [downloadTask resume];
    
}


//

-(void)requestMypage {
    
    NSLog(@"requestMypage");
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    /* Http Method */
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:MyPageUrl]];
    
    NSString *tokenParam = [@"JWT " stringByAppendingString:[self loadSessionValue]];
    [request setValue:tokenParam forHTTPHeaderField: @"Authorization"];
    
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"re : %@", responseObject);
        if (responseObject) {
//            NSMutableDictionary *userInfoArray = [[responseObject objectAtIndex:0] objectForKey:@"first_name"];
//            
//            self.userInfoJSONArray = userInfoArray;
            NSLog(@"userInfoJSONArray : %@", self.userInfoJSONArray);
            
            // 노티피게이션 보내기
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoListNotification object:nil];
            
        }else {
            
            NSLog(@"%@", error);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoListFailNotification object:nil];
            
        }
        
//        NSLog(@"dic : %@", [responseObject objectForKey:@"experiences"]);
    }];
    
    [downloadTask resume];

}


@end
