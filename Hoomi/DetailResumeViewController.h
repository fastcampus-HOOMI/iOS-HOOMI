//
//  DetialResumeViewController.h
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 1..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailResumeViewController : UIViewController

@property (nonatomic, strong) NSString *hashID;

@property (nonatomic, strong) NSArray<NSString *> *imageNameList;
@property (nonatomic, strong) NSArray<NSString *> *textList;

/* 데이터 보관 */
@property (nonatomic, strong) NSMutableArray *contentsArray;

/* 총 장수 */
@property (nonatomic) NSInteger totalPageNumber;

@end
