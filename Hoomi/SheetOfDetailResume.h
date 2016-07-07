//
//  SheetOfDetailResume.h
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 2..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheetOfDetailResume : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextView *textView;

-(void)settingSheetOfDetailResume:(NSString *)imageName text:(NSString *)text;

@end
