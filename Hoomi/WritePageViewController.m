//
//  WritePageViewController.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 6..
//  Copyright © 2016년 Jyo. All rights reserved.
//
#import "QuartzCore/QuartzCore.h"
#import "WritePageViewController.h"
#import "SheetOfThemeOne.h"

@interface WritePageViewController () <SheetOfThemeOneDelegate, UIScrollViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic) CGFloat offsetWidth;
@property (nonatomic, strong) NSMutableArray *leftBarButtonArray;
@property (nonatomic, strong) NSMutableArray *rightBarButtonArray;

@property (nonatomic) NSInteger sheetCount;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) SheetOfThemeOne *currentSheet;

@property (nonatomic) NSInteger currentPage;

@end

@implementation WritePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* bar 버튼 array 세팅 */
    self.rightBarButtonArray = [NSMutableArray arrayWithCapacity:1];
    
    /* contentsArray 세팅 */
    self.contentsArray = [NSMutableArray arrayWithCapacity:1];
    
    /* 임시 form 데이터
     네트워크 연결 후에는 헤더 파일에 있는
     외부 프로퍼티를 통해 form 데이터 받아서 연결*/
    [self selectTheme:1];
    
    //[self selectTheme:self.formNumber];
    
    /* 스크롤뷰 생성 */
    [self creatScrollView];
    
}

   /**************************************/
  /*      페이지 구성 세팅 - 테마별 프레임     */
 /**************************************/

-(void)creatScrollView {
    self.scrollView.delegate = self;
    [self settingTapGestureRecognizerOnScrollView];
}

-(void)selectTheme:(NSInteger)formNumber {
    
    self.sheetCount = 1;
    
    if (formNumber == 1) {
        [self creatWriteSheet:self.sheetCount];
        //추후 테마 별로 프레임 세팅할 수 있도록 메소드 분리 - cheesing
    }
}


-(void)creatWriteSheet:(NSInteger)pageNumber {
    
    /* 시트 올려놓을 카드 생성, frame 세팅 */
    CGFloat margin = 50;
    
    CGFloat cardOriginWidth = self.view.frame.size.width;
    CGFloat cardOriginX = (self.view.frame.size.width) * (self.sheetCount - 1);
    CGFloat cardOriginY = margin/2;
    CGFloat cardOriginHeight = self.view.frame.size.height - margin * 2;
    CGRect cardFrame = CGRectMake(cardOriginX, cardOriginY, cardOriginWidth, cardOriginHeight);
    UIView *card = [[UIView alloc]initWithFrame:cardFrame];
    //card.backgroundColor = [UIColor redColor];
    
    /* 시트 크기 세팅 */
    CGFloat writeSheetOriginWidth = cardOriginWidth - margin;
    CGFloat writeSheetOriginX = cardOriginWidth/2.0f - writeSheetOriginWidth/2.0f;
    CGFloat writeSheetOriginY = margin/2;
    CGFloat writeSheetOriginHeight = cardOriginHeight;
    CGRect writeSheetFrame = CGRectMake(writeSheetOriginX, writeSheetOriginY, writeSheetOriginWidth, writeSheetOriginHeight);
    
    /*
    self.themeOneSheet = [[SheetOfThemeOne alloc]initWithFrame:writeSheetFrame];
    //self.themeOneSheet.backgroundColor = [UIColor blueColor];
    self.themeOneSheet.delegate = self;
    [self.themeOneSheet settingUploadResume];
    self.themeOneSheet.layer.cornerRadius = 10.0;//시트 카드모양으로
    self.themeOneSheet.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.themeOneSheet.layer.borderWidth = 2.0;
      시트 생성 */

    /*
    [self.contentsArray addObject:self.themeOneSheet];
    [card addSubview:self.themeOneSheet];//시트는 카드 위에
    */
    
    
    //--------------------------- 변경
    /* 내부 시트 생성 */
    SheetOfThemeOne *themeOneSheet = [[SheetOfThemeOne alloc]initWithFrame:writeSheetFrame];
    //self.themeOneSheet.backgroundColor = [UIColor blueColor];
    themeOneSheet.delegate = self;
    [themeOneSheet settingUploadResume];
    themeOneSheet.layer.cornerRadius = 10.0;//시트 카드모양으로
    themeOneSheet.layer.borderColor = [UIColor lightGrayColor].CGColor;
    themeOneSheet.layer.borderWidth = 2.0;
    
    /*  */
    [self.contentsArray addObject:themeOneSheet];
    [card addSubview:themeOneSheet];//시트는 카드 위에
    
    /* 스크롤뷰 위에 card addSubView */
    [self.scrollView addSubview:card];
}


   /************************/
  /*   Tap action 관련     */
 /************************/

