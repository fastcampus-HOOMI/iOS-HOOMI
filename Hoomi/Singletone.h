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
static NSString *LoginUrl = @"https://hoomi.work/api/mobile/login/";

@interface Singletone : NSObject

+ (instancetype) requestInstance;

- (UIColor *) colorKey:(NSString *) colorName;

@end
