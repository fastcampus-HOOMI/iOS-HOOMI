//
//  RequestUserInfo.m
//  Hoomi
//
//  Created by 이은경 on 2016. 7. 14..
//  Copyright © 2016년 Jyo. All rights reserved.
//

//#import "RequestUserInfo.h"
//#import <AFURLSessionManager.h>
//#import <UIProgressView+AFNetworking.h>
//#import <AFHTTPSessionManager.h>
//
//@implementation RequestUserInfo : NSObject 
//
//+(instancetype)shareInstance {
//    
//    static RequestUserInfo *userInfo = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        userInfo = [[RequestUserInfo alloc] init];
//
//    });
//    
//    return userInfo;
//}
//
////user 정보 받아오기
//-(void)requestUserInfoList {
//    
//    NSString *URLString = [NSString stringWithFormat:@"https://hoomi.work/api/mypage", self.userInfoList];
//    NSURL *requestURL = [NSURL URLWithString:URLString];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setHTTPMethod:@"Get"];
//    [request setURL:requestURL];
//    
//    NSURLSessionTask *infoDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@", response);
//        NSLog(@"%@", error);
//        
//        if (data) {
//            NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            
//            if ([dict[@"code"] isEqualToString:@200]) {
//                NSLog(@"success");
//                
//                NSArray *infoArray = dict[@"userinfp"];
//                //
//                
//                //노티피케이션
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoListNotification object:nil];
//            } else {
//                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoFailListNotification object:nil];
//            }
//            
//            NSLog(@"%@", dict);
//            NSLog(@"%@", self.userInfoJSONArray);
//                
//            }
//    }];
//    
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [dataTask resume];
//    
//    }
//
//-(void)reloadDataWithAFNetwork {
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSString *URLString = [NSString stringWithFormat:@"http://ios.yevgnenll.me/api/images/?user_id=%@", self.userID];
//    NSURL *URL = [NSURL URLWithString:URLString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"%@", error);
//        
//        if (responseObject) {
//            
//            if ([responseObject[@"code"] isEqualToNumber:@200]) {
//                NSLog(@"success");
//                
//                NSArray *contentsArray = responseObject[@"content"];
//                self.imageInforJSONArray = contentsArray;
//                
//                // 노티피게이션 보내기
//                [[NSNotificationCenter defaultCenter] postNotificationName:ImageListUpdataNotification object:nil];
//            } else {
//                [[NSNotificationCenter defaultCenter] postNotificationName:ImageListFailNotification object:nil];
//            }
//            
//            NSLog(@"dic : %@", responseObject);
//            NSLog(@"%@", self.imageInforJSONArray);
//        }
//        
//    }];
//    
//    [downloadTask resume];
//}
//
//
//@end
