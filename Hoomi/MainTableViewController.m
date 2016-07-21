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
#import "SignInViewController.h"
#import "WritePageViewController.h"
#import "DetailResumeViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainTableViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>

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

@property (nonatomic) NSMutableArray *contentDataArray;
@property (nonatomic) NSMutableArray *imageDataArray;
@property (nonatomic) NSMutableArray *hashIDArray;
@property (nonatomic) NSMutableArray *usernameArray;

@property (nonatomic) UIView *overlay;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Create networkObject class
    self.networkObject = [NetworkObject requestInstance];
    
    // Create singletone class
    self.singleTone = [Singletone requestInstance];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    // Load session
    self.token = [self.networkObject loadSessionValue];
    
    self.animationDuration = 0.7;
    self.margin = 60;
    
    self.selectedJob = @"Photograper"; // Default Job
    
    // Load hitcontent
    [self.networkObject requestHitContent];
    
    /**********************/
    /* 테스트를 위한 임시데이터 */
    /**********************/
    // Photographer - 2, Programmer - 3, Editor - 4, Writer - 5
    self.jobList = [NSArray arrayWithObjects:@"Photograper",@"Programmer", @"Editor", @"Writer",nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getExpiredMessage) name:ExpiredNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadHitContentSuccess) name:LoadHitContentSuccessNotification object:nil];
    
    // NavigationBar Custom title, Setting
    [self CreateNavigationTitle];

    NSLog(@"ViewDidLoad Finish");
}

- (void)checkUserJob {
    
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
    
}

- (void)CreateNavigationTitle {
    
    NSLog(@"CreateNavigationTitle Start");
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *mainTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height / 2)];
    [mainTitle setTextColor:[UIColor whiteColor]];
    [mainTitle setText:@"Hoomi"];
    [mainTitle setFont:[UIFont systemFontOfSize:18.0f]];
    [mainTitle setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, titleView.frame.size.height / 2, titleView.frame.size.width, titleView.frame.size.height / 2)];
    [subTitle setTextColor:[UIColor whiteColor]];
    [subTitle setText:@"인기글"];
    [subTitle setFont:[UIFont systemFontOfSize:11.0f]];
    [subTitle setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:mainTitle];
    [titleView addSubview:subTitle];
    
    self.navigationItem.titleView = titleView;
    
    [self.navigationController.navigationBar setBarTintColor:[self.singleTone colorName:Tuna]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSLog(@"CreateNavigationTitle Finish");
    
}

- (void)LoadHitContentSuccess {
    
    // 사용자가 직군을 선택했는지 여부 확인
    [self checkUserJob];
    
    self.contentDataArray = [[NSMutableArray alloc] init];
    self.imageDataArray = [[NSMutableArray alloc] init];
    self.hashIDArray = [[NSMutableArray alloc] init];
    self.usernameArray = [[NSMutableArray alloc] init];
    
    NSArray *result = [self.networkObject hitContentInforJSONArray];
    
    for (NSInteger i = 0; i < [result count]; i++) {
        NSDictionary *dic = [result objectAtIndex:i];
        
        NSArray *experiences = [dic objectForKey:@"experiences"];
        
        for (NSInteger j = 0; j < [experiences count]; j++) {
            NSString *content = [[experiences objectAtIndex:j] objectForKey:@"content"];
            NSString *imageUrl = [[experiences objectAtIndex:j] objectForKey:@"image"];
            NSNumber *page = [[experiences objectAtIndex:j] objectForKey:@"page"];
            if([page  isEqual: @1]) {
                [self.contentDataArray addObject:content];
                [self.imageDataArray addObject:imageUrl];
            }
        }
        
        NSString *hashID = [dic objectForKey:@"hash_id"];
        [self.hashIDArray addObject:hashID];
        
        NSString *username = [dic objectForKey:@"username"];
        [self.usernameArray addObject:username];

    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        for (NSInteger k = 0; k < [self.contentDataArray count]; k++) {
            NSLog(@"contentData : %@", self.contentDataArray[k]);
        }
        
    });
}

