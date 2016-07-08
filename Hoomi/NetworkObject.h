//
//  NetworkObject.h
//  Hoomi
//
//  Created by Jyo on 2016. 7. 8..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkObject : NSObject

- (void)initSignInUserID:(NSString *)userID password:(NSString *)password;
- (void)initSignUpUserID:(NSString *)userID name:(NSString *)name password:(NSString *)password;

- (void)requestSignIn;
- (void)requestSignUp;


@end
