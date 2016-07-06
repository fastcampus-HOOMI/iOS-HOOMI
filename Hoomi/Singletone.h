//
//  Singletone.h
//  Hoomi
//
//  Created by Jyo on 2016. 7. 6..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Singletone : NSObject

+ (instancetype) requestInstance;

- (UIColor *) colorKey:(NSString *) colorName;

@end
