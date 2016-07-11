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
static NSString *LoadMainView = @"MainTableView";
static NSString *LoginUrl = @"https://hoomi.work/api/mobile/login/";
static NSString *FacebookLoginUrl = @"https://hoomi.work/api/mobile/signup/facebook/";
static NSString *SignUpUrl = @"https://hoomi.work/api/mobile/signup/";

#define colorAlpha 1.00 // 색상 투명도
#define MIN_PASSWORD_LENGTH 4 // 최소 패스워드 길이

typedef NS_ENUM(NSInteger, ErrorMsg) {

    EmptyLoginData,
    WrongLoginData,
    ExistEmailAddress,
    WrongEmail,
    ShortPassword,

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

+ (instancetype) requestInstance;

- (UIColor *) colorName:(Color) name;
- (NSString *) errorMsg:(ErrorMsg) msg;
- (BOOL) isCorrectEmail:(NSString *) email;

@end
