//
//  WritePageViewController.m
//  Hoomi
//
//  Created by 배지영 on 2016. 7. 6..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "WritePageViewController.h"
#import "WritePageWithFromOne.h"

@interface WritePageViewController ()

@end

@implementation WritePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 임시 form 데이터
       네트워크 연결 후에는 헤더 파일에 있는
       외부 프로퍼티를 통해 form 데이터 받아서 연결*/
    [self seletFromView:1];
    
}

-(void)seletFromView:(NSInteger)formNumber {
    
    if (formNumber == 1) {
        [self creatWriteWithFormOne];
    }
    
}

-(void)creatWriteWithFormOne {
    
    WritePageWithFromOne *fromOne = [[WritePageWithFromOne alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
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
