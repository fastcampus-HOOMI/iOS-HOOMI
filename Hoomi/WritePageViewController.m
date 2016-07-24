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
#import "NetworkObject.h"
#import "Singletone.h"

@interface WritePageViewController () <SheetOfThemeOneDelegate, UIScrollViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>

/* 화면 세팅 관련 */
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) SheetOfThemeOne *currentSheet;
@property (nonatomic) CGFloat offsetWidth;//페이지 추가시 필요
@property (strong, nonatomic) IBOutlet UIBarButtonItem *writeCancelButton;//작성취소버튼 텍스트 설정 때문에 필요

/* 컨텐츠 세팅 관련 */
@property (nonatomic) NSInteger currentPage;//현재 페이지
@property (nonatomic) NSInteger totalPage;//총 페이지

/* 데이터 보관 */
@property (nonatomic, strong) NSMutableArray *contentsArray;
@property (nonatomic, strong) NSMutableArray *dataArrayInStateOfArrangement;

/* toolbar 페이지 알림 설정 */
@property (strong, nonatomic) IBOutlet UIBarButtonItem *totalPageNumeberItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *currentPageNumberItem;

/* NetworkObject 관련 */
@property (nonatomic) Singletone *singleTone;
@property (nonatomic) NetworkObject *networkCenter;
@property (nonatomic) NSInteger uploadSuccessCount;
@property (nonatomic) NSInteger failUploadCount;

/* loading indicator 관련 */
@property (nonatomic, retain) UIActivityIndicatorView * activityView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;

@end

@implementation WritePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successCreatJobHistory) name:CreatJobHistorySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successUploadExperience) name:CreatExperienceSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failUploadExperience) name:CreatExperienceFailNotification object:nil];
    
    self.formThemeNumber = 1;// ------------ 추후form테마 번호 받는걸로 변경
    
    /* contentsArray 세팅 */
    self.contentsArray = [NSMutableArray arrayWithCapacity:1];
    
    /* 스크롤뷰 생성 */
    [self creatScrollView];
    
    /* 작성 취소 버튼 폰트 및 글자 크기 세팅 */
    [self settingWriteCancelButtonFont];
    
    /* 초기 페이지 세팅 */
    self.totalPageNumeberItem.title = [NSString stringWithFormat:@"%d", 1];
    self.currentPageNumberItem.title = [NSString stringWithFormat:@"%d", 1];
    
    /* 임시 form 데이터
     ->     네트워크 연결 후에는 헤더 파일에 있는
     외부 프로퍼티를 통해 form 데이터 받아서 연결 cheesing */
    [self selectWriteSheetByTheme:self.formThemeNumber];
    
    NSLog(@"첫 생성 total page count - %ld", self.totalPage);
}

-(void)viewDidLayoutSubviews {
    /* 안내 애니메이션 */
//    [self startNoticeAnimation];
}


   /**************************************/
  /*      페이지 구성 세팅 - 테마별 프레임     */
 /**************************************/

-(void)creatScrollView {
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.delegate = self;
    [self settingTapGestureRecognizerOnScrollView];
}

-(void)selectWriteSheetByTheme:(NSInteger)formNumber {
    
    self.totalPage += 1;
    NSLog(@"총 페이지 ------ %ld", self.totalPage);
    
    if (formNumber == 1) {
        NSLog(@"테마1 입니다.");
        [self creatThemeOneSheet:self.totalPage];
    }
    if (formNumber == 2) {
        //추후 테마 별로 프레임 세팅할 수 있도록 메소드 분리 - cheesing
    }
//    else {
//        NSLog(@"준비된 테마가 아닙니다.");
//    }
}

