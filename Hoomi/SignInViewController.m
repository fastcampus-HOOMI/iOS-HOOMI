//
//  SignInViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 6. 30..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "SignInViewController.h"
#import "SingUpTableViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
        
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 *  로그인 버튼을 클릭했을 때 실행되는 메소드
 *
 *  @param sender nil
 */
- (IBAction)signInAction:(id)sender {
    
    // 로그인 AlertController 추가
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

}

- (IBAction)signUpAction:(id)sender {
    
    SingUpTableViewController *signUpView = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpPage"];
    
    [self presentViewController:signUpView animated:YES completion:nil];
    
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