#pragma mark - TapGestureRecognizer

-(void) settingTapGestureRecognizerOnScrollView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
}

-(void) dismissKeyboard {
    [self.currentSheet.textView endEditing:YES];
}


   /************************/
  /*    Button Action     */
 /************************/

#pragma mark - Button Action

-(IBAction)onTouchUpInsideSave:(id)sender {
    NSLog(@"저장 버튼");
    for (NSInteger i=0; i<=self.sheetCount-1; i++) {
        SheetOfThemeOne *view = [self.contentsArray objectAtIndex:i];
        NSString *text = view.textView.text;
        NSLog(@"%ld번째 페이지 글 : [%@] ", i+1, text);
    }
}

-(IBAction)onTouchUpInsidePageAddButton:(id)sender {
    NSLog(@"page 추가 버튼");
    
    // 삭제 기능 추가 (추후)
    
    //alert창 추가 --  cheesing
    
    self.sheetCount++;
    NSLog(@"page %ld 장", self.sheetCount);
    
    [self creatWriteSheet:self.sheetCount];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * self.sheetCount, self.scrollView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width * (self.sheetCount - 1), 0) animated:YES];
}

/* upload button delegate */
-(void)onTouchUpInsideUploadButton {
    NSLog(@"업로드 버튼");
    [self showActionSheet];
}


/************************/
/*     사진 업로드 기능     */
/*  - 액션시트, 이미지피커   */
/************************/

#pragma mark - ActionSheet, UIImagePickerController

-(void)showActionSheet
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"라이브러리" message:@"사진을 어디서 가져올까요?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *carmera = [UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /* 이미지 피커 */
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        NSLog(@"카메라 선택");
    }];
    
    UIAlertAction *abum = [UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /* 이미지 피커 */
        [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        NSLog(@"앨범 선택");
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"취소");
    }];
    
    [alert addAction:carmera];
    [alert addAction:abum];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


/* 이미지 피커 관련 소스 함수 */
-(void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    /* 소스타입 사용 가능한 상황인지 ex 시뮬레이터는 카메라 안됨 */
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] == NO) {
        // 사용자에겐 allert 띄워주기
        // 난 로그를 볼 거다
        NSLog(@"이 소스는 못쓰낟");
    }
    else {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        
        [pickerController setSourceType:sourceType];
        [pickerController setDelegate:self];
        
        // picker를 통한 이미지 수정 허용
        pickerController.allowsEditing = YES;
        
        //picker를 모달로 보여준다.
        [self presentViewController:pickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePicker Controller Delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //picker를 모달로 내려준다.
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"선택");
    
    UIImage *eiditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    /* 선택 이미지 컨텐츠 array에 세팅 ----------  세팅 불규칙 버그 수정 cheesing*/
    /*
    SheetOfThemeOne *currentContents = [self.contentsArray objectAtIndex:self.currentPage];
    [currentContents.imageView setImage:eiditedImage];
    currentContents.uploadButton.alpha = 0;
    currentContents.imageView.contentMode = UIViewContentModeScaleAspectFit;
     */
    /* 선택된 이미지 */
    //[self.contentsArray insertObject:currentContents atIndex:self.currentPage];
    
    self.currentSheet = [self.contentsArray objectAtIndex:self.currentPage];
    [self.currentSheet.imageView setImage:eiditedImage];
    self.currentSheet.uploadButton.alpha = 0;
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

   /*************************/
  /*       delegate        */
 /*************************/


#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /* 현재 위치 */
    NSLog(@"현재 위치 %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    /* 현재 페이지 */
    CGFloat currentX = scrollView.contentOffset.x;
    self.currentPage = currentX / scrollView.frame.size.width;
    
    NSLog(@"Current page : %ld (인덱스값)", self.currentPage);
    
    /* 현재 위치 컨텐츠 프로퍼티 세팅 */
    [self selectCurrentContents];
    
}

   /************************************/
  /*       배열 객체 프로퍼티로 활용         */
 /*************************************/

/* 현재 페이지의 컨텐츠를 배열에서 꺼내오기 -> 프로퍼티로 세팅 */
-(void)selectCurrentContents {
    self.currentSheet = [self.contentsArray objectAtIndex:self.currentPage];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation 관련
 
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
 
 */

@end
