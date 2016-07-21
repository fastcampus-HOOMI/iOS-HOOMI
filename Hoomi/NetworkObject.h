//
//  NetworkObject.h
//  Hoomi
//
//  Created by Jyo on 2016. 7. 8..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkObject : NSObject

@property (nonatomic) NSArray *hitContentDic;

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

// Load Main
- (void)requestHitContent;

- (void)saveSessionValue:(NSString *)session;
- (NSString *)loadSessionValue;


/* contents Load 관련 */
@property (nonatomic, strong) NSArray *jobHistoryInforJSONArray;
@property (nonatomic, strong) NSArray *hitContentInforJSONArray;
@property (nonatomic, strong) NSMutableDictionary *jobHistoryDetailAllInfoJSONDictionary;
@property (nonatomic, strong) NSMutableDictionary *jobHistoryDetailContentsInfoDictionary;
@property (nonatomic) NSInteger detailPageTotalCount;
@property (nonatomic, strong) NSString *nextURL;
@property (nonatomic, strong) NSString *previousURL;
-(void)requestjobHistory;
-(void)requestDetailJobHistory:(NSString *)hashID;
-(void)requestDetailPageAfterMovePage:(NSString *)movePageURL;

//User Info
@property (nonatomic, strong) NSMutableDictionary *userInfoJSONArray;
@property (nonatomic, strong) NSArray *myWritingListJSONArray;

-(void)requestMypage;

@end
