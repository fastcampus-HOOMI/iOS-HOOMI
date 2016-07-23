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
#import "UMAlertView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainTableViewController ()
<UMAlertViewDelegate>

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

@property (nonatomic) UMAlertView *umAlertView;
@property (nonatomic) NSInteger umAlertViewMenu; // 0은 직군 저장, 1은 글쓰기 테마

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Create networkObject class
    self.networkObject = [NetworkObject requestInstance];
    
    // Create singletone class
    self.singleTone = [Singletone requestInstance];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    self.animationDuration = 0.7;
    self.margin = 60;
    
    self.selectedJob = @"Photograper"; // Default Job
    self.umAlertView = [[UMAlertView alloc] init];
    self.umAlertView.delegate = self;
    
    // Load hitcontent
    [self.networkObject requestHitContent];
    
    /**********************/
    /* 테스트를 위한 임시데이터 */
    /**********************/
    // Photographer - 2, Programmer - 3, Editor - 4, Writer - 5
    
    // Add Notification Observer
    [self addNotificationCenter];
    
    // NavigationBar Custom title, Setting
    [self CreateNavigationTitle];

    NSLog(@"ViewDidLoad Finish");
}

- (void)addNotificationCenter {
    
    // Token Expired Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getExpiredMessage) name:ExpiredNotification object:nil];
    
    // Hit Content Load Success Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadHitContentSuccess) name:LoadHitContentSuccessNotification object:nil];
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
        
        NSArray *jobList = @[@"Photograper", @"Programmer", @"Editor", @"Writer"];
        
        [self.umAlertView um_showAlertViewTitle:@"Select your job" pickerData:jobList completion:^{
            // 직군을 선택하는 뷰가 나오면 테이블뷰 스크롤 불가능
            [self.tableView setScrollEnabled:NO];
            
            self.umAlertViewMenu = 0;
        }];
        
        
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
    
    NSArray *themeData = @[@"감성 이미지 테마", @"이성 개발자 테마"];
    [self.umAlertView um_showAlertViewTitle:@"Select Write Theme" pickerData:themeData completion:^{
        [self scrollAndButtonEnable:NO];
        self.umAlertViewMenu = 1;
        
    }];
    
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

- (void)selectUMAlertButton {

    if(self.umAlertViewMenu == 0) {
    
        [self.umAlertView um_dismissAlertViewCompletion:^{
            [self scrollAndButtonEnable:YES];
            [self.defaults setObject:self.selectedJob forKey:@"userJob"];
            //    [self.networkObject requestSaveJob:self.selectedJob Token:self.token];
            [self.effectView removeFromSuperview];
        }];
        
    } else if(self.umAlertViewMenu == 1) {
        
        [self.umAlertView um_dismissAlertViewCompletion:^{
            [self scrollAndButtonEnable:YES];
            
            NSLog(@"select data : %@", [self.umAlertView selectData]);
            NSArray *themeData = @[@"감성 이미지 테마", @"이성 개발자 테마"];
            NSInteger themeNumber = 0;
            for (NSInteger num = 0; num < [themeData count]; num++) {
                if(![[themeData objectAtIndex:num] isEqualToString:[self.umAlertView selectData]]) {
                    themeNumber += 1;
                } else {
                    break;
                }
            }
            
            if(themeNumber == 0) {
                
                [self.singleTone setFormThemeNumber:themeNumber];
                
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Cheese" bundle:nil];
                WritePageViewController *writePage = [storyBoard instantiateViewControllerWithIdentifier:@"WritePage"];
                [self presentViewController:writePage animated:YES completion:nil];
                
            } else {
                
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"알림!" message:@"이성 개발자 테마는 현재 웹에서만 \n이용가능합니다." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
                [controller addAction:okAction];
                
                [self presentViewController:controller animated:YES completion:nil];
                
            }
        }];
    }
}

/**
 *  직군선택하는 커스텀뷰가 실행되면 테이블뷰 스크롤과 버튼을 비활성화시키는 메소드
 *
 *  @param enable 활성화 YES, 비활성화 NO
 */
- (void)scrollAndButtonEnable:(BOOL) enable {
    
    [self.tableView setScrollEnabled:enable];
    [self.tableView setAllowsSelection:enable];
    [self.writeCareer setEnabled:enable];
    [self.myPage setEnabled:enable];
    
}

@end
