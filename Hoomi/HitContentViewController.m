//
//  HitContentViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 7. 13..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "HitContentViewController.h"

@interface HitContentViewController ()

@property (nonatomic, weak) IBOutlet UIView *hitView;

@end

@implementation HitContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.hitView setBackgroundColor:[UIColor blueColor]];
    [self createHitImageView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
