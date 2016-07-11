//
//  MainTableViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 7. 5..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "MainTableViewController.h"
#import "ImageListTableViewCell.h"
#import "Singletone.h"
#import "NetworkObject.h"
#import "MyPageTableViewController.h"

@interface MainTableViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>

/*
 셀에 데이터를 표시하기 위한 임시데이터
 */
@property (nonatomic) NSMutableDictionary *imageData;
@property (nonatomic) NSArray *jobList;

@property (nonatomic, weak) UIPickerView *jobPicker; // 직군선택 Picker
@property (nonatomic, weak) NSString *selectedJob; // 선택된 직군

@property (nonatomic, strong) UIView *jobSelectCustomView;
@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic) NSUserDefaults *defaults;

@property (nonatomic) CGFloat animationDuration; // 애니메이션 지속 시간
@property (nonatomic) NSInteger margin; // 커스텀 뷰 margin

@property (nonatomic) Singletone *singleTone; // 싱글톤 객체
@property (nonatomic) NetworkObject *networkObject;
@property (nonatomic, weak) NSString *token;

@property (nonatomic) IBOutlet UIBarButtonItem *writeCareer;
@property (nonatomic) IBOutlet UIBarButtonItem *myPage;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.networkObject = [[NetworkObject alloc] init];
    self.token = [self.networkObject loadSessionValue];
    
    self.animationDuration = 0.7;
    self.margin = 60;
    
    // 싱글톤 객체 생성
    self.singleTone = [Singletone requestInstance];
    self.selectedJob = @"Photograper"; // Default Job
    
    /**********************/
    /* 테스트를 위한 임시데이터 */
    /**********************/
    // Photographer - 2, Programmer - 3, Editor - 4, Writer - 5
    self.jobList = [NSArray arrayWithObjects:@"Photograper",@"Programmer", @"Editor", @"Writer",nil];
    
    self.imageData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [self.imageData setObject:@"nature.jpg" forKey:@"image_01"];
    [self.imageData setObject:@"nature1.jpg" forKey:@"image_02"];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    /* 유저가 선택한 직군의 데이터가 없으면 직군 선택화면을 띄움 */
    if([self.defaults objectForKey:@"userJob"] == nil) {
        
        NSLog(@"직군선택 안함");
    
        // 뷰컨트롤러 뒷배경 블러처리
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        effectView.frame = self.view.frame;
        [self.view addSubview:effectView];
        self.effectView = effectView;
        
        [self selectJobList];
        
        // pickerView delegate, datasource
        self.jobPicker.delegate = self;
        self.jobPicker.dataSource = self;
        
        // 직군을 선택하는 뷰가 나오면 테이블뷰 스크롤 불가능
        [self.tableView setScrollEnabled:NO];
        
    } else {
        
        NSLog(@"직군선택 완료");
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(loadServerData:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:refreshControl];
        
        // 직군을 선택했으면 테이블뷰 스크롤 가능
        [self.tableView setScrollEnabled:YES];
        
    }
    
    /**********************/
    /* 네비게이션바 데이터 변경 */
    /**********************/
    self.title = @"HOOMI";
    [self.navigationController.navigationBar setBarTintColor:[self.singleTone colorName:Tuna]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)loadServerData:(UIRefreshControl *)refreshControl {
    
    NSLog(@"load server data");
    [refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMyPage:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"EK" bundle:nil];
    MyPageTableViewController *myPage = [storyBoard instantiateViewControllerWithIdentifier:@"MyPage"];
    
    [self presentViewController:myPage animated:YES completion:nil];
    
}

- (IBAction)writeCareerPage:(id)sender {
    
    NSLog(@"Move Write Career Page");
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.imageData count];
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Cell = @"Cell";
    
    ImageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    NSArray *allKey = [self.imageData allKeys];
    NSString *key = [allKey objectAtIndex:indexPath.row];
    
    cell.image.image = [UIImage imageNamed:[self.imageData objectForKey:key]];
    cell.label.text = key;
    [cell.label setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select cell");
}

#pragma mark - Select Job List Custom View
- (void)selectJobList {
    
    // 테이블뷰 스크롤 및 버튼 활성화
    [self scrollAndButtonEnable:NO];
    
    NSInteger cornerRadius = 3; // 버튼 모서리
    BOOL clipsToBounds = YES;
    
    // 직군선택화면을 현재뷰에서 커스텀뷰로 만들어서 표시
    UIView *jobSelectCustomView =[[UIView alloc] initWithFrame:CGRectMake(self.margin / 2, - self.margin * 5, self.view.frame.size.width - self.margin, self.margin * 5)];
    jobSelectCustomView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    jobSelectCustomView.backgroundColor = [self.singleTone colorName:Concrete];
    jobSelectCustomView.layer.borderWidth = 2.0f;
    
    // jobSelectCustomView에 PickerView 추가
    UIPickerView *jobPicker = [[UIPickerView alloc] init];
    [jobPicker setFrame:CGRectMake(0, 0, jobSelectCustomView.frame.size.width, jobSelectCustomView.frame.size.height - self.margin * 2)];
    [jobSelectCustomView addSubview:jobPicker];
    
    // 직군 선택 버튼
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton setFrame:CGRectMake(30, jobPicker.frame.size.height + 30, jobSelectCustomView.frame.size.width - 60, 45)];
    [selectButton addTarget:self action:@selector(selectUserJob) forControlEvents:UIControlEventTouchUpInside];
    selectButton.layer.cornerRadius = cornerRadius;
    selectButton.clipsToBounds = clipsToBounds;
    [selectButton setBackgroundColor:[self.singleTone colorName:Tuna]];
    [selectButton setTitle:@"등록" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jobSelectCustomView addSubview:selectButton];
    
    self.jobSelectCustomView = jobSelectCustomView;
    self.jobPicker = jobPicker;
    
    // 커스텀뷰 나오는 애니메이션
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self.jobSelectCustomView setCenter:CGPointMake(self.view.frame.size.width / 2,
                                                        self.view.frame.size.height / 2)];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.jobSelectCustomView];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)selectUserJob {
    
    [self.defaults setObject:self.selectedJob forKey:@"userJob"];
    NSLog(@"userJob : %@", self.selectedJob);
//    [self.networkObject requestSaveJob:self.selectedJob Token:self.token];
    
    // 커스텀뷰 사라지는 애니메이션
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.jobSelectCustomView.frame = CGRectMake(self.margin / 2, self.view.frame.size.height, self.view.frame.size.width - self.margin, self.margin * 5);
        [self.view addSubview:self.jobSelectCustomView];
    } completion:^(BOOL finished) {
        
        // 커스텀뷰가 사리지고 뷰에서 커스텀뷰 및 블러처리 효과 삭제
        [self.effectView removeFromSuperview];
        [self.jobSelectCustomView removeFromSuperview];
        
        // 테이블뷰 스크롤 및 버튼 활성화
        [self scrollAndButtonEnable:YES];
        
    }];
    
}

#pragma mark - Picker view data source

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

/**
 *  직군선택하는 커스텀뷰가 실행되면 테이블뷰 스크롤과 버튼을 비활성화시키는 메소드
 *
 *  @param enable 활성화 YES, 비활성화 NO
 */
- (void)scrollAndButtonEnable:(BOOL) enable {
    
    [self.tableView setScrollEnabled:enable];
    [self.writeCareer setEnabled:enable];
    [self.myPage setEnabled:enable];
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
