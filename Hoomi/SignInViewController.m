//
//  SignInViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 6. 30..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SignInViewController.h"
#import "SingUpTableViewController.h"


@interface SignInViewController ()
<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *userIDTextfield;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextfield;

@property (nonatomic) NSNotificationCenter *notificationCenter;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    [self customTextField:self.userIDTextfield];
    [self customTextField:self.passwordTextfield];
    
    self.userIDTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    [self.notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:@"keyboardToolbar" object:self.view.window];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    [self.notificationCenter postNotificationName:@"keyboardToolbar" object:self.view.window];
}

- (void)keyboardWillShow:(NSNotification *) noti {
    
        NSLog(@"userIDTextfield");
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height)];
        }];
    
    
    NSLog(@"show keyboard");
    
}

/**
 *  로그인 버튼을 클릭했을 때 실행되는 메소드
 *
 *  @param sender nil
 */
- (IBAction)signInAction:(id)sender {
    
    // 로그인 AlertController 추가
    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"로그인" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"아이디를 입력해주세요."];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"비밀번호를 입력해주세요."];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setSecureTextEntry:YES];
    }];
    
    UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"로그인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *userID = [[alertController textFields] firstObject].text;
        NSString *userPassword = [[alertController textFields] lastObject].text;
        
        NSLog(@"userID : %@, userPassword : %@", userID, userPassword);
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:signInAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
     */
    
   
}

- (IBAction)signUpAction:(id)sender {
    
    SingUpTableViewController *signUpView = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpPage"];
    
    [self presentViewController:signUpView animated:YES completion:nil];
    
}

- (void)customTextField:(UITextField *)textField {
    
    [textField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [textField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [textField.layer setBorderWidth: 1.0];
    [textField.layer setCornerRadius:5.0f];
    [textField.layer setMasksToBounds:YES];
    
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
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
