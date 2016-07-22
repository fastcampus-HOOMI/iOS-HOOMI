//
//  DetialResumeViewController.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 1..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "DetailResumeViewController.h"
#import "SheetOfThemeOne.h"
#import "NetworkObject.h"
#import "Singletone.h"

@interface DetailResumeViewController () <UIScrollViewDelegate>

/* 화면 관련 */
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (nonatomic) CGFloat offsetX;

/* 페이지 변화 인지 */
@property (nonatomic) NSInteger beforePage;
@property (nonatomic) NSInteger currentPage;

/* 네트워크 관련 */
@property (nonatomic) Singletone *singleTone;
@property (nonatomic) NetworkObject *networkCenter;
@property (nonatomic) BOOL isFristLoad;

/* 데이터 로드 후, 세팅 관련 */
@property (nonatomic, strong) UIImage *imageAtCurrentPage;
@property (nonatomic, strong) NSString *textDataAtCurrentPage;

/* data download count */
@property (nonatomic) NSInteger downloadCount;

@end

/* 이곳은 이력서 목록을 누른 후, Detail 페이지가 나오는 곳 */
@implementation DetailResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //처음 페이지 (인덱스로)
    self.beforePage = 0;
    self.currentPage = 0;
    
    /* Indicator
     1) 데이터 들어올 때 활성화
     2) 데이터 세팅 완료 된 후, hidden
     --> 서버 데이터 교류 연결 후에 수정해야함 cheesing */
    
    [self creatIndicatorView];
    
    NSLog(@"🌵🌵addObserver🌵🌵");
    /* 노티 등록 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadCurrentPageInDetailResume) name:LoadDetailResumeSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadCurrentPageInDetailResume) name:LoadNextDetailResumeSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailCurrentPageInDetailResume) name:LoadDetailResumeFailNotification object:nil];
    
     NSLog(@"0🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵");
    
    // 네트워크를 통한 데이터 세팅
    [self loadDetailResumeData];
    
    NSLog(@"4🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵");
    
    /* 네비게이션 바 버튼 색깔 */
    self.navigationController.navigationBar.barTintColor = [self.singleTone colorName:Tuna];
    
    NSLog(@"last🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒🍒");
}

   /*************************************/
  /*   상세 페이지 세팅 - 스크롤뷰, 컨텐츠     */
 /*************************************/

#pragma mark - creat View & Sheet of DetailResume

-(void)creatScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    /* 페이지 갯수 받는 외부 프로퍼티 만든 상태 */
    /* 그림 갯수 따라서 컨텐츠 사이즈 늘리고 sheetOfDetailResume을 반복하여 올려야 한다. */
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.totalPageNumber, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    //self.scrollView.backgroundColor = [UIColor redColor];
    /* 페이지처럼 넘기게 하는 효과 */
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
}

