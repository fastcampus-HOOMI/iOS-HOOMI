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
@property (nonatomic) NSInteger errorCount;

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
                          
                          NSLog(@"session : %@", responseObject);
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
                NSLog(@"NetworkObjectDic : %@", [responseObject objectForKey:@"results"]);
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

/* 상세 화면 보기 */
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
//        NSLog(@"responseObject : %@", responseObject);
//        NSLog(@"response : %@", response);        
        if (responseObject) {
            NSMutableDictionary *detailPageAllData = responseObject;
            /* 전체 정보 / 컨텐트 정보 Dictionary 세팅 */
            self.jobHistoryDetailAllInfoJSONDictionary = detailPageAllData;
            [self pickDetailContent];
            // 노티피게이션 보내기
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadDetailResumeSuccessNotification object:nil];
        }
        else {
            self.errorCount ++;
            NSLog(@"error - %@", error);
            /* 재시도 */
            //            if (self.errorCount > 5) {
            //                [self requestDetailJobHistory:hashID];
            //            }
            //            else {
            //                            
            //        }
            NSLog(@"errorCount - %ld", self.errorCount);
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadDetailResumeFailNotification object:nil];
        }

        //NSLog(@"jobHistoryDetail - AllInfoJSONDictionary : %@", self.jobHistoryDetailAllInfoJSONDictionary);
        //NSLog(@"jobHistoryDetail - ContentsInfoDictionary : %@", self.jobHistoryDetailContentsInfoDictionary);
    }];
    
    [downloadTask resume];
    
}

/* 상세 컨텐츠 정보 프로퍼티로 세팅 */
-(void)pickDetailContent {
    
    /* count */
    self.detailPageTotalCount = [[self.jobHistoryDetailAllInfoJSONDictionary objectForKey:@"count"] integerValue];
    //NSLog(@"🐈🐈🐈🐈🐈pick Detail Contents %ld", self.detailPageTotalCount);
    
    /* next/previous PageURL */
    self.nextURL = [self.jobHistoryDetailAllInfoJSONDictionary objectForKey:@"next"];
    self.previousURL = [self.jobHistoryDetailAllInfoJSONDictionary objectForKey:@"previous"];
    
    //NSLog(@"🐈nextURL %@", self.nextURL);
    //NSLog(@"🐈previousURL %@", self.previousURL);
    
    /* result - 상세 컨텐츠 */
    self.jobHistoryDetailContentsInfoDictionary = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    /* contents dic - array 안에 Dictionary가 들어가있어서 두 번 뺌 */
    NSArray *resultArray = [self.jobHistoryDetailAllInfoJSONDictionary objectForKey:@"results"];
    NSDictionary *resultDictionary = [resultArray objectAtIndex:0];
    
    [self.jobHistoryDetailContentsInfoDictionary setValue:[resultDictionary objectForKey:@"content"] forKey:@"content"];
    [self.jobHistoryDetailContentsInfoDictionary setValue:[resultDictionary objectForKey:@"image"] forKey:@"image"];
    
    //NSLog(@"🐈🐈🐈🐈 jobHistoryDetailContentsInfoDictionary - %@", self.jobHistoryDetailContentsInfoDictionary);
    
}

/* 페이지 로드 후, 움직일 때 = nextPage 또는 previousPage */
-(void)requestDetailPageAfterMovePage:(NSString *)movePageURL {
    
    NSLog(@"requestDetailPageAfterMovePage");
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    /* Http Method */
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:movePageURL]];
    NSString *tokenParam = [@"JWT " stringByAppendingString:[self loadSessionValue]];
    [request setValue:tokenParam forHTTPHeaderField: @"Authorization"];
    
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        //NSLog(@"responseObject : %@", responseObject);
        //NSLog(@"response : %@", response);
        
        if (responseObject) {
            NSMutableDictionary *detailPageAllData = responseObject;
            /* 전체 정보 / 컨텐트 정보 Dictionary 세팅 */
            self.jobHistoryDetailAllInfoJSONDictionary = detailPageAllData;
            [self pickDetailContent];
            // 노티피게이션 보내기
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadNextDetailResumeSuccessNotification object:nil];
        }
        else {
            NSLog(@"%@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadNextDetailResumeFailNotification object:nil];
        }
        //NSLog(@"jobHistoryDetail - AllInfoJSONDictionary : %@", self.jobHistoryDetailAllInfoJSONDictionary);
        //NSLog(@"jobHistoryDetail - ContentsInfoDictionary : %@", self.jobHistoryDetailContentsInfoDictionary);
    }];
    
    [downloadTask resume];
    
}

    /*************************/
   /*  upload image & text  */
  /*************************/

