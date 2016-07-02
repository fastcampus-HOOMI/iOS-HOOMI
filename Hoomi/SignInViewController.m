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


@interface SignInViewController ()
<UITextFieldDelegate, UIGestureRecognizerDelegate, FBSDKLoginButtonDelegate>

@property (nonatomic, strong) IBOutlet UITextField *userIDTextfield;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextfield;

@property (nonatomic) NSNotificationCenter *notificationCenter;

@property (nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;

@property (strong, nonatomic) IBOutlet UIButton *kakaoLoginButton;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"HOOMI";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.36 green:0.59 blue:0.80 alpha:1.00]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Set Custom TextField
    [self customTextField:self.userIDTextfield];
    [self customTextField:self.passwordTextfield];
    
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
    
    self.facebookLoginButton.delegate = self;
    self.facebookLoginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
//    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    if([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"페이스북 토큰있음");
    }
    
    if([KOSession sharedSession].accessToken) {
        NSLog(@"카카오톡 토큰있음");
    }
    
    self.kakaoLoginButton = [[KOLoginButton alloc] init];
    self.kakaoLoginButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
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

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
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
             NSLog(@"expired date : %@", [[FBSDKAccessToken currentAccessToken] expirationDate]);
         }
     }];
    
}

- (IBAction)invokeLoginWithKakao {
    
    // ensure old session was closed
    [[KOSession sharedSession] close];
    
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            // login success
            NSLog(@"login succeeded.");
            
            NSLog(@"kakao session : %@", [KOSession sharedSession].accessToken);
            
            [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError *error) {
                if (result) {
                    // success
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

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
    
    NSLog(@"logout");
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