-(void)creatContentsSheet:(NSInteger)pageNumber image:(UIImage *)image text:(NSString *)text {
    
    self.offsetX = self.view.frame.size.width;
    
    /* 한 장 세팅 */
    SheetOfThemeOne *themeOneSheet = [[SheetOfThemeOne alloc]initWithFrame:CGRectMake(self.offsetX * pageNumber, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //themeOneSheet.backgroundColor = [UIColor blueColor];
    themeOneSheet.alpha = 0.8;
    
    [themeOneSheet settingDetailResume:image text:text];
    [self.scrollView addSubview:themeOneSheet];
    
    [self showIndicatorView:NO];
    
    NSLog(@"🐙 %ld 번째 시트 생성 완료 : x좌표 - %lf 글자 - %@ 그림 -%@", pageNumber , self.offsetX * pageNumber, themeOneSheet.textView.text, themeOneSheet.imageView.image);
    
    self.offsetX += self.view.frame.size.width;
}


#pragma mark - Indicator

-(void)creatIndicatorView {
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center = self.view.center;
    [self.view addSubview:self.activityView];
    
}

-(void)showIndicatorView:(BOOL)activity {
    if (activity == YES) {
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
    }
    if (activity == NO) {
        self.activityView.hidden = YES;
        [self.activityView stopAnimating];
    }
    
}

    /************************/
   /*    Button Action     */
  /************************/

- (IBAction)onTouchUpInsideCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


    /*************************/
   /*       delegate        */
  /*************************/


#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /* 현재 위치 */
    //NSLog(@"현재 위치 %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    /* 현재 페이지 */
    CGFloat currentX = scrollView.contentOffset.x;
    self.currentPage = currentX / scrollView.frame.size.width;//현재페이지 인식
    NSLog(@"Current page : %ld (인덱스값)", self.currentPage);
    
    /* 페이지 변화 감지 (next만) */
    if ([self isChangePage]==YES)
    {
        if ([self stopDownloadContents] == YES) {
            NSLog(@"이미 로드했던 데이터 보는 중");
        }
        else {
            [self callNewDetailResumePageWithURL];
            self.beforePage = self.currentPage;
        }
    }
}

   /************************************/
  /*     network & load data 관련      */
 /************************************/

#pragma mark - network & load data

-(BOOL)isChangePage {
    if (self.beforePage == self.currentPage) {
        //NSLog(@"beforePage %ld // currentPage %ld", self.beforePage, self.currentPage);
        return NO;
    }
    else {
        // 변화했으니 비교할 페이지 변수 변경
        NSLog(@"beforePage %ld // currentPage %ld", self.beforePage, self.currentPage);
        return YES;
    }
    
}

-(BOOL)stopDownloadContents {
    /* 1. 이미 로드했던 이전 페이지 볼 때 (이전 페이지로 갈 때)
       2. 넘기는 중일 때
       3. 모든 페이지 로드했을 때 (다음 페이지로 넘어가도 다운로드 안되게) */
    if ((self.currentPage < self.beforePage) || (self.currentPage == self.beforePage) || (self.totalPageNumber == self.downloadCount)) {
        return YES;
    }
    /* 새로운 다음장 받을 때 */
    else {
        return NO;
    }
}

/* 데이터 불러오기
  1) 한 이력서 전체 페이지 한꺼번에 불러 오기  --> 2) 추후 lazy load로 변경 */
-(void)loadDetailResumeData {
    /* 최초 로드 체크 */
    self.isFristLoad = YES;
    
    NSLog(@"1🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵🌵");
    
    /* singleTone 초기화 */
    self.networkCenter = [NetworkObject requestInstance];
    self.singleTone = [Singletone requestInstance];
    
    /* network 객체 세팅 */
    [self callNewDetailResumePageWithURL];
    
}

/* 해당 페이지 URL로 이동 */
-(void)callNewDetailResumePageWithURL {
    
    [self showIndicatorView:YES];
    self.downloadCount += 1;
    
    /* 최초 로드시, hashID 전달 */
    if (self.isFristLoad == YES) {
        NSLog(@"2🌵🌵🌵self.isFristLoad == YES🌵🌵🌵");
        NSString *hashID = [[self.singleTone hashID] stringByAppendingString:@"/"];
        NSLog(@"🌵 hashID %@", hashID);
        [self.networkCenter requestDetailJobHistory:hashID];
        NSLog(@"🌵 3으로 가야함");
    }
    /* 그 외에는 URL로 이동 */
    if (self.isFristLoad == NO) {
        NSLog(@"2🌵🌵🌵self.isFristLoad == NO🌵🌵🌵");
        /* 지금은 next URL로만 data 부름*/
        [self.networkCenter requestDetailPageAfterMovePage:self.networkCenter.nextURL];
    }
}


/* 컨텐츠 다운로드 성공시 */
-(void)downLoadCurrentPageInDetailResume {
    NSLog(@"3🌵🌵🌵downLoadCurrentPageInDetailResume🌵🌵🌵");
    
    /* page, image, text */
    NSInteger totalPage = self.networkCenter.detailPageTotalCount;
    NSString *textData = [self.networkCenter.jobHistoryDetailContentsInfoDictionary objectForKey:@"content"];
    NSString *imageURL = [self.networkCenter.jobHistoryDetailContentsInfoDictionary objectForKey:@"image"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    NSLog(@"🌵 network 객체로 불러온 totalPage: %ld / imageURL : %@ / textData : %@", totalPage, imageURL, textData);
    
    /* 프로퍼티로 올림 -----  */
    [self addCurrentDataToProtery:totalPage imageURL:imageURL textData:textData];
    
    if (self.isFristLoad == YES) {
        [self creatScrollView];
        NSLog(@"🍞 총 쪽수 %ld", self.totalPageNumber);
    }
    
    [self creatContentsSheet:self.currentPage image:image text:textData];
    self.isFristLoad = NO;
}

/* 세팅 가능한 데이터로 가공 후, 프로퍼티로 올림 */
-(void)addCurrentDataToProtery:(NSInteger)totalPage imageURL:(NSString *)imageURL textData:(NSString *)textData {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage *image = [UIImage imageWithData:imageData];
    self.imageAtCurrentPage = image;
    self.totalPageNumber = totalPage;
    self.textDataAtCurrentPage = textData;
    
    NSLog(@"🤖 totalPageNumber - %ld, 🤖 imageAtCurrentPage - %@, 🤖textDataAtCurrentPage - %@", self.totalPageNumber, self.imageAtCurrentPage, self.textDataAtCurrentPage);
}

-(void)downloadFailCurrentPageInDetailResume {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
