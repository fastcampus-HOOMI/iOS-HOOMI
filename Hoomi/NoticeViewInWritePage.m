//
//  noticeViewInWritePage.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 26..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "NoticeViewInWritePage.h"

@interface NoticeViewInWritePage ()

@property (nonatomic, strong) UIImageView *noticeImage;

@end

@implementation NoticeViewInWritePage

- (instancetype)initWithNoticeFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self settingNoticeObjectFrame];
    }
    return self;
}

-(void)settingNoticeObjectFrame {
    
    CGRect backViewSize = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat buttonSize = 30;
    
    self.noticeImage = [[UIImageView alloc]initWithFrame:backViewSize];

    CGFloat closeButtonOffsetX = self.noticeImage.frame.size.width - buttonSize;
    self.closeButton = [[UIButton alloc]initWithFrame:CGRectMake(closeButtonOffsetX, 0, buttonSize, buttonSize)];
}

-(void)creatNoticeViewObject {
    
    self.noticeImage.image = [UIImage imageNamed:@"notice2"];
    self.noticeImage.contentMode = UIViewContentModeScaleAspectFill;
    self.noticeImage.clipsToBounds = YES;
    [self.noticeImage setUserInteractionEnabled:YES];
    [self addSubview:self.noticeImage];
    
//    [self.closeButton setTitle:@"x" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(noticeViewInWritePageDelegate) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.backgroundColor = [UIColor clearColor];
    [self.noticeImage addSubview:self.closeButton];
    
}



/*******************/
/*    delegate     */
/*******************/

/* 델리게이트 실행 */
- (void)noticeViewInWritePageDelegate {
    if ([self.delegate respondsToSelector:@selector(onTouchUpInsideCloseButton)]) {
        [self.delegate onTouchUpInsideCloseButton];
    }
    
}


@end
