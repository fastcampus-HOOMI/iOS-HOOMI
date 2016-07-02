//
//  DetialResumeViewController.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 1..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "DetailResumeViewController.h"
#import "SheetOfDetailResume.h"

@interface DetailResumeViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

/* 이곳은 이력서 목록을 누른 후, Detail 페이지가 나오는 곳 */
@implementation DetailResumeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 임시 페이지 갯 수
    self.pageNumber = 3;
    
    [self creatScrollView];
    [self creatSheetOfDetailPage];
}


-(void)creatScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    /* 페이지 갯수 받는 외부 프로퍼티 만든 상태 */
    /* 그림 갯수 따라서 컨텐츠 사이즈 늘리고 sheetOfDetailResume을 반복하여 올려야 한다. */
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*self.pageNumber, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    SheetOfDetailResume *DetailPage = [[SheetOfDetailResume alloc]initWithContents];
    [DetailPage.imageView setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:DetailPage];
    
}

-(void)creatSheetOfDetailPage {
    
    
    
    
    /*
    for (NSInteger i=1; i<=self.pageNumber; i++) {
        
    }
     */
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