- (void)getExpiredMessage {
    
    NSLog(@"세션이 만료되었습니다.");
    
    UIAlertController *sessionExpiredAlert = [UIAlertController alertControllerWithTitle:@"Exipred" message:@"Signature has expired." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        // 기존 저장되어 있는 Session 초기화
        [self.networkObject saveSessionValue:nil];
        
        // 루트뷰를 로그인화면으로 전환
        SignInViewController *signInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInView"];
        
        [[UIApplication sharedApplication].keyWindow setRootViewController:signInViewController];
        
    }];
    
    [sessionExpiredAlert addAction:logoutAction];
    [self presentViewController:sessionExpiredAlert animated:YES completion:nil];
    
}

- (void)loadServerData:(UIRefreshControl *)refreshControl {
    [self.overlay removeFromSuperview];
    [self.networkObject requestHitContent];
    
    [refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMyPage:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"EK" bundle:nil];
    MyPageTableViewController *myPage = [storyBoard instantiateViewControllerWithIdentifier:@"MyPage"];
    
    [self.navigationController pushViewController:myPage animated:YES];
    
}

- (IBAction)writeCareerPage:(id)sender {
    
    NSLog(@"Move Write Career Page");
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Cheese" bundle:nil];
    WritePageViewController *myPage = [storyBoard instantiateViewControllerWithIdentifier:@"WritePage"];
    
    [self presentViewController:myPage animated:YES completion:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentDataArray count];
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *Cell = @"Cell";
    
    ImageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    NSString *fullUsername = [self.usernameArray objectAtIndex:indexPath.row];
    NSRange range = [fullUsername rangeOfString:@"@" options:NSBackwardsSearch];
    NSString *username = [fullUsername substringToIndex:range.location];
    
    NSString *byUsername = [@" by " stringByAppendingString:username];
    
    cell.label.text = [[self.contentDataArray objectAtIndex:indexPath.row] stringByAppendingString:byUsername];
    [cell.label setTextColor:[UIColor whiteColor]];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[self.imageDataArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"default-placeholder.png"]];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select cell");
    
    // Singletone에 hashID값 저장
    // DetailResume 화면에서 hashID값 로드할 것
    [self.singleTone setHashID:[self.hashIDArray objectAtIndex:indexPath.row]];
    
    // 다른 스토리보드(Cheese)의 세부화면으로 Modal 띄워줌
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Cheese" bundle:nil];
    DetailResumeViewController *detailResume = [storyBoard instantiateViewControllerWithIdentifier:@"DetailResume"];
    [self presentViewController:detailResume animated:YES completion:nil];
    
}

#pragma mark - Select Job List Custom View
- (void)selectJobList {
    
    // 테이블뷰 스크롤 및 버튼 활성화
    [self scrollAndButtonEnable:NO];
    
    // 버튼 모서리
    NSInteger cornerRadius = 3;
    BOOL clipsToBounds = YES;
    
    // 직군선택화면을 현재뷰에서 커스텀뷰로 만들어서 표시
    UIView *jobSelectCustomView =[[UIView alloc] initWithFrame:CGRectMake(self.margin / 2, - self.margin * 5, self.view.frame.size.width - self.margin, self.margin * 5)];
    jobSelectCustomView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    jobSelectCustomView.backgroundColor = [self.singleTone colorName:Concrete];
    jobSelectCustomView.layer.borderWidth = 2.0f;
    jobSelectCustomView.layer.cornerRadius = 3 * cornerRadius;
    
    UILabel *jobSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, jobSelectCustomView.frame.size.width, 10)];
    [jobSelectLabel setText:@"직업을 선택해주세요."];
    [jobSelectLabel setTextColor:[UIColor blackColor]];
    [jobSelectLabel setTextAlignment:NSTextAlignmentCenter];
    [jobSelectCustomView addSubview:jobSelectLabel];
    
    // jobSelectCustomView에 PickerView 추가
    UIPickerView *jobPicker = [[UIPickerView alloc] init];
    [jobPicker setFrame:CGRectMake(0, 40, jobSelectCustomView.frame.size.width, jobSelectCustomView.frame.size.height - self.margin * 2)];
    [jobSelectCustomView addSubview:jobPicker];
    
    // 직군 선택 버튼
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton setFrame:CGRectMake(30, jobPicker.frame.size.height + 60, jobSelectCustomView.frame.size.width - 60, 45)];
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

@end
