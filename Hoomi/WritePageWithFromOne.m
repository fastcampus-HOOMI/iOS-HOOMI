//
//  WritePageWithFromOne.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 6..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "WritePageWithFromOne.h"

@interface WritePageWithFromOne ()

@end


@implementation WritePageWithFromOne


/* 빈 이미지, 텍스트뷰 초기화 함께 */
-(void)settingTempFormOne {
    
    [self creatTempImageAndUploadIcon];
    [self creatTextView];
}

-(void)creatTempImageAndUploadIcon {
    
    /******************/
    /* temp 이미지 세팅 */
    /****************/
    
    self.tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/5)];
    /* 이미지 이름 받아서 세팅 -> jpg면 .jpg써줘야함 */
    [self.tempImage setImage:[UIImage imageNamed:@"grayColor.jpg"]];
    self.tempImage.contentMode = UIViewContentModeScaleAspectFill;
    self.tempImage.clipsToBounds = YES;
    [self addSubview:self.tempImage];
    
    /************/
    /* 업로드 버튼 */
    /***********/
    
    // temp이미지 위로 가서 거기 위에 중간에 있어야 함
    self.uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    
    
    
}

-(void)creatTextView {
    
    /**************/
    /* 텍스트뷰 세팅 */
    /*************/
    
    //코드 방식으로 UITextView 생성
    //    CGFloat offsetX = self.frame.size.width / 2 - (self.frame.size.width - 40) / 2;
    //    CGRect textViewFrame = CGRectMake(offsetX, self.imageView.frame.size.height + 10, self.frame.size.width - 40, self.frame.size.height - self.imageView.frame.size.height - 20);
    //    self.textView = [[UITextView alloc] initWithFrame:textViewFrame];
    //    self.textView.backgroundColor = [UIColor lightGrayColor];
    //    self.textView.text = text;
    //    NSString *textViewText = self.textView.text;
    //
    //    /* 텍스트줄 간격, 폰트, 크기 */
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textViewText];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.lineSpacing = 15;
    //    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle};
    //    [attributedString addAttributes:dict range:NSMakeRange(0, [textViewText length])];
    //    self.textView.attributedText = attributedString;
    //    self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    //
    //    /* 편집 불가 모드 */
    ////    self.textView.editable = NO;
    ////    self.textView.selectable = NO;
    //    
    //    [self addSubview:self.textView];
}




@end
