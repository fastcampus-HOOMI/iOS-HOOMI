//
//  JobSelectViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 7. 5..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "JobSelectViewController.h"

@interface JobSelectViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *jobList;
@property (nonatomic, strong) NSString *selectedJob;
@property (nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic) NSUserDefaults *defaults;

@end

@implementation JobSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    if(![self.defaults objectForKey:@""]) {
        
        
    }
    
    self.jobList = [NSArray arrayWithObjects:@"Photograper",@"Programmer", @"Editor", @"Writer",nil];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00]];
    // Do any additional setup after loading the view.
    
    [self createCustomButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.jobList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return [self.jobList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    self.selectedJob = [self.jobList objectAtIndex:row];
    NSLog(@"selectedJob : %@", self.selectedJob);
    
}

- (IBAction)userSelectJob:(id)sender {
    // 서버로 사용자 직업 정보 전송
    

    [self.defaults setObject:self.selectedJob forKey:@"userJob"];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)createCustomButton {
    
    NSInteger cornerRadius = 3;
    BOOL clipsToBounds = YES;
    CGFloat buttonTitleFont = 15.f;
    
    self.selectButton.layer.cornerRadius = cornerRadius;
    self.selectButton.clipsToBounds = clipsToBounds;
    [self.selectButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.selectButton setTitle:@"선택" forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectButton setFont:[UIFont boldSystemFontOfSize:buttonTitleFont]];
    
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
