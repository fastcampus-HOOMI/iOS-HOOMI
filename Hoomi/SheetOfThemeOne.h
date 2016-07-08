//
//  SheetOfThemeOne.h
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 8..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheetOfThemeOne : UIView

@property (strong, nonatomic) UIButton *uploadButton;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextView *textView;

- (instancetype)initWithThemeFrame;

-(void)settngUploadSheet;

@end