/* -------- cheeseing */

/* 최초 업로드
 
 https://hoomi.work/api/job-history/로 Header에 Authorization 값에 JWT Token을 실어야 한다.
 theme를 Post 로 보낸다.

 */

-(void)uploadTaskForMutipartWithAFNetwork:(UIImage *)image title:(NSString *)title {
    
    
    // 일반 제이슨, 폼으로 보내도 된다. themeNumber만 넘겨주기 때문에 -> 알아볼 것 (cheese)
    
//    
//    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
//    [bodyParams setObject:self.userID forKey:@"user_id"];
//    [bodyParams setObject:title forKey:@"title"];
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://ios.yevgnenll.me/api/images/" parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
//        
//        [formData appendPartWithFileData:imageData name:@"image_data" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
//        
//    } error:nil];
//    
//    /* 해더 */
//    NSString *tokenParam = [@"JWT " stringByAppendingString:[self loadSessionValue]];
//    [request setValue:tokenParam forHTTPHeaderField: @"Authorization"];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            
//            //
//            //노티 안만들어도 되낭
//            NSLog(@"%@ %@", response, responseObject);
//        }
//    }];
//    [dataTask resume];
    
    NSLog(@"네트워크로 업로드");
}

/* 나머지 업로드 
 
 parent job-history의 child experience를 추가하고자 할때 사용
 https://hoomi.work/api/job-history/<hash_id>/로 Header에 Authorization 값에 JWT Token을 실어야 한다.
 image, content, page 를 Post 로 보낸다.
 
 */
//title 을 contents로 바꿔야할듯
// 계속 응답받고, 다시 또 부를 부분 -> 루프를 어떻게 돌릴지
-(void)uploadExperienceForMutipartWithAFNetwork:(NSString *)hashID image:(UIImage *)image content:(NSString *)content page:(NSString *)page {
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:content forKey:@"content"];
    [bodyParams setObject:page forKey:@"page"];
    
    NSString *creatExperienceURL = [JobHistoryURL stringByAppendingString:hashID];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:creatExperienceURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        
        //---- 근데 왜 jpeg지? cheeseing
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
        
    } error:nil];
    
    /* 해더 */
    NSString *tokenParam = [@"JWT " stringByAppendingString:[self loadSessionValue]];
    [request setValue:tokenParam forHTTPHeaderField: @"Authorization"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            // 노티피게이션 보내기
            [[NSNotificationCenter defaultCenter] postNotificationName:CreatExperienceSuccessNotification object:nil];
        } else {
            // 노티피게이션 보내기  --> write에 옵저버 등록
            [[NSNotificationCenter defaultCenter] postNotificationName:CreatExperienceFailNotification object:nil];
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
}






//Mypage api 받아오기
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
        
        NSLog(@"resault(responseObject): %@", responseObject); //api (mypage한정) 전체를 받아옴
        NSLog(@"response: %@", response); //api (mypage한정) 전체를 받아옴
        
        if (responseObject) {

            NSArray *userInfoArray = @[@[[[responseObject objectAtIndex:0] objectForKey:@"first_name"]],
                                       @[[[responseObject objectAtIndex:0] objectForKey:@"last_name"]],
                                       @[[[responseObject objectAtIndex:0] objectForKey:@"username"]],
                                       @[[[responseObject objectAtIndex:0] objectForKey:@"job"]],
                                       @[[[responseObject objectAtIndex:0] objectForKey:@"hash_id"]]
                                       ];

            self.userInfoJSONArray = userInfoArray;
            
            //NSArray *myListArray = [[responseObject objectAtIndex:0] objectForKey:@"experiences"];
            self.myContentListJSONArray = [[responseObject objectAtIndex:0] objectForKey:@"experiences"];
            
            NSLog(@"userInfoJSONArray : %@", self.userInfoJSONArray);
            NSLog(@"myContentListJSONArray : %@", self.myContentListJSONArray);
            
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
