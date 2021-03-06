//
//  AppDelegate.m
//  Hoomi
//
//  Created by Jyo on 2016. 6. 27..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkObject.h"
#import "Singletone.h"
#import "MainTableViewController.h"
#import "SignInViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@property (nonatomic, strong) NetworkObject *networkObject;
@property (nonatomic, strong) Singletone *singleTone;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.networkObject = [NetworkObject requestInstance];
    self.singleTone = [Singletone requestInstance];

    
    NSString *jtwToken = [self.networkObject loadSessionValue];
    NSLog(@"AppDelegate jtwToken : %@", jtwToken);
    
    // 로그인되어있는지 체크
    if(jtwToken != nil) {
        
        [self setRootViewControllerIsMain];
        NSLog(@"로그인 된 상태");
        
    }
    
    return YES;
}

- (void)setRootViewControllerIsMain {
    
    // User is logged in, do work such as go to next view controller.
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Uma" bundle:nil];
    MainTableViewController *mainViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MainTableView"];
    
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
           return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
                   ];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
