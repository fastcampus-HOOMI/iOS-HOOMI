//
//  noticeViewInWritePage.h
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 26..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeViewInWritePageDelegate <NSObject>

-(void)onTouchUpInsideCloseButton;

@end


@interface NoticeViewInWritePage : UIView

@property (nonatomic, strong) UIButton *closeButton;

- (instancetype)initWithNoticeFrame:(CGRect)frame;
-(void)creatNoticeViewObject;

/* delegate */
@property (nonatomic, weak) id<NoticeViewInWritePageDelegate> delegate;

@end
