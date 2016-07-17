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

/* 임시데이터 시절 데이터 리스트 */
@property (nonatomic, strong) NSArray<NSString *> *imageNameList;
@property (nonatomic, strong) NSArray<NSString *> *textList;

/* network 연동 후, 데이터 리스트 */
@property (nonatomic, strong) NSDictionary *contentsDictionary;
@property (nonatomic, strong) NSMutableArray *imageURLList;
@property (nonatomic, strong) NSMutableArray *textDataList;



/* 총 장수 */
@property (nonatomic) NSInteger totalPageNumber;

@end
