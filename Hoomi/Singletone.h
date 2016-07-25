//
//  Singletone.h
//  Hoomi
//
//  Created by Jyo on 2016. 7. 6..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LoginSuccessNotifiaction = @"LoginSuccess";
static NSString *LoginFailNotification = @"LoginFail";
static NSString *SignUpSuccessNotification = @"SignUpSuccess";
static NSString *SignUpFailNotification = @"SignUpFail";
static NSString *LoadHitContentSuccessNotification = @"LoadHitContentSuccess";
static NSString *LoadHitContentFailNotification = @"LoadHitContentFail";

static NSString *LoginUrl = @"https://hoomi.work/api/login/";
static NSString *FacebookLoginUrl = @"https://hoomi.work/api/oauth/facebook/";
static NSString *SignUpUrl = @"https://hoomi.work/api/signup/";
static NSString *LoadHitContentUrl = @"https://hoomi.work/api/job-history/?per=4";
static NSString *SaveJobUrl = @"https://hoomi.work/api/mypage/";


/* 컨텐츠 관련 */
static NSString *JobHistoryURL = @"https://hoomi.work/api/job-history/";
static NSString *ContentsListUpdataNotification = @"ContentsListUpdataed";
static NSString *ContentsListFailNotification = @"ContentsListFail";
static NSString *LoadDetailResumeSuccessNotification = @"LoadDetailResumeSuccess";
static NSString *LoadDetailResumeFailNotification = @"LoadDetailResumeFail";
static NSString *LoadNextDetailResumeSuccessNotification = @"LoadNextDetailResumeSuccess";
static NSString *LoadNextDetailResumeFailNotification = @"LoadNextDetailResumeFail";
static NSString *CreatJobHistorySuccessNotification = @"creatJobHistorySuccess";
static NSString *CreatJobHistoryFailNotification = @"creatJobHistoryFail";
static NSString *CreatExperienceSuccessNotification = @"creatExperienceSuccess";
static NSString *CreatExperienceFailNotification = @"creatExperienceFail";
static NSString *SaveUserJobSuccessNotification = @"SaveUserJobSuccess";
static NSString *SaveUserJobFailNotification = @"SaveUserJobFail";


/* 마이페이지 관련 */
static NSString *MyPageUrl = @"https://hoomi.work/api/mypage/";
static NSString *UserInfoListNotification = @"InfoListSuccess";
static NSString *UserInfoListFailNotification = @"InfoListFail";
static NSString *myListDeleteSuccessNotification = @"myListDeleteSuccess";
static NSString *myListDeleteFailNotification = @"myListDeleteSuccess";

/* 로그아웃 관련 */
static NSString *ExpiredMessage = @"Signature has expired.";
static NSString *ExpiredNotification = @"Expired";

#define colorAlpha 1.00 // 색상 투명도
#define MIN_PASSWORD_LENGTH 6 // 최소 패스워드 길이

typedef NS_ENUM(NSInteger, ToastMsg) {

    EmptyLoginData,
    WrongLoginData,
    ExistEmailAddress,
    WrongEmail,
    ShortPassword,
    SuccessSignUp,
    LoginWelcome,

};

typedef NS_ENUM(NSInteger, Color) {
    
    Salmon,
    Concrete,
    Danube,
    Tuna,
    OutrageousOrange,
    Mariner,
    Maco,
    
};

@interface Singletone : NSObject

@property (nonatomic, strong) NSString *hashID;
@property (nonatomic) NSInteger formThemeNumber;

+ (instancetype) requestInstance;

- (UIColor *) colorName:(Color) name;
- (NSString *) toastMsg:(ToastMsg) msg;
- (BOOL) isCorrectEmail:(NSString *) email;

@end
