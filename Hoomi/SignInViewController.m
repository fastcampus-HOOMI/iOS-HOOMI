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
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "SignInViewController.h"
#import "SingUpTableViewController.h"
#import "UICKeyChainStore.h"
#import "MainTableViewController.h"
#import "Singletone.h"



@interface SignInViewController ()
<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *userIDTextfield; // userID
@property (nonatomic, strong) IBOutlet UITextField *passwordTextfield; // password

@property (nonatomic) NSNotificationCenter *notificationCenter;

@property (nonatomic) UITextField *currentTextField; // 최근 선택된 TextField

@property (strong, nonatomic) IBOutlet UIButton *signUpButton; // 회원가입
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton; // 페이스북 로그인
@property (strong, nonatomic) IBOutlet UIButton *kakaoLoginButton; // 카카오톡 로그인

@property (nonatomic, strong) Singletone *singleTone;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [self saveSessionValue:@"abc"];
    
    self.singleTone = [Singletone requestInstance];
    
    [self.view setBackgroundColor:[self.singleTone colorKey:@"concrete"]];
    
    self.title = @"HOOMI";
    [self.navigationController.navigationBar setBarTintColor:[self.singleTone colorKey:@"danube"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Set Custom TextField
    [self customTextField:self.userIDTextfield];
    [self customTextField:self.passwordTextfield];
    
//    self.facebookLoginButton.delegate = self;
    
    self.userIDTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    [self.notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:@"keyboardToolbar" object:self.view.window];
    

    // 뷰를 클릭시 선택되어 있는 TextField의 키보드를 내리는 메소드 호출
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [tapGesture addTarget:self action:@selector(endEditingTextField)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self createCustomButton];

    
}

- (void)createCustomButton {
    
    NSInteger cornerRadius = 3;
    BOOL clipsToBounds = YES;
    CGFloat buttonTitleFont = 15.f;
    
    self.facebookLoginButton.layer.cornerRadius = cornerRadius;
    self.facebookLoginButton.clipsToBounds = clipsToBounds;
    [self.facebookLoginButton setBackgroundColor:[UIColor colorWithRed:0.25 green:0.36 blue:0.59 alpha:1.0]];
    [self.facebookLoginButton setTitle:@"Facebook으로 로그인하기" forState:UIControlStateNormal];
    [self.facebookLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.facebookLoginButton setFont:[UIFont boldSystemFontOfSize:buttonTitleFont]];
    
    
    [self.kakaoLoginButton setBackgroundColor:[UIColor colorWithRed:1.00 green:0.92 blue:0.20 alpha:1.0]];
    self.kakaoLoginButton.layer.cornerRadius = cornerRadius;
    self.kakaoLoginButton.clipsToBounds = clipsToBounds;
    [self.kakaoLoginButton setTitle:@"카카오톡으로 로그인하기" forState:UIControlStateNormal];
    [self.kakaoLoginButton setTitleColor:[UIColor colorWithRed:75.0/255.0 green:24.0/255.0 blue:2.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.kakaoLoginButton setFont:[UIFont boldSystemFontOfSize:buttonTitleFont]];
    
    self.signUpButton.layer.cornerRadius = cornerRadius;
    self.signUpButton.clipsToBounds = clipsToBounds;
    [self.signUpButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.signUpButton setTitle:@"HOOMI 회원가입" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpButton setFont:[UIFont boldSystemFontOfSize:buttonTitleFont]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    self.currentTextField = textField;
    [self.notificationCenter postNotificationName:@"keyboardToolbar" object:self.view.window];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *) notification {

    UIToolbar *signUpToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *margin1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *signUpButton = [[UIBarButtonItem alloc] initWithTitle:@"로그인" style:UIBarButtonItemStylePlain target:self action:@selector(signInUser)];
    
    UIBarButtonItem *margin2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [signUpToolbar setItems:[NSArray arrayWithObjects:margin1, signUpButton, margin2, nil]];    
    
    [self.userIDTextfield setInputAccessoryView:signUpToolbar];
    [self.passwordTextfield setInputAccessoryView:signUpToolbar];

}

/**
 *  로그인 버튼을 눌렀을 때 실행되는 메소드
 */
- (void)signInUser {

    // 아이디 또는 비밀번호가 빈칸일 경우
    if([self.userIDTextfield.text isEqualToString:@""] || [self.passwordTextfield.text isEqualToString:@""]) {
        
        [self errorAlert:@"빈칸을 입력해주세요."];
        NSLog(@"빈칸을 채워주세요.");
        
    } else {
        
        [self finishLogin];
    }
   
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
- (void)customTextField:(UITextField *)textField {
    
    [textField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [textField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [textField.layer setBorderWidth: 1.0];
    [textField.layer setCornerRadius:8.0f];
    [textField.layer setMasksToBounds:YES];
    
//    textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.rightViewMode = UITextFieldViewModeAlways;
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
        [wrongView setBackgroundColor:[UIColor colorWithRed:1.00 green:0.80 blue:0.18 alpha:1.0]];
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
                      
                      [self saveSessionValue:token];
                      
                  }
              }];
             
             [self finishLogin];
         }
     }];
    
}

/**
 *  카카오톡 로그인
 */
- (IBAction)invokeLoginWithKakao {
    
    // ensure old session was closed
    [[KOSession sharedSession] close];
    
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            // login success
            NSLog(@"login succeeded.");
            
            NSString *token = [KOSession sharedSession].accessToken;
            [self saveSessionValue:token];
            NSLog(@"kakao session : %@", token);
            
            [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError *error) {
                if (result) {
                    // success
                    
                    [self finishLogin];
                    NSLog(@"userId=%@", result.ID);
                    NSLog(@"nickName=%@", [result propertyForKey:@"nickname"]);
                } else {
                    // failed
                }
            }];
        } else {
            // failed
            NSLog(@"login failed.");
        }
    }];
}

- (void)saveSessionValue:(NSString *)session {
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.zzzbag.Hoomi"];
    keychain[@"session"] = session;
    
    // 불러올 때
//    NSString *token = [keychain stringForKey:@"session"];
//    NSLog(@"token : %@", token);
}

- (void)finishLogin {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Uma" bundle:nil];
    MainTableViewController *mainViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MainTableView"];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:mainViewController];
    // 모달로 띄울 경우
    [self presentViewController:mainViewController animated:YES completion:nil];
    // 푸쉬
    [self.navigationController pushViewController:mainViewController animated:YES];
    
    
    [self.userIDTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];

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
