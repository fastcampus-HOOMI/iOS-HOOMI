//
//  SheetOfDetailResume.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 2..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "SheetThemeOneOfDeatilPage.h"

@interface SheetThemeOneOfDeatilPage ()

/* 객체 크기 프로퍼티 생성 예정 */
@property (nonatomic) CGRect imageFrame;
@property (nonatomic) CGRect textViewFrame;

@end

@implementation SheetThemeOneOfDeatilPage

- (instancetype)initWithFrameThemeOne
{
    self = [super init];
    if (self) {
        /* 객체 사이즈 세팅 */
        [self settingFrameOfThemeOne];
    }
    return self;
}

-(void)settingFrameOfThemeOne {
    
    self.imageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/5);
    
    CGFloat offsetX = self.frame.size.width / 2 - (self.frame.size.width - 40) / 2;
    self.textViewFrame = CGRectMake(offsetX, self.imageView.frame.size.height + 10, self.frame.size.width - 40, self.frame.size.height - self.imageView.frame.size.height - 20);

}

  /***********************/
 /*    빈 화면 템플릿      */
/***********************/

-(void)creatTempSheetForUpload {
    
    UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:self.imageFrame];
    [tempImageView setImage:[UIImage imageNamed:@"uploadIcon"]];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempImageView.clipsToBounds = YES;
    [self addSubview:tempImageView];
    
    //버튼 추가 ----todo
    
    UITextView *tempTextView = [[UITextView alloc] initWithFrame:self.textViewFrame];
    tempTextView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.textView];
    
}


   /***********/
  /* 상세 화면 */
 /***********/

/* 이미지, 텍스트뷰 초기화 함께 */

-(void)settingSheetOfDetailResume:(NSString *)imageName text:(NSString *)text {
    
     /************/
    /* 이미지 세팅 */
   /************/
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/5)];
    /* 이미지 이름 받아서 세팅 -> jpg면 .jpg써줘야함 */
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self addSubview:self.imageView];
    
      /**************/
     /* 텍스트뷰 세팅 */
    /*************/
    
    //코드 방식으로 UITextView 생성
    CGFloat offsetX = self.frame.size.width / 2 - (self.frame.size.width - 40) / 2;
    CGRect textViewFrame = CGRectMake(offsetX, self.imageView.frame.size.height + 10, self.frame.size.width - 40, self.frame.size.height - self.imageView.frame.size.height - 20);
    self.textView = [[UITextView alloc] initWithFrame:textViewFrame];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.text = text;
    NSString *textViewText = self.textView.text;
    
    /* 텍스트줄 간격, 폰트, 크기 */
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textViewText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 15;
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle};
    [attributedString addAttributes:dict range:NSMakeRange(0, [textViewText length])];
    self.textView.attributedText = attributedString;
    self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    
    /* 편집 불가 모드 */
    self.textView.editable = NO;
    self.textView.selectable = NO;
    
    [self addSubview:self.textView];

}


@end
