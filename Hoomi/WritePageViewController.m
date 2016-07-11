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
@property (nonatomic, strong) NSMutableArray *leftBarButtonArray;
@property (nonatomic, strong) NSMutableArray *rightBarButtonArray;

@end

@implementation WritePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* bar 버튼 array 세팅 */
    self.rightBarButtonArray = [NSMutableArray arrayWithCapacity:1];
    
    /* 임시 form 데이터
     네트워크 연결 후에는 헤더 파일에 있는
     외부 프로퍼티를 통해 form 데이터 받아서 연결*/
    [self selectTheme:1];
    
    //[self selectTheme:self.formNumber];
    
    // 오른쪽 바버튼
    [self settingCustomButtonInNavigationBar:@"save.png" action:@selector(onTouchUpInsideSave:) isLeft:NO];
    [self settingCustomButtonInNavigationBar:@"pageAdd.png" action:@selector(onTouchUpInsidePageAddButton:) isLeft:NO];
    
    
}

   /**************************************/
  /*      페이지 구성 세팅 - 테마별 프레임     */
 /**************************************/

-(void)selectTheme:(NSInteger)formNumber {
    
    if (formNumber == 1) {
        [self creatWriteSheet];
    }
    
}



/* 네비게이션 바에 저장, 카드 추가, 공개 비공개여부 설정으로 넘어가는 버튼 추가하기 (네이버 포스트 참고) -- cheesing */

-(void)settingCustomButtonInNavigationBar:(NSString *)buttonImageName action:(SEL)action isLeft:(BOOL)isLeft {
    
    UIImage *buttonImage = [UIImage imageNamed:buttonImageName];
    UIBarButtonItem *someButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:action];
    someButton.tintColor = [UIColor blackColor];
    
    if (isLeft == YES) {
        [self.leftBarButtonArray addObject:someButton];
        self.navigationItem.leftBarButtonItems = self.leftBarButtonArray;
    }
    else {
        [self.rightBarButtonArray addObject:someButton];
        self.navigationItem.rightBarButtonItems = self.rightBarButtonArray;
    }
    
}

-(void)creatWriteSheet {
    
    CGFloat navigationMargin = 40;
    CGFloat margin = 60;
    CGRect writeSheetSize = CGRectMake(self.offsetX + margin/2, navigationMargin + margin/2, self.view.frame.size.width - margin, self.view.frame.size.height - navigationMargin - margin);
    
    SheetOfThemeOne *themeOneSheet = [[SheetOfThemeOne alloc]initWithFrame:writeSheetSize];
    themeOneSheet.delegate = self;
    [themeOneSheet settingUploadResume];
    [self.view addSubview:themeOneSheet];
}

   /************************/
  /*    Button Action     */
 /************************/

-(void)onTouchUpInsideSave:(id)sender {
    NSLog(@"저장 버튼");
}

-(void)onTouchUpInsidePageAddButton:(id)sender {
    NSLog(@"page 추가 버튼");
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
