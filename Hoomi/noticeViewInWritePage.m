//
//  noticeViewInWritePage.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 26..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "noticeViewInWritePage.h"

@interface noticeViewInWritePage ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *noticeImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UITextView *text;

@end

@implementation noticeViewInWritePage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self settingObjectFrameOfNoticeView];
    }
    return self;
}

-(void)settingObjectFrameOfNoticeView {
    
    CGRect backViewSize = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.backgroundView = [[UIView alloc]initWithFrame:backViewSize];
    self.noticeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.backgroundView.frame.size.width - 30, self.backgroundView.frame.size.height - 30)];
    
}

@end