-(void)creatThemeOneSheet:(NSInteger)totalPage {
    /* 시트 올려놓을 카드 생성, frame 세팅 */
    CGFloat margin = 50;
    
    CGFloat cardOriginWidth = self.view.frame.size.width;
    CGFloat cardOriginX = (self.view.frame.size.width) * (totalPage - 1);
    CGFloat cardOriginY = margin/2 - 10;
    CGFloat cardOriginHeight = self.view.frame.size.height - margin * 2;
    CGRect cardFrame = CGRectMake(cardOriginX, cardOriginY, cardOriginWidth, cardOriginHeight);
    UIView *card = [[UIView alloc]initWithFrame:cardFrame];
    //card.backgroundColor = [UIColor redColor];
    //card.alpha = 0.5;
    
    /* 시트 frame 세팅 */
    CGFloat writeSheetOriginWidth = cardOriginWidth - margin;
    CGFloat writeSheetOriginX = cardOriginWidth/2.0f - writeSheetOriginWidth/2.0f;
    CGFloat writeSheetOriginY = 0;
    CGFloat writeSheetOriginHeight = cardOriginHeight;
    CGRect writeSheetFrame = CGRectMake(writeSheetOriginX, writeSheetOriginY, writeSheetOriginWidth, writeSheetOriginHeight);
    
    /* 내부 시트 생성 */
    SheetOfThemeOne *themeOneSheet = [[SheetOfThemeOne alloc]initWithFrame:writeSheetFrame];
    //self.themeOneSheet.backgroundColor = [UIColor blueColor];
    themeOneSheet.delegate = self;
    [themeOneSheet settingUploadResume];
    themeOneSheet.layer.cornerRadius = 10.0;//시트 카드모양으로
    themeOneSheet.layer.borderColor = [UIColor lightGrayColor].CGColor;
    themeOneSheet.layer.borderWidth = 2.5;
    [card addSubview:themeOneSheet];//시트는 카드 위에 addSubView
    
    /* 시트 생성시, 컨텐츠 array에 추가 */
    [self.contentsArray addObject:themeOneSheet];
    
    /* 스크롤뷰 위에 card addSubView */
    [self.scrollView addSubview:card];
}

   /************************/
  /*      화면 효과 관련     */
 /************************/

#pragma mark - UI effect

/* 작성취소 버튼 폰트/글자크기 세팅 */
-(void)settingWriteCancelButtonFont {
    [self.writeCancelButton setTitleTextAttributes:@{
                                                     NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:15.0]} forState:UIControlStateNormal];
}

/* 시작 시 안내 애니메이션 */
-(void)startNoticeAnimation {
    
    CGFloat rootViewWith = self.view.frame.size.width;
    CGFloat rootViewHeight = self.view.frame.size.height;
    
    UIImageView *noticeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rootViewWith, rootViewHeight)];
    [noticeImage setImage:[UIImage imageNamed:@"notice"]];
    [noticeImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.scrollView addSubview:noticeImage];
    
    [UIView animateWithDuration:3.0// 3.0초 동안
                     animations:^{noticeImage.alpha = 0.0;} // 애니메이션 투명도 0.0으로 만들기
                     completion:^(BOOL finished){
                         [noticeImage removeFromSuperview];}];
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
    
    if ([self isContentsNil] == YES) {
        [self creatAlert:@"경고" message:@"컨텐츠를 빠짐없이 기입해주세요" haveCancelButton:NO defaultHandler:nil];
    }
    else {
        [self creatAlert:@"확인" message:@"저장하시겠습니까?" haveCancelButton:YES defaultHandler:^ {
            
            [self creatloadingAlert];
            [self dataArrangement];
            [self creatJobHistoryForUpload];
        }];
    }
}

-(IBAction)onTouchUpInsidePageAddButton:(id)sender {
    NSLog(@"page 추가 버튼");
    
    [self selectWriteSheetByTheme:self.formThemeNumber];
    
    /* 스크롤뷰 컨텐츠 사이즈 증가 */
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * (self.totalPage), self.scrollView.frame.size.height)];
    /* 스크롤 위치 이동 */
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width * (self.totalPage - 1), 0) animated:YES];
    
    /* 맨 뒷 페이지를 기준으로 
       컨텐츠 사이즈 증가는 맨 뒷페이지 가장 뒷부분까지를 (페이지 전체니까)
       스크롤 위치 이동은 맨 뒷페이지의 가장 앞부분으로 가야한다. (x 좌표) */
}

/* upload button delegate */
-(void)onTouchUpInsideUploadButton {
    NSLog(@"업로드 버튼");
    [self showActionSheet];
}

/* close 기능 */
- (IBAction)onTouchUpInsideCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

    /****************************/
   /*    화면에 사진 업로드 기능     */
  /*     - 액션시트, 이미지피커    */
 /****************************/

