//
//  DetialResumeViewController.h
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 1..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailResumeViewController : UIViewController

@property (nonatomic, strong) NSArray<NSString *> *imageNameList;
@property (nonatomic, strong) NSArray<NSString *> *textList;
@property (nonatomic) NSInteger totalPageNumber;

@end
