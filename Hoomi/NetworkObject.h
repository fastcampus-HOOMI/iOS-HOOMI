//
//  NetworkObject.h
//  Hoomi
//
//  Created by Jyo on 2016. 7. 8..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkObject : NSObject

@property (nonatomic) NSDictionary *hitContentDic;

+ (instancetype) requestInstance;

- (void)initSignInUserID:(NSString *)userID password:(NSString *)password;
- (void)initSignUpUserID:(NSString *)userID lastName:(NSString *)lastName firstName:(NSString *)firstName password:(NSString *)password;

// Default
- (void)requestSignIn;
- (void)requestSignUp;

// Social
- (void)requestFacebookSignUpToken:(NSString *)token;

// Save Job
- (void)requestSaveJob:(NSString *)job Token:(NSString *)token;

- (void)saveSessionValue:(NSString *)session;
- (NSString *)loadSessionValue;

@end
