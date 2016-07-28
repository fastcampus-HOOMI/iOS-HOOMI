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
#import "SignUpViewController.h"
#import "MainTableViewController.h"
#import "Singletone.h"
#import "AFNetworking.h"
#import "NetworkObject.h"
#import "KSToastView.h"

#define INDICATOR_LOAD_TIME 1
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
@property (nonatomic, strong) NetworkObject *networkObject;

@property (nonatomic) BOOL isRightEmail;
@property (nonatomic) BOOL isRightLengthPassword;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.singleTone = [Singletone requestInstance];
    self.networkObject = [NetworkObject requestInstance];
    // 로그인 Indicator 설정
    [self indicatorRunStatus:NO];
    
    [self.view setBackgroundColor:[self.singleTone colorName:SignUpIn]];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failLogin)
                                                 name:LoginFailNotification object:nil];
    

    
}

- (void)createCustomButton {
    
    NSInteger cornerRadius = 3;
    BOOL clipsToBounds = YES;
    
    self.defaultsLoginButton.layer.cornerRadius = cornerRadius;
    self.defaultsLoginButton.clipsToBounds = clipsToBounds;
    [self.defaultsLoginButton setBackgroundColor:[self.singleTone colorName:OutrageousOrange]];
    [self.defaultsLoginButton setTitle:@"로그인" forState:UIControlStateNormal];
    [self.defaultsLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.facebookLoginButton.layer.cornerRadius = cornerRadius;
    self.facebookLoginButton.clipsToBounds = clipsToBounds;
    [self.facebookLoginButton setBackgroundColor:[self.singleTone colorName:Mariner]];
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

-(void)textFieldDidChange :(UITextField *) textField{
//    NSLog(@"change passwordTextfield");
    
    UIColor *leftColor = nil;
    if (textField == self.userIDTextfield) {
        
        if([self.singleTone isCorrectEmail:textField.text]) {
            leftColor = [UIColor greenColor];
            self.isRightEmail = YES;
        } else {
            leftColor = [UIColor redColor];
            self.isRightEmail = NO;
        }
        
    } else if(textField == self.passwordTextfield) {
        
        if(self.passwordTextfield.text.length < MIN_PASSWORD_LENGTH) {
            leftColor = [UIColor redColor];
            self.isRightLengthPassword = NO;
        } else if(self.passwordTextfield.text.length >= MIN_PASSWORD_LENGTH) {
            leftColor = [UIColor greenColor];
            self.isRightLengthPassword = YES;
        }
    }
    
    [self leftViewInTextField:textField Color:leftColor];
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
        [KSToastView ks_showToast:[self.singleTone toastMsg:EmptyLoginData] duration:2.0f completion:^{
            [self.currentTextField becomeFirstResponder];
        }];
    } else if(!self.isRightEmail) {
        [KSToastView ks_showToast:[self.singleTone toastMsg:WrongEmail] duration:2.0f completion:^{
            [self.currentTextField becomeFirstResponder];
        }];
    } else if(!self.isRightLengthPassword) {
        [KSToastView ks_showToast:[self.singleTone toastMsg:ShortPassword] duration:2.0f completion:^{
            [self.currentTextField becomeFirstResponder];
        }];
    } else {
        NSLog(@"request login");
        [self indicatorRunStatus:YES];
        // NetworkObject로 요청
        [self.networkObject initSignInUserID:userID password:password];
        [self.networkObject requestSignIn];
        
    }
}

- (void)successLogin {
    NSLog(@"login success");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, INDICATOR_LOAD_TIME * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self indicatorRunStatus:NO];
        [self endEditingTextField];
        [self finishLogin];
    });
}

- (void)failLogin {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, INDICATOR_LOAD_TIME * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self indicatorRunStatus:NO];
        
        [KSToastView ks_showToast:[self.singleTone toastMsg:WrongLoginData] duration:2.0f completion:nil];
        
    });
}


/**
 *  회원가입 버튼을 눌렀을 때 실행되는 메소드
 */
- (IBAction)signUpAction {
    
    SignUpViewController *signUpView = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpPage"];
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
        [textField setBackgroundColor:[self.singleTone colorName:Maco]];
        
        if(textField == self.userIDTextfield) {
            placeholderText = @"E-mail address";
        } else {
            placeholderText = @"Password";
        }
        
        [self leftViewInTextField:textField Color:[UIColor redColor]];
        
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholderText attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}]];
        [textField.layer setMasksToBounds:YES];
        [textField setTextColor:[UIColor whiteColor]];
        
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }

}

- (void)leftViewInTextField:(UITextField *)textField Color:(UIColor *)color {
    
    // Textfield의 왼쪽에 1:1로 뷰를 하나 채워넣음
    // 정상적인 데이터가 들어가 있는지를 판단하기 위해서
    UIView *allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    UIView *firstLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 40)];
    [firstLeftView setBackgroundColor:color];
    UIView *lastLeftView = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 4, 40)];
    [lastLeftView setBackgroundColor:[UIColor clearColor]];
    
    [allView addSubview:firstLeftView];
    [allView addSubview:lastLeftView];
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = allView;
    
}


/**
 *  페이스북 로그인
 */
- (IBAction)invokeLoginWithFacebook {
    [self indicatorRunStatus:YES];
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
                    
                      // 사용자 정보는 result에 다 들어있음
                      NSString *token = [[FBSDKAccessToken currentAccessToken] tokenString];
                      NSLog(@"facebook token : %@", token);
                      
                      [self.networkObject requestFacebookSignUpToken:token];
                      
                  }
              }];
             
             
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
    
    [KSToastView ks_showToast:[self.singleTone toastMsg:LoginWelcome] duration:2.0f completion:nil];
    
}

@end
