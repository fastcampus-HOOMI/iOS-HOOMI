//
//  SingUpTableViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 6. 30..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "SingUpTableViewController.h"

@interface SingUpTableViewController ()
<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *userID;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *passwordRewrite;

@property (nonatomic) NSNotificationCenter *notificationCenter;

@property (nonatomic) UITextField *currentTextField; // current selected textfield


@end

@implementation SingUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 화면 시작 후 0.3초뒤에 email 입력란에 키보드 나타냄
        [self.email becomeFirstResponder];
    });

    self.email.delegate = self;
    self.userID.delegate = self;
    self.password.delegate = self;
    self.passwordRewrite.delegate = self;

    // NavigationBar Title
    self.title = @"회원가입";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.36 green:0.59 blue:0.80 alpha:1.00]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    [self.notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:@"keyboardToolbar" object:self.view.window];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self.notificationCenter removeObserver:self name:@"keyboardToolbar" object:self.view.window];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.currentTextField = textField;
    
    [self.notificationCenter postNotificationName:@"keyboardToolbar" object:self.view.window];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *) noti {
    
    UIToolbar *signUpToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *margin1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *signUpButton = [[UIBarButtonItem alloc] initWithTitle:@"등록" style:UIBarButtonItemStylePlain target:self action:@selector(signUpUser)];
    
    UIBarButtonItem *margin2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [signUpToolbar setItems:[NSArray arrayWithObjects:margin1, signUpButton, margin2, nil]];
    
    [self.email setInputAccessoryView:signUpToolbar];
    [self.userID setInputAccessoryView:signUpToolbar];
    [self.password setInputAccessoryView:signUpToolbar];
    [self.passwordRewrite setInputAccessoryView:signUpToolbar];
    
    
    NSLog(@"show keyboard");
    
}

- (void)signUpUser {
    
    [self.currentTextField endEditing:YES];
    
    NSString *email = self.email.text;
    NSString *userID = self.userID.text;
    NSString *firstPassword = self.password.text;
    NSString *secondPassword = self.passwordRewrite.text;
    
    /*
     4개 필드 빈칸 여부
     */
    if([email isEqualToString:@""] || [userID isEqualToString:@""] || [firstPassword isEqualToString:@""] || [secondPassword isEqualToString:@""]){
        
        [self errorAlert:@"빈칸을 입력해주세요."];
        return;
    }
    
    /*
     2개의 패스워드 일치 여부
     */
    
    // 일치
    if([firstPassword isEqualToString:secondPassword]) {
        
        // DataCenter에 데이터 전송
        NSLog(@"email : %@, userID : %@", email, userID);
        
        
        // 로그인 코드
        NSInteger loginCode = 400;
        
        // 이미 서버 데이터베이스에 아이디가 존재하는 경우 
        if(loginCode == 400) {
            
            [self errorAlert:@"이메일이나 아이디가 이미 존재합니다."];
            return;
            
        } else {
           
            // 회원가입 완료 메시지 이후 메인 페이지로 이동
            
        }
        
    } else { // 불일치
        
        [self errorAlert:@"비밀번호가 맞지않습니다."];
        return;
        
    }
}

- (IBAction)cancelSignUp:(id)sender {
    
    [self.currentTextField endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 키보드 내려가고 0.3초후에 회원가입 페이지 종료
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15.f;
}

/**
 *  경고메시지를 뷰 상단에 띄워주는 메소드
 *
 *  @param errorMsg 경고메시지
 */
- (void)errorAlert:(NSString *)errorMsg {
    
    NSInteger height = 20;
    
    UIView *wrongView=[[UIView alloc] init];
    [wrongView setFrame:CGRectMake(0, -height, [UIScreen mainScreen].bounds.size.width, height)];
    [wrongView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *wrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wrongView.frame.size.width, wrongView.frame.size.height)];
    [wrongLabel setTextColor:[UIColor whiteColor]];
    [wrongLabel setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    [wrongLabel setTextAlignment:NSTextAlignmentCenter];
    [wrongLabel setText:errorMsg];
    [wrongView addSubview:wrongLabel];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [wrongView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, height)];
        [wrongView setBackgroundColor:[UIColor colorWithRed:0.97 green:0.66 blue:0.31 alpha:1.0]];
        [self.view addSubview:wrongView];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0.7 options:UIViewAnimationOptionLayoutSubviews animations:^{
            [wrongView setFrame:CGRectMake(0, -height,[UIScreen mainScreen].bounds.size.width, height)];
            [wrongView setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            [wrongView removeFromSuperview];
            [self.currentTextField becomeFirstResponder];
        }];
        
    }];
    
}

@end
