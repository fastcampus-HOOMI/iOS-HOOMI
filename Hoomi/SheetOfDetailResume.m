//
//  SheetOfDetailResume.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 2..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "SheetOfDetailResume.h"

@implementation SheetOfDetailResume

/* 이미지, 텍스트뷰 초기화 함께 */

-(void)settingSheetOfDetailResume:(NSString *)imageName text:(NSString *)text {
    
     /************/
    /* 이미지 세팅 */
   /************/
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/5)];
    /* 이미지 이름 받아서 세팅 -> jpg면 .jpg써줘야함 */
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    [self addSubview:self.imageView];
    
      /**************/
     /* 텍스트뷰 세팅 */
    /*************/
    
    //코드 방식으로 UITextView 생성
    CGFloat offsetX = self.frame.size.width / 2 - (self.frame.size.width - 40) / 2;
    CGRect textViewFrame = CGRectMake(offsetX, self.imageView.frame.size.height + 10, self.frame.size.width - 40, self.frame.size.height - self.imageView.frame.size.height - 20);
    self.textView = [[UITextView alloc] initWithFrame:textViewFrame];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    [self.textView setFont:[UIFont systemFontOfSize:15]];
    [self.textView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    self.textView.text = text;
    
    /* 편집 불가 모드 */
    self.textView.editable = NO;
    self.textView.selectable = NO;
    
    [self addSubview:self.textView];
    

}


@end
