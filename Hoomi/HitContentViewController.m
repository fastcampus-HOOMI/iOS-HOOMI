//
//  HitContentViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 7. 13..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "HitContentViewController.h"
#import "Singletone.h"

@interface HitContentViewController ()

@property (nonatomic, weak) IBOutlet UIView *hitView;
@property (nonatomic) Singletone *singleTone;

@end

@implementation HitContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.singleTone = [Singletone requestInstance];
    /**********************/
    /* 네비게이션바 데이터 변경 */
    /**********************/
    self.title = @"HOOMI";
    [self.navigationController.navigationBar setBarTintColor:[self.singleTone colorName:Tuna]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self createAllView];
//    [self.hitView setBackgroundColor:[UIColor blueColor]];
//    [self createHitImageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createHitImageView {
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat hitViewWidth = self.view.frame.size.width / 2;
    CGFloat hitViewHeight = self.hitView.frame.size.height / 2;
    
    NSLog(@"size : %f", self.hitView.frame.size.height);
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, hitViewWidth, hitViewHeight)];
    
    NSLog(@"imageview1 height : %f", imageView1.frame.size.height);
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(hitViewWidth, y, hitViewWidth, hitViewHeight)];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(x, hitViewHeight, hitViewWidth, hitViewHeight)];
    
    NSLog(@"imageview3 height : %f", imageView3.frame.size.height);
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(hitViewWidth, hitViewHeight, hitViewWidth, hitViewHeight)];
    
    
    [imageView1 setBackgroundColor:[UIColor redColor]];
    [imageView2 setBackgroundColor:[UIColor orangeColor]];
    [imageView3 setBackgroundColor:[UIColor yellowColor]];
    [imageView4 setBackgroundColor:[UIColor greenColor]];
    
    [self.hitView addSubview:imageView1];
    [self.hitView addSubview:imageView2];
    [self.hitView addSubview:imageView3];
    [self.hitView addSubview:imageView4];
}

-(void) createAllView {
    
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    CGFloat navibarAndStatusBar = self.navigationController.navigationBar.frame.size.height + statusBarSize.height;
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    
    // Top View
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.view.frame.size.width, 2 * self.view.frame.size.height / 3)];
    [topView setBackgroundColor:[UIColor redColor]];
    
    // Toolbar In TopView
    UIView *topToolbarView = [[UIView alloc] initWithFrame:CGRectMake(x, y + navibarAndStatusBar, self.view.frame.size.width, 40)];
    [topToolbarView setBackgroundColor:[UIColor lightGrayColor]];
    [topView addSubview:topToolbarView];
    
    // ImageView In TopView
    UIView *topImageView = [[UIView alloc] initWithFrame:CGRectMake(x, y + navibarAndStatusBar + topToolbarView.frame.size.height, self.view.frame.size.width, topView.frame.size.height - topToolbarView.frame.size.height)];
    [topImageView setBackgroundColor:[UIColor blackColor]];
    
    NSLog(@"imageViewHeight : %f", topImageView.frame.size.height);
    
    CGFloat imageViewWidth = topImageView.frame.size.width / 2;
    CGFloat imageViewHeight = topImageView.frame.size.height / 2;
    
    // Four ImageView
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewWidth, imageViewHeight)];
    [imageView1 setBackgroundColor:[UIColor blueColor]];
    
    NSLog(@"imageView1Height :%f", imageView1.frame.size.height);
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth, y, imageViewWidth, imageViewHeight)];
    [imageView2 setBackgroundColor:[UIColor orangeColor]];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(x, imageViewHeight, imageViewWidth, imageViewHeight)];
    [imageView3 setBackgroundColor:[UIColor yellowColor]];
    
    NSLog(@"imageView3Height :%f", imageView3.frame.size.height);
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewWidth, imageViewHeight, imageViewWidth, imageViewHeight)];
    [imageView4 setBackgroundColor:[UIColor greenColor]];
    
    // Add Four ImageView In TopView
    [topImageView addSubview:imageView1];
    [topImageView addSubview:imageView2];
    [topImageView addSubview:imageView3];
    [topImageView addSubview:imageView4];
    
    [topView addSubview:topImageView];
    
    

    

    
    
    
    // Bottom View
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(x, 2 * self.view.frame.size.height / 3 + navibarAndStatusBar, self.view.frame.size.width, self.view.frame.size.height / 3)];
    [bottomView setBackgroundColor:[UIColor darkGrayColor]];
    
    // Toolbar In BottomView
    UIView *bottomToolbarView = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.view.frame.size.width, 40)];
    [bottomToolbarView setBackgroundColor:[UIColor lightGrayColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, bottomToolbarView.frame.size.height, self.view.frame.size.width, bottomView.frame.size.height - bottomToolbarView.frame.size.height) style:UITableViewStylePlain];
    [bottomToolbarView addSubview:tableView];
    [bottomView addSubview:bottomToolbarView];
    
    
    // Add View
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    
    
    
    
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
