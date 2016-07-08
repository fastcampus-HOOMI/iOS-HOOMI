//
//  WritePageViewController.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 6..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "WritePageViewController.h"
#import "SheetOfThemeOne.h"

@interface WritePageViewController () <SheetOfThemeOneDelegate>

@property (nonatomic) CGFloat offsetX;

@end

@implementation WritePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 임시 form 데이터
       네트워크 연결 후에는 헤더 파일에 있는
       외부 프로퍼티를 통해 form 데이터 받아서 연결*/
    [self selectTheme:1];
    
    //[self selectTheme:self.formNumber];
}

-(void)selectTheme:(NSInteger)formNumber {
    
    if (formNumber == 1) {
        [self creatWriteSheet];
    }
    
}

-(void)creatWriteSheet {
    
    CGFloat navigationMargin = 40;
    CGFloat margin = 40;
    CGRect writeSheetSize = CGRectMake(self.offsetX + margin/2, navigationMargin + margin/2, self.view.frame.size.width - margin, self.view.frame.size.height - navigationMargin - margin);
    
    SheetOfThemeOne *themeOneSheet = [[SheetOfThemeOne alloc]initWithFrame:writeSheetSize];
    themeOneSheet.delegate = self;
    [themeOneSheet settingUploadResume];
    [self.view addSubview:themeOneSheet];
}

-(void)onTouchUpInsideUploadButton {
    NSLog(@"업로드 버튼");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
