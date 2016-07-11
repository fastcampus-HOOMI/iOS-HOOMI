//
//  SheetOfThemeOne.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 8..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "SheetOfThemeOne.h"

@interface SheetOfThemeOne ()

@property (nonatomic) CGRect imageFrame;
@property (nonatomic) CGRect textViewFrame;

@end

@implementation SheetOfThemeOne


/* 초기화 -> 프레임 공유 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /* 테마1 객체 사이즈 세팅 */
        [self settingObjectFrameOfThemeOne];
    }
    return self;
}


   /******************************/
  /*    업로드 전 빈 화면 템플릿      */
 /******************************/

-(void)settingUploadResume {
    
    /* temp 이미지 세팅 */
    NSString *tempImageName = @"grayColor.jpg";
    [self creatImageView:tempImageName];
    
    /* 업로드 버튼 */
    [self creatUploadButton];
    
    /* 버튼 관련 함수는 쓰는 곳에서 세팅해줘야함 */
    //[self.uploadButton addTarget:self action:@selector(actionName:) forControlEvents:UIControlEventTouchUpInside];
    
    /* 텍스트 뷰 - 에디팅 가능 */
    NSString *comment = @"자신을 자유롭게 표현해주세요.";
    [self creatTextView:comment canEdit:YES];
    
    
    
}

   /****************/
  /*   수정 화면    */
 /****************/

-(void)settingEditResume {
    
}


   /***********/
  /* 상세 화면 */
 /***********/

/* 이미지, 텍스트뷰 초기화 함께 */
/* 현재는 이미지 name으로 넣지만, 앞으로는 서버 이미지 받아오는 것으로 할 것 - cheesing */

-(void)settingDetailResume:(NSString *)imageName text:(NSString *)text {
    [self creatImageView:imageName];
    /* 텍스트 뷰 세팅 -> canNotEdit 보기 모드로 */
    [self creatTextView:text canEdit:NO];
    
}


    /*******************/
   /* Contents Object */
  /*******************/


/* 사이즈 세팅 */
-(void)settingObjectFrameOfThemeOne {
    
    self.imageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/5);
    
    /* 텍스트뷰 프레임 */
    //CGFloat offsetX = self.frame.size.width / 2 - (self.frame.size.width - 40) / 2;
    CGFloat margin = 20;
    self.textViewFrame = CGRectMake(margin, self.imageFrame.size.height + 10, self.frame.size.width - margin*2, self.frame.size.height - self.imageFrame.size.height - 20);
    
}


/* 이미지 뷰 */
-(void)creatImageView:(NSString *)imageName {
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.imageFrame];
    /* 이미지 이름 받아서 세팅 -> jpg면 .jpg써줘야함 */
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    // 이미지뷰 터치 가능하도록 설정
    [self.imageView setUserInteractionEnabled:YES];
    [self addSubview:self.imageView];
}


/* 텍스트 뷰 */
-(void)creatTextView:(NSString *)text canEdit:(BOOL)canEdit {
    //코드 방식으로 UITextView 생성
    self.textView = [[UITextView alloc] initWithFrame:self.textViewFrame];
    //self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.text = text;
    //placeholder 추가 (- cheesing)
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
    if (canEdit == NO) {
        self.textView.editable = NO;
        self.textView.selectable = NO;
    }
    
    [self addSubview:self.textView];
}

/* 업로드 버튼 */
-(void)creatUploadButton {
    
    CGFloat buttonSize = 50;
    
    self.uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(self.imageFrame.size.width/2 - buttonSize/2, self.imageFrame.size.height/2 - buttonSize/2, buttonSize, buttonSize)];
    [self.uploadButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadButton setBackgroundImage:[UIImage imageNamed:@"uploadIcon"] forState:UIControlStateNormal];
    [self.imageView addSubview:self.uploadButton];

}


    /*******************/
   /*    delegate     */
  /*******************/

/* 델리게이트 실행 */
- (void)buttonAction
{
    if ([self.delegate respondsToSelector:@selector(onTouchUpInsideUploadButton)]) {
        [self.delegate onTouchUpInsideUploadButton];
    }
    
}

@end
