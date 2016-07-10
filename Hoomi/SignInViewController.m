//
//  SignInViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 6. 30..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SignInViewController.h"
#import "SingUpTableViewController.h"
#import "MainTableViewController.h"
#import "Singletone.h"
#import "AFNetworking.h"
#import "NetworkObject.h"

@interface SignInViewController ()
<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *userIDTextfield; // userID
@property (nonatomic, strong) IBOutlet UITextField *passwordTextfield; // password

@property (nonatomic) NSNotificationCenter *notificationCenter;

@property (nonatomic) UITextField *currentTextField; // 최근 선택된 TextField

@property (strong, nonatomic) IBOutlet UIButton *signUpButton; // 회원가입
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton; // 페이스북 로그인
@property (strong, nonatomic) IBOutlet UIButton *defaultsLoginButton; // 기본 로그인
@property (strong, nonatomic) IBOutlet UIButton *findUserPasswordButton; // 패스워드 찾기

@property (nonatomic) IBOutlet UIActivityIndicatorView *loginLoadIndicator;

@property (nonatomic, strong) Singletone *singleTone;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.singleTone = [Singletone requestInstance];
    
    // 로그인 Indicator 설정
    [self indicatorRunStatus:NO];
    
    [self.view setBackgroundColor:[self.singleTone colorKey:@"tuna"]];
    
    // Set Custom TextField
    NSMutableArray *textfields = [[NSMutableArray alloc] initWithObjects:self.userIDTextfield, self.passwordTextfield, nil];
    [self customTextFields:textfields];

    // 뷰를 클릭시 선택되어 있는 TextField의 키보드를 내리는 메소드 호출
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [tapGesture addTarget:self action:@selector(endEditingTextField)];
    [self.view addGestureRecognizer:tapGesture];
    
    // 로그인, 회원가입, 소셜로그인 커스텀 버튼 생성
    [self createCustomButton];
    
    // 노티피케이션 센터 등록
    [self notificationObserver];
    
}

- (void)notificationObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLogin) name:LoginSuccessNotifiaction object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failLogin) name:LoginFailNotification object:nil];
    
}

- (void)createCustomButton {
    
    NSInteger cornerRadius = 3;
    BOOL clipsToBounds = YES;
    
    self.defaultsLoginButton.layer.cornerRadius = cornerRadius;
    self.defaultsLoginButton.clipsToBounds = clipsToBounds;
    [self.defaultsLoginButton setBackgroundColor:[self.singleTone colorKey:@"outrageous orange"]];
    [self.defaultsLoginButton setTitle:@"로그인" forState:UIControlStateNormal];
    [self.defaultsLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.facebookLoginButton.layer.cornerRadius = cornerRadius;
    self.facebookLoginButton.clipsToBounds = clipsToBounds;
    [self.facebookLoginButton setBackgroundColor:[self.singleTone colorKey:@"mariner"]];
    [self.facebookLoginButton setTitle:@"Facebook 로그인" forState:UIControlStateNormal];
    [self.facebookLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.signUpButton setBackgroundColor:[UIColor clearColor]];
    [self.signUpButton setTitle:@"New here? Sign Up" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.findUserPasswordButton setBackgroundColor:[UIColor clearColor]];
    [self.findUserPasswordButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [self.findUserPasswordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.currentTextField = textField;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    
    return YES;
}

/**
 *  로그인 버튼을 눌렀을 때 실행되는 메소드
 */
- (IBAction)signInDefault {
    
    NSString *userID = self.userIDTextfield.text;
    NSString *password = self.passwordTextfield.text;

    // 아이디 또는 비밀번호가 빈칸일 경우
    if([userID isEqualToString:@""] || [password isEqualToString:@""]) {
        
        [self errorAlert:@"빈칸을 입력해주세요."];
        
    } else {
        NSLog(@"request login");
        [self indicatorRunStatus:NO];
        // NetworkObject로 요청
        NetworkObject *networkObj = [[NetworkObject alloc] init];
        [networkObj initSignInUserID:userID password:password];
        [networkObj requestSignIn];
        
    }
}

- (void)successLogin {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self indicatorRunStatus:YES];
        [self endEditingTextField];
        [self finishLogin];
    });
}