#pragma mark - ActionSheet, UIImagePickerController

-(void)showActionSheet {
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
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
        [self creatAlert:@"알림" message:@"이용할 수 없는 파일 형식입니다." haveCancelButton:NO defaultHandler:nil];
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

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //picker를 모달로 내려준다.
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"선택");
    
    UIImage *eiditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    /* 프로퍼티로 세팅된 해당 페이지 객체에 이미지 세팅 */
    self.currentSheet = [self.contentsArray objectAtIndex:self.currentPage];
    [self.currentSheet.imageView setImage:eiditedImage];
    self.currentSheet.uploadButton.alpha = 0;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

   /*************************/
  /*       delegate        */
 /*************************/

#pragma mark - scrollView delegate

/* 스크롤 위치 (페이지) 추적 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /* 현재 위치 */
    //NSLog(@"현재 위치 %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    /* 현재 페이지 */
    CGFloat currentX = scrollView.contentOffset.x;
    self.currentPage = currentX / scrollView.frame.size.width;
    
    //NSLog(@"currentX : %f, scrollViewWidth : %f", currentX, scrollView.frame.size.width);
    NSLog(@"Current page : %ld (인덱스값)", self.currentPage);
    
    /* 현재 위치 컨텐츠 프로퍼티 세팅 */
    [self selectCurrentContents];
    
    /* toolbar 페이지 텍스트 세팅 */
    [self changePageNotice];
    
}

-(void)changePageNotice {
    self.currentPageNumberItem.title = [NSString stringWithFormat:@"%ld", self.currentPage+1];
    self.totalPageNumeberItem.title = [NSString stringWithFormat:@"%ld", self.totalPage];
}

   /************************************/
  /*       배열 객체 프로퍼티로 활용        */
 /************************************/
     
#pragma mark - select contents in contentsArray

/* 현재 페이지의 컨텐츠를 배열에서 꺼내오기 -> 프로퍼티로 세팅 */
-(void)selectCurrentContents {
    self.currentSheet = [self.contentsArray objectAtIndex:self.currentPage];
}

/* 저장 컨텐츠 nil 확인 */
-(BOOL)isContentsNil{
    // 저장 데이터 확인
    for (NSInteger i=0; i<=self.totalPage-1; i++) {
        
        SheetOfThemeOne *content = [self.contentsArray objectAtIndex:i];
        UIImage *image = content.imageView.image;
        NSString *text = content.textView.text;
        NSLog(@"%ld번째 페이지 < 이미지: [%@] / 글 : [%@] > ", i+1, image ,text);
        
        if ((nil == image) || (0 == text.length)) {
            return YES;
        }
    }
    NSLog(@"컨텐츠가 빠짐없이 기입되어있습니다. 저장해도 좋습니다.");
    return NO;
}


  /***************************/
 /*         alert           */
/***************************/

-(void)creatAlert:(NSString *)title message:(NSString *) message haveCancelButton:(BOOL)haveCancelButton defaultHandler:(void (^)(void))handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //선언하면서 정의한 블럭함수로 실행
        if (handler != nil) {
            handler();
        }
    }];
    [alert addAction:okButton];
    
    if (haveCancelButton == YES) {
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelButton];
    }
    [self presentViewController:alert animated:YES completion:nil];
}



    /*********************************/
   /*     network & upload 관련      */
  /*********************************/


-(void)dataArrangement {
    self.dataArrayInStateOfArrangement = [[NSMutableArray alloc]initWithCapacity:1];
    
    for (NSInteger count = 0; count < self.totalPage; count++) {
        
        NSMutableDictionary *sheetData = [NSMutableDictionary new];
        
        SheetOfThemeOne *sheet = [self.contentsArray objectAtIndex:count];
        [sheetData setObject:sheet.imageView.image forKey:@"image"];
        [sheetData setObject:sheet.textView.text forKey:@"text"];
        [sheetData setObject:[@(count+1) stringValue] forKey:@"page"];
        
        [self.dataArrayInStateOfArrangement addObject:sheetData];
    }
    
    NSLog(@"%@", self.dataArrayInStateOfArrangement);
}

