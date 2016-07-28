//
//  SignUpViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 7. 11..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "SignUpViewController.h"
#import "Singletone.h"
#import "NetworkObject.h"
#import "KSToastView.h"

@interface SignUpViewController ()
<UITextFieldDelegate>

@property (nonatomic) Singletone *singleTone;
@property (nonatomic) NetworkObject *networkObject;

@property (nonatomic, weak) IBOutlet UITextField *userIDTextfield;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextfield;
@property (nonatomic, weak) IBOutlet UITextField *firstNameTextfield;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextfield;
@property (nonatomic, weak) IBOutlet UITextField *rePasswordTextfield;
@property (nonatomic, weak) IBOutlet UIButton *signUpButton;

@property (nonatomic, weak) UITextField *currentTextField;

@property (nonatomic) BOOL isRightEmail;
@property (nonatomic) BOOL isRightLengthPassword;
@property (nonatomic) BOOL isRightLengthRePassword;
@property (nonatomic) BOOL isRightName;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.singleTone = [Singletone requestInstance];
    self.networkObject = [NetworkObject requestInstance];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.userIDTextfield becomeFirstResponder];
    });
    
    
    [self.view setBackgroundColor:[self.singleTone colorName:SignUpIn]];
    
    self.title = @"회원가입";
    [self.navigationController.navigationBar setBarTintColor:[self.singleTone colorName:SignUpIn]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableArray *textFields = [[NSMutableArray alloc] initWithObjects:self.userIDTextfield, self.lastNameTextfield, self.firstNameTextfield, self.passwordTextfield, self.rePasswordTextfield, nil];
    [self customTextFields:textFields];
    [self textFieldDelegate:textFields];
    
    NSInteger cornerRadius = 3;
    BOOL clipsToBounds = YES;
    
    self.signUpButton.layer.cornerRadius = cornerRadius;
    self.signUpButton.clipsToBounds = clipsToBounds;
    [self.signUpButton setBackgroundColor:[UIColor grayColor]];
    [self.signUpButton setTitle:@"회원가입" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpButton setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successSignUp) name:SignUpSuccessNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDelegate:(NSMutableArray *)textFields {
    
    for (UITextField *textField in textFields) {
        textField.delegate = self;
    }
    
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
        } else if(textField == self.lastNameTextfield) {
            placeholderText = @"Last Name";
        } else if(textField == self.firstNameTextfield) {
            placeholderText = @"First Name";
        } else if(textField == self.passwordTextfield) {
            placeholderText = @"Password";
        } else if(textField == self.rePasswordTextfield) {
            placeholderText = @"Password Re";
        }
        
        [self leftViewInTextField:textField Color:[UIColor redColor]];
        
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholderText attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}]];
        [textField.layer setMasksToBounds:YES];
        [textField setTextColor:[UIColor whiteColor]];
        
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSLog(@"change passwordTextfield");
    
    UIColor *leftColor = nil;
    if (textField == self.userIDTextfield) {
        
        if([self.singleTone isCorrectEmail:textField.text]) {
            leftColor = [UIColor greenColor];
            self.isRightEmail = YES;
        } else {
            leftColor = [UIColor redColor];
            self.isRightEmail = NO;
        }
        
    } else if(textField == self.lastNameTextfield) {
      
        if(self.lastNameTextfield.text.length > 0) {
            leftColor = [UIColor greenColor];
            self.isRightName = YES;
        } else {
            leftColor = [UIColor redColor];
            self.isRightName = NO;
        }
        
    } else if(textField == self.firstNameTextfield) {
        
        if(self.firstNameTextfield.text.length > 0) {
            leftColor = [UIColor greenColor];
            self.isRightName = YES;
        } else {
            leftColor = [UIColor redColor];
            self.isRightName = NO;
        }
        
    } else if(textField == self.passwordTextfield) {
        
        if(self.passwordTextfield.text.length < MIN_PASSWORD_LENGTH) {
            leftColor = [UIColor redColor];
            self.isRightLengthPassword = NO;
        } else if(self.passwordTextfield.text.length >= MIN_PASSWORD_LENGTH) {
            leftColor = [UIColor greenColor];
            self.isRightLengthPassword = YES;
        }
    } else if(textField == self.rePasswordTextfield) {
        
        if(self.rePasswordTextfield.text.length < MIN_PASSWORD_LENGTH || ![self.passwordTextfield.text isEqualToString:self.rePasswordTextfield.text]) {
            leftColor = [UIColor redColor];
            self.isRightLengthRePassword = NO;
        } else if(self.passwordTextfield.text.length >= MIN_PASSWORD_LENGTH && [self.passwordTextfield.text isEqualToString:self.rePasswordTextfield.text]) {
            leftColor = [UIColor greenColor];
            self.isRightLengthRePassword = YES;
        }
    }
    
    [self leftViewInTextField:textField Color:leftColor];
    
    if(self.isRightName && self.isRightEmail && self.isRightLengthPassword && self.isRightLengthRePassword) {
        [self.signUpButton setBackgroundColor:[self.singleTone colorName:OutrageousOrange]];
        [self.signUpButton setEnabled:YES];
    } else {
        [self.signUpButton setBackgroundColor:[UIColor grayColor]];
        [self.signUpButton setEnabled:NO];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    
    return YES;
}

- (IBAction)signUpUser {
    
    [self.currentTextField endEditing:YES];
    
    NSString *userID = self.userIDTextfield.text;
    NSString *lastName = self.lastNameTextfield.text;
    NSString *firstName = self.firstNameTextfield.text;
    NSString *firstPassword = self.passwordTextfield.text;
    NSString *secondPassword = self.rePasswordTextfield.text;
    
    /*
     4개 필드 빈칸 여부
     */
    if([userID isEqualToString:@""] || [lastName isEqualToString:@""] || [firstName isEqualToString:@""] || [firstPassword isEqualToString:@""] || [secondPassword isEqualToString:@""]){
        
        [KSToastView ks_showToast:[self.singleTone toastMsg:EmptyLoginData] duration:2.0f];
        
        return;
    }
    
    /*
     2개의 패스워드 일치 여부
     */
    
    // 일치
    if([firstPassword isEqualToString:secondPassword]) {
        
        [self.networkObject initSignUpUserID:userID lastName:lastName firstName:firstName password:secondPassword];
        [self.networkObject requestSignUp];
        
        
    } else { // 불일치
        
        [KSToastView ks_showToast:[self.singleTone toastMsg:WrongLoginData] duration:2.0f completion:nil];
        
        return;
        
    }
}

- (void)successSignUp {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        /// show with a completion block.
        [KSToastView ks_showToast:[self.singleTone toastMsg:SuccessSignUp] duration:2.0f completion:nil];
    }];
    
}

- (void)failSignUp {
    
    [KSToastView ks_showToast:[self.singleTone toastMsg:ExistEmailAddress] duration:2.0f completion:nil];
    
}

- (IBAction)cancelSignUp:(id)sender {
    
    [self.currentTextField endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 키보드 내려가고 0.3초후에 회원가입 페이지 종료
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    
}

@end
