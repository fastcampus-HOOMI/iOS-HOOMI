//
//  SheetOfDetailResume.h
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 2..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheetOfDetailResume : UIView

/* 오토레이아웃해서 중복 객체 만들었던거 지우고 코드로 세팅 */

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextView *textView;


-(void)settingSheetOfDetailResume:(NSString *)imageName text:(NSString *)text;

@end
