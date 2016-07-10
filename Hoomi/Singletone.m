//
//  Singletone.m
//  Hoomi
//
//  Created by Jyo on 2016. 7. 6..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "Singletone.h"

@implementation Singletone

+ (instancetype) requestInstance {
    
    static Singletone *singleTone = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleTone = [[Singletone alloc] init];
        
    });
    
    return singleTone;
    
}

- (UIColor *) colorName:(Color) name {
    
    UIColor *returnColorValue = nil;
    
    switch (name) {
        case Salmon:
            returnColorValue = [UIColor colorWithRed:0.94 green:0.51 blue:0.44 alpha:colorAlpha];
            break;
        case Concrete:
            returnColorValue = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:colorAlpha];
            break;
        case Danube:
            returnColorValue = [UIColor colorWithRed:0.36 green:0.50 blue:0.89 alpha:colorAlpha];
            break;
        case Tuna:
            returnColorValue = [UIColor colorWithRed:0.20 green:0.21 blue:0.26 alpha:colorAlpha];
            break;
        case OutrageousOrange:
            returnColorValue = [UIColor colorWithRed:0.97 green:0.40 blue:0.18 alpha:colorAlpha];
            break;
        case Mariner:
            returnColorValue = [UIColor colorWithRed:0.25 green:0.36 blue:0.59 alpha:colorAlpha];
            break;
        case Maco:
            returnColorValue = [UIColor colorWithRed:0.28 green:0.29 blue:0.33 alpha:colorAlpha];
            break;
        default:
            break;
    }

    return returnColorValue;
    
}

- (NSString *) errorMsg:(ErrorMsg) msg {

    NSString *returnErrorMsg = @"";
    
    switch (msg) {
        case EmptyLoginData:
            returnErrorMsg = @"빈칸을 입력해주세요.";
            break;
        case WrongLoginData:
            returnErrorMsg = @"아이디 또는 패스워드를 확인해주세요.";
            break;
        case ExistEmailAddress:
            returnErrorMsg = @"이미 존재하는 Email입니다.";
            break;
        case WrongEmail:
            returnErrorMsg = @"Email 형식이 맞지않습니다.";
            break;
        case ShortPassword:
            returnErrorMsg = [NSString stringWithFormat:@"패스워드를 %d글자 이상입력해주세요.", MIN_PASSWORD_LENGTH];
        default:
            break;
    }
    return returnErrorMsg;
}



@end
