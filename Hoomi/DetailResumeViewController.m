//
//  DetialResumeViewController.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 1..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "DetailResumeViewController.h"
#import "SheetOfThemeOne.h"

@interface DetailResumeViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@property (nonatomic) CGFloat offsetX;

@end

/* 이곳은 이력서 목록을 누른 후, Detail 페이지가 나오는 곳 */
@implementation DetailResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Indicator
       1) 데이터 들어올 때 활성화
       2) 데이터 세팅 완료 된 후, hidden
        --> 서버 데이터 교류 연결 후에 수정해야함 cheesing */
   
    /* Indicator 세팅 */
    [self creatIndicatorView];
    
    /* hiddenIndicator 1 */
    [self showIndicatorView:NO];//추후 수정
    
    /* 임시 데이터 및 공동 프레임 수치*/
    [self settingTempData];//추후 삭제
    [self settingFrameSize];
    
    /* Page Setting */
    [self settingSheetOfDetailPage];
    
    /* hiddenIndicator - 2 */
    [self showIndicatorView:YES];//추후 수정
    
}

/* 네비게이션 탭했을 때 숨기는 것 --  cheesing */

   /********************************/
  /*   임시 데이터 및 공동 프레임 수치   */
 /********************************/

-(void)settingTempData {
    // 임시 이미지 파일 이름 리스트
    self.imageNameList = @[@"1.jpg", @"2.jpg", @"3.jpg"];
    
    // 임시 텍스트 파일 리스트
    self.textList = @[@"오랫동안 글을 쓰지 못했던 때가 있었다. 이 땅의 날씨가 나빴고 나는 그 날씨를 견디지 못했다.", @"그때도 거리는 있었고 자동차는 지나갔다. 가을에는 퇴근길에 커피를 마셨으며 눈이 오는 종로에서 친구를 만나기도 했다. 그러나 시를 쓰지 못 했다.", @"내가 하고 싶었던 말들은 형식을 찾지 못한 채 대부분 공중에 흩어졌다. 적어도 내게 있어 글을 쓰지 못하는 무력감이 육체에 가장 큰 적이 될 수도 있다는 사실을 나는 그 때 알았다."];
    // 임시 페이지 갯 수
    self.totalPageNumber = 3;
}

-(void)settingFrameSize {
    
    self.offsetX = 0;
    
}


   /*************************************/
  /*   상세 페이지 세팅 - 스크롤뷰, 컨텐츠     */
 /*************************************/

#pragma mark - Sheet of DetailResume

-(void)settingSheetOfDetailPage {
    
    [self creatScrollView];
    [self customButtonInNavigationBar];
    
    
    /* 지금은 for문으로 한 꺼번에 creat
     -> scrollView delegate 를 통해 page 체크 후에 다운로드
     
     나중에는 한 페이지 넘길 때마다 세팅 해야한다.
     --> laze load 이슈 - cheesing */
    
    for (NSInteger pageNumber = 1; pageNumber <= self.totalPageNumber; pageNumber++) {
        
        [self creatContentsSheet:pageNumber];
        self.offsetX += self.view.frame.size.width;
        
    }
}

#pragma mark - setting frame & contents

-(void)creatScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    /* 페이지 갯수 받는 외부 프로퍼티 만든 상태 */
    /* 그림 갯수 따라서 컨텐츠 사이즈 늘리고 sheetOfDetailResume을 반복하여 올려야 한다. */
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*self.totalPageNumber, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    /* 페이지처럼 넘기게 하는 효과 */
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
}

-(void)customButtonInNavigationBar {
    
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pulsAction:)];
    
}


-(void)creatContentsSheet:(NSInteger)pageNumber {
    /* 한 장 세팅 */
    SheetOfThemeOne *themeOneSheet = [[SheetOfThemeOne alloc]initWithFrame:CGRectMake(self.offsetX, 0, self.view.frame.size.width, self.view.frame.size.height)];
    /* 이미지와 텍스트 세팅
     - 현재는 배열로 세팅을 시켰지만, 나중에는 서버 데이터를 불러오는 걸로 세팅해야함 cheesing -> downLoadDeatilContents */
    NSString *imageName = [self.imageNameList objectAtIndex:pageNumber-1];
    NSString *text = [self.textList objectAtIndex:pageNumber-1];
    [themeOneSheet settingDetailResume:imageName text:text];
    [self.scrollView addSubview:themeOneSheet];
}


#pragma mark - Indicator

-(void)creatIndicatorView {
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = self.view.center;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    
}

-(void)showIndicatorView:(BOOL)activity {
    if (activity == YES) {
        self.activityView.hidden = YES;
    }
    if (activity == NO) {
        self.activityView.hidden = NO;
    }
    
}

    /************************/
   /*    Button Action     */
  /************************/

-(void)pulsAction:(id)sender  {
    
    NSLog(@"+ 버튼 클릭");
}


    /******************************/
   /*        컨텐츠 로드 관련        */
  /******************************/


#pragma mark - lazyLoad

-(void)lazyLoadDeatilContents {
    
    // 페이지마다 로드 되도록 하는 작업
    
}


    /*************************/
   /*       delegate        */
  /*************************/


#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /* 현재 위치 */
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    /* 현재 페이지 */
    CGFloat currentX = scrollView.contentOffset.x;
    NSInteger currentPage = currentX / scrollView.frame.size.width;
    
    NSLog(@"Current page : %ld (인덱스값)", currentPage);
    
    /* 한 페이지 당 로드되도록 하는 이슈 해당 메소드 이용할 것
       - cheesing */
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