// -- 애니메이션 넣어야 할듯? 로딩 되게
-(void)creatloadingAlert {
    
    /* 뒤에 터치 못하게 막기 ----------- cheesing */
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.6;
    [self.scrollView addSubview:backgroundView];
    
    CGFloat loadingViewWidth = 200;
    CGFloat centerInCurrentPageX = (self.scrollView.frame.size.width * (self.currentPage + 1)) - (self.scrollView.frame.size.width / 2) - 200/2;
    CGFloat centerInCurrentPageY = (self.scrollView.frame.size.height / 2) - 170/2;
    
    /* indecator */
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(centerInCurrentPageX, centerInCurrentPageY, loadingViewWidth, 170)];
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.cornerRadius = 10.0;
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.frame = CGRectMake(65, 40, self.activityView.bounds.size.width, self.activityView.bounds.size.height);
    [self.loadingView addSubview:self.activityView];
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.adjustsFontSizeToFitWidth = YES;
    self.loadingLabel.textAlignment = UITextAlignmentCenter;
    self.loadingLabel.text = @"Loading...";//바뀔 부분
    [self.loadingView addSubview:self.loadingLabel];
    
    [backgroundView addSubview:self.loadingView];
    [self.activityView startAnimating];
    
}

-(void)creatJobHistoryForUpload {
    self.networkCenter = [[NetworkObject alloc]init];
    NSLog(@"1 🌞 생성되어야할 formNumber는 %@입니다.", [NSString stringWithFormat:@"%ld",self.formThemeNumber]);
    
    /* 완료 후, successCreatJobHistory 불려짐 */
    [self.networkCenter creatJobHistoryForContentsUpload:[NSString stringWithFormat:@"%ld",self.formThemeNumber]];
    NSLog(@"2 🌞 creatJobHistoryForUpload");
}

/* JobHistory에서 hash값을 받아오면 */
-(void)successCreatJobHistory {
    
    NSLog(@"3 🌞 successCreatJobHistory");
    NSString *hashID = [self.networkCenter hashID];
    NSLog(@"4 🌞 hashID - %@", hashID);
    
    for (NSInteger count = 0; count <= self.totalPage - 1; count++) {
        
        NSMutableDictionary *sheetData = [self.dataArrayInStateOfArrangement objectAtIndex:count];
        UIImage *image = [sheetData objectForKey:@"image"];
        NSString *text = [sheetData objectForKey:@"text"];
        NSString *page = [sheetData objectForKey:@"page"];
        
        NSLog(@"4 🌞 image - %@, text - %@, page - %@", image, text, page);
        
        // call successUploadExperience
        [self.networkCenter uploadExperienceForMutipartWithAFNetwork:hashID image:image content:text page:page];
        
    }
}

-(void)successUploadExperience {
    
    // 업로드 성공시 , 카운트 +
    self.uploadSuccessCount += 1;
    NSLog(@"🌞 %ld개 파일 업로드 성공", self.uploadSuccessCount);
    
    NSString *loadingText = [[@(self.uploadSuccessCount / self.totalPage) stringValue] stringByAppendingString:@"%..."];
    self.loadingLabel.text = loadingText;
    
    // 모두 성공 시, 안내 후, 창 닫기
    if (self.uploadSuccessCount == self.totalPage) {
        [self creatAlert:@"알림" message:@"모든 업로드가 완료되었습니다!" haveCancelButton:NO defaultHandler:^{
            //close 기능
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }

}

-(void)failUploadExperience {

    NSLog(@"👼🏻 failUploadExperience");
    
//    self.failUploadCount += 1;
//    
//    NSMutableDictionary *sheetData = [self.dataArrayInStateOfArrangement objectAtIndex:count];
//    UIImage *image = [sheetData objectForKey:@"image"];
//    NSString *text = [sheetData objectForKey:@"text"];
//    NSString *page = [sheetData objectForKey:@"page"];
//    
//    if (self.failUploadCount < 20) {
//        
//        
//        [self.networkCenter uploadExperienceForMutipartWithAFNetwork:hashID image:<#(UIImage *)#> content:<#(NSString *)#> page:page];
//    }
//    else {
//        NSLog(@"업로드 실패 넘나 많이 함. 강제 종료.");
//    }
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