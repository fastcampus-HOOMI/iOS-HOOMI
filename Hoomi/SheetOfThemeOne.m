//
//  SheetOfThemeOne.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 8..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "SheetOfThemeOne.h"

@interface SheetOfThemeOne ()

/* frame size */
@property (nonatomic) CGRect imageFrame;
@property (nonatomic) CGRect textViewFrame;

/* backgroundView under imageView */
@property (nonatomic, strong) UIView *backgroundView;

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
    [self creatImageSectionInSheet:nil haveImage:NO isWriteSheet:YES];
    
    /* 업로드 버튼 */
    [self creatUploadButton];
    
    /* 텍스트 뷰 - 에디팅 가능 */
    NSString *comment = @"무엇을 표현하고 싶으신가요?";
    [self creatTextView:comment canEdit:YES];
    
    
    
}


   /***********/
  /* 상세 화면 */
 /***********/

-(void)settingDetailResume:(UIImage *)image text:(NSString *)text isWriteSheet:(BOOL)isWriteSheet {
    [self creatImageSectionInSheet:image haveImage:YES isWriteSheet:(BOOL)isWriteSheet];
    /* 텍스트 뷰 세팅 -> canNotEdit 보기 모드로 */
    [self creatTextView:text canEdit:NO];
    
}


    /*******************/
   /* Contents Object */
  /*******************/

#pragma mark - contents frame size

/* 테마1 사이즈 세팅 */
-(void)settingObjectFrameOfThemeOne {
    
    self.imageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/5);
    
    /* 텍스트뷰 프레임 */
    //CGFloat offsetX = self.frame.size.width / 2 - (self.frame.size.width - 40) / 2;
    CGFloat margin = 20;
    self.textViewFrame = CGRectMake(margin, self.imageFrame.size.height + 10, self.frame.size.width - margin*2, self.frame.size.height - self.imageFrame.size.height - 20);
    
}

#pragma mark - creat image section

-(void)creatImageSectionInSheet:(UIImage *)image haveImage:(BOOL)haveImage isWriteSheet:(BOOL)isWriteSheet {
    [self creatBackgroundView:isWriteSheet];
    [self creatImageView:image haveImage:haveImage isWriteSheet:isWriteSheet];
}

/* 이미지뷰 아래 view */
-(void)creatBackgroundView:(BOOL)isWriteSheet {
    self.backgroundView = [[UIView alloc]initWithFrame:self.imageFrame];
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    if (isWriteSheet) {
        self.backgroundView.layer.cornerRadius = 10.0;//곡선
    }
    [self addSubview:self.backgroundView];
}

/* 이미지 뷰 */
-(void)creatImageView:(UIImage *)image haveImage:(BOOL)haveImage isWriteSheet:(BOOL)isWriteSheet {
    self.imageView = [[UIImageView alloc]initWithFrame:self.backgroundView.bounds];
    if (haveImage == YES) {
        self.imageView.image = image;
    }
    if (haveImage == NO) {
        self.imageView.image = nil;
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    if (isWriteSheet) {
        self.imageView.layer.cornerRadius = 10.0;//곡선
    }
    // 이미지뷰 터치 가능하도록 설정
    [self.imageView setUserInteractionEnabled:YES];
    [self.backgroundView addSubview:self.imageView];
}

#pragma mark - creat textView

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
    self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    /* 편집 불가 모드 */
    if (canEdit == NO) {
        self.textView.editable = NO;
        self.textView.selectable = NO;
    }
    
    [self addSubview:self.textView];
}

/* 업로드 버튼 */
-(void)creatUploadButton {
    
    CGFloat buttonSize = 30;
    
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