- (void)failLogin {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self indicatorRunStatus:YES];
        [self errorAlert:@"아이디 또는 패스워드를 확인해주세요."];
    });
}



/**
 *  회원가입 버튼을 눌렀을 때 실행되는 메소드
 */
- (IBAction)signUpAction {
    
    SingUpTableViewController *signUpView = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpPage"];
    [self presentViewController:signUpView animated:YES completion:nil];
    
}

- (void)endEditingTextField {
    
    [self.currentTextField endEditing:YES];
    
}

/**
 *  커스텀 텍스트필드를 만들어주는 메소드
 *
 *  @param textField 실행하고자하는 TextField
 */
- (void)customTextFields:(NSMutableArray *)textFields {
    
    for (UITextField *textField in textFields) {
        
        textField.delegate = self;
        
        NSString *placeholderText = @"";
        [textField setBackgroundColor:[UIColor colorWithRed:0.28 green:0.29 blue:0.33 alpha:1.00]];
        
        if(textField == self.userIDTextfield) {
            placeholderText = @"E-mail address";
        } else {
            placeholderText = @"password";
        }
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(textField.frame.origin.x
                                                                    , textField.frame.origin.y
                                                                    , 25.0, 25.0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftView;
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholderText attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}]];
        [textField.layer setMasksToBounds:YES];
        [textField setTextColor:[UIColor whiteColor]];
    }

}

/**
 *  경고메시지를 뷰 상단에 띄워주는 메소드
 *
 *  @param errorMsg 경고메시지
 */
- (void)errorAlert:(NSString *)errorMsg {
    
    NSInteger height = 20;
    
    UIView *wrongView=[[UIView alloc] init];
    [wrongView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, height)];
    [wrongView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *wrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wrongView.frame.size.width, wrongView.frame.size.height)];
    [wrongLabel setTextColor:[UIColor whiteColor]];
    [wrongLabel setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    [wrongLabel setTextAlignment:NSTextAlignmentCenter];
    [wrongLabel setText:errorMsg];
    [wrongView addSubview:wrongLabel];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [wrongView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20,[UIScreen mainScreen].bounds.size.width, height)];
        [wrongView setBackgroundColor:[self.singleTone colorKey:@"tuna"]];
        [self.view addSubview:wrongView];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0.7 options:UIViewAnimationOptionLayoutSubviews animations:^{
            [wrongView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, height)];
            [wrongView setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            [wrongView removeFromSuperview];
        }];
        
    }];
    
}

/**
 *  페이스북 로그인
 */
- (IBAction)invokeLoginWithFacebook {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             
             NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
             [parameters setValue:@"id,name,email" forKey:@"fields"];
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                           id result, NSError *error) {
                  //         NSLog(@"profile : %@", [[FBSDKProfile currentProfile] userID]);
                  if(!error) {
                      
                      NSLog(@"name : %@", [[result objectForKey:@"name"] stringByRemovingPercentEncoding]);
                      NSLog(@"id : %@", [result objectForKey:@"id"]);
                      NSLog(@"email : %@", [result objectForKey:@"email"]);
                      
                      NSString *token = [[FBSDKAccessToken currentAccessToken] tokenString];
                      NSLog(@"token : %@", token);
                      NetworkObject *networkObject = [[NetworkObject alloc] init];
                      [networkObject saveSessionValue:token];
                      
                  }
              }];
             
             [self finishLogin];
         }
     }];
    
}

- (void)indicatorRunStatus:(BOOL)runStatus {
    
    [self.loginLoadIndicator setHidden:!runStatus];
    
    if(runStatus) {
        [self.loginLoadIndicator startAnimating];
    } else {
        [self.loginLoadIndicator stopAnimating];
    }
}

- (void)finishLogin {
    
    MainTableViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTableView"];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:mainViewController];

}

@end
