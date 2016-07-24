//
//  SheetOfThemeOne.h
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 8..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SheetOfThemeOneDelegate <NSObject>

-(void)onTouchUpInsideUploadButton;

@end


@interface SheetOfThemeOne : UIView

@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextView *textView;

- (instancetype)initWithFrame:(CGRect)frame;

/* 업로드, 보기 모드 불러오기 */
-(void)settingUploadResume;
-(void)settingDetailResume:(UIImage *)image text:(NSString *)text isWriteSheet:(BOOL)isWriteSheet;

/* delegate */
@property (weak, nonatomic) id<SheetOfThemeOneDelegate> delegate;

@end
