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

- (UIColor *) colorKey:(NSString *) colorName {
    
    NSMutableDictionary *colorDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [colorDic setObject:[UIColor colorWithRed:0.94 green:0.51 blue:0.44 alpha:1.00] forKey:@"salmon"];
    [colorDic setObject:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00] forKey:@"concrete"];
    [colorDic setObject:[UIColor colorWithRed:0.36 green:0.50 blue:0.89 alpha:1.00] forKey:@"danube"];
    [colorDic setObject:[UIColor colorWithRed:0.20 green:0.21 blue:0.26 alpha:1.00] forKey:@"tuna"];
    [colorDic setObject:[UIColor colorWithRed:0.97 green:0.40 blue:0.18 alpha:1.0] forKey:@"outrageous orange"];
    [colorDic setObject:[UIColor colorWithRed:0.25 green:0.36 blue:0.59 alpha:1.0] forKey:@"mariner"];
    
    
    return [colorDic objectForKey:colorName];
    
    
}



@end
