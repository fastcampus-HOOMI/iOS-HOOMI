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
- (instancetype)initWithContents
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        self.textView = [[UITextView alloc]init];
    }
    return self;
}

@end
