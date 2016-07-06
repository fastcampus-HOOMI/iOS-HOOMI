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

@end
