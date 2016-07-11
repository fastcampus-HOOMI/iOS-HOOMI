//
//  WritePageViewController.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 6..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "WritePageViewController.h"
#import "SheetOfThemeOne.h"

@interface WritePageViewController () <SheetOfThemeOneDelegate, UIScrollViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic) CGFloat offsetWidth;
@property (nonatomic, strong) NSMutableArray *leftBarButtonArray;
@property (nonatomic, strong) NSMutableArray *rightBarButtonArray;

@property (nonatomic) NSInteger sheetCount;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) SheetOfThemeOne *themeOneSheet;

@end

@implementation WritePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textArray = [NSMutableArray new];
    
    /* bar 버튼 array 세팅 */
    self.rightBarButtonArray = [NSMutableArray arrayWithCapacity:1];
    
    /* 임시 form 데이터
     네트워크 연결 후에는 헤더 파일에 있는
     외부 프로퍼티를 통해 form 데이터 받아서 연결*/
    [self selectTheme:1];
    
    //[self selectTheme:self.formNumber];
    
    /* 스크롤뷰 생성 */
    [self creatScrollView];
    
    
    // 오른쪽 바버튼
    [self settingCustomButtonInNavigationBar:@"save.png" action:@selector(onTouchUpInsideSave:) isLeft:NO];
    [self settingCustomButtonInNavigationBar:@"pageAdd.png" action:@selector(onTouchUpInsidePageAddButton:) isLeft:NO];
}

   /**************************************/
  /*      페이지 구성 세팅 - 테마별 프레임     */
 /**************************************/

-(void)creatScrollView {
    self.scrollView.delegate = self;
    /* 페이지처럼 넘기게 하는 효과 -> 스토리보드 */
//    self.scrollView.pagingEnabled = YES;
//    [self.view addSubview:self.scrollView];
}


-(void)selectTheme:(NSInteger)formNumber {
    
    self.sheetCount = 1;
    
    if (formNumber == 1) {
        [self creatWriteSheet:self.sheetCount];
        //추후 테마 별로 프레임 세팅할 수 있도록 메소드 분리 - cheesing
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

-(void)creatWriteSheet:(NSInteger)pageNumber {
    
    //CGFloat navigationMargin = 10;
    CGFloat margin = 60;
    
    CGFloat writeSheetOriginWidth = self.view.frame.size.width - margin;
    
    CGFloat writeSheetOriginX = self.view.frame.size.width/2.0f - writeSheetOriginWidth/2.0f;
    
    CGFloat writeSheetOriginY = margin/2;
    CGFloat writeSheetOriginHeight = self.view.frame.size.height - margin - 30;
    
    CGRect writeSheetSize = CGRectMake(writeSheetOriginX, writeSheetOriginY, writeSheetOriginWidth, self.view.frame.size.height - margin - 30);
    
    self.themeOneSheet = [[SheetOfThemeOne alloc]initWithFrame:writeSheetSize];
    //self.themeOneSheet.backgroundColor = [UIColor redColor];
    self.themeOneSheet.delegate = self;
    [self.themeOneSheet settingUploadResume];
    
    CGRect cardFrame = CGRectMake(self.view.frame.size.width * (self.sheetCount - 1), 0, self.view.frame.size.width, self.view.frame.size.height);
    UIView *card = [[UIView alloc]initWithFrame:cardFrame];
    
    /* 텍스트뷰 array */
    [self.textArray addObject:self.themeOneSheet.textView];
    NSLog(@"%@ %@", self.textArray, self.themeOneSheet.textView);
    [card addSubview:self.themeOneSheet];
    [self.scrollView addSubview:card];
}

   /************************/
  /*    Button Action     */
 /************************/

-(IBAction)onTouchUpInsideSave:(id)sender {
    NSLog(@"저장 버튼");
    for (NSInteger i=0; i<=self.sheetCount-1; i++) {
        UITextView *textView = [self.textArray objectAtIndex:i];
        NSLog(@"%ld번째 페이지 글 : [%@] ", i+1, textView.text);
    }
    
    
}

-(IBAction)onTouchUpInsidePageAddButton:(id)sender {
    NSLog(@"page 추가 버튼");
    
    // 삭제 기능 추가
    //alert창 추가 --  cheesing
    
    self.sheetCount++;
    NSLog(@"page %ld 장", self.sheetCount);
    
    [self creatWriteSheet:self.sheetCount];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * self.sheetCount, self.scrollView.frame.size.height)];
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width * (self.sheetCount - 1), -self.navigationController.navigationBar.frame.size.height-24) animated:YES];
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
    
    /* 뷰에 선택 이미지 세팅 */
    self.themeOneSheet.imageView.image = eiditedImage;
    self.themeOneSheet.uploadButton.alpha = 0;
    
    self.themeOneSheet.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    /* 선택 이미지 데이터 array 추가 */
    [self.imageArray addObject:eiditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
