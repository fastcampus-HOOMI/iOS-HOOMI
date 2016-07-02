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

@end

/* 이곳은 이력서 목록을 누른 후, Detail 페이지가 나오는 곳 */
@implementation DetailResumeViewController

-(void)viewWillAppear:(BOOL)animated {
    self.pageNumber = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 페이지 갯수 받는 프로퍼티 만든 상태 */
    /* 그림 갯수 따라서 컨텐츠 사이즈 늘리고 sheetOfDetailResume을 반복하여 올려야 한다. */
    
}


-(void)creatScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*self.pageNumber, scrollView.frame.size.height);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
