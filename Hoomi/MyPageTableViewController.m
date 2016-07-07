//
//  MyPageTableViewController.m
//  Hoomi
//
//  Created by 이은경 on 2016. 7. 5..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "MyPageTableViewController.h"
#import "MyPageListTableViewCell.h"

@interface MyPageTableViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSMutableDictionary *listData;
@property (nonatomic) NSArray *myData;
@property (nonatomic) NSArray *formList;

@property (nonatomic, weak) UIPickerView *formPicker;
@property (nonatomic, weak) NSString *seletedForm;

@property (nonatomic, strong) UIView *formSelectCustomView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic) NSUserDefaults *defaults;

@end

@implementation MyPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myData = [NSArray arrayWithObjects:@"이름",@"이메일", @"직군",nil];
    
    self.listData = [[NSMutableDictionary alloc] init];
    
    [self.listData setObject:@"nature11.jpg" forKey:@"image_01"];
    [self.listData setObject:@"nature22.jpg" forKey:@"image_02"];
    [self.listData setObject:@"nature33.jpg" forKey:@"image_03"];
    [self.listData setObject:@"nature44.jpg" forKey:@"image_04"];
    
    
    
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// +버튼 클릭시 커스텀 alert창
- (IBAction)selectFormList {
    
    NSInteger cornerRadius = 3;
    BOOL clipsToBounds = YES;
    CGFloat buttonTitleFont = 15.f;
    
    //뒷배경 블러처리
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    effectView.frame = self.view.frame;
    self.effectView = effectView;
    [self.view addSubview:effectView];
    
    //form선택화면을 커스텀alert으로
    NSInteger margin = 60;
    UIView *formSelectCustomView = [[UIView alloc] initWithFrame:CGRectMake(margin / 2, - margin * 5, self.view.frame.size.width - margin, margin * 5)];
//    [formSelectCustomView setCenter:CGPointMake(self.view.frame.size.width  / 2,
//                                               self.view.frame.size.height / 2 - self.navigationController.navigationBar.frame.size.height)];
    formSelectCustomView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    formSelectCustomView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    formSelectCustomView.layer.borderWidth = 3.0f;
    
    
    //formSelectCustomView에 picker View 추가
    UIPickerView *formPicker = [[UIPickerView alloc] init];
    [formPicker setFrame:CGRectMake(0, 0, formSelectCustomView.frame.size.width, formSelectCustomView.frame.size.height - margin * 2)];
    self.formPicker = formPicker;
    
    self.formPicker.delegate = self;
    self.formPicker.dataSource = self;
    
    [formSelectCustomView addSubview:formPicker];
    

    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(30, formPicker.frame.size.height + 30, formSelectCustomView.frame.size.width - 60, 45)];
    [selectButton addTarget:self action:@selector(selectForm) forControlEvents:UIControlEventTouchUpInside];
    selectButton.layer.cornerRadius = cornerRadius;
    selectButton.clipsToBounds = clipsToBounds;
    [selectButton setBackgroundColor:[UIColor colorWithRed:0.94 green:0.51 blue:0.44 alpha:1.00]];
    [selectButton setTitle:@"등록" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton setFont:[UIFont boldSystemFontOfSize:buttonTitleFont]];
    
    [formSelectCustomView addSubview:selectButton];
    
    self.formSelectCustomView = formSelectCustomView;
    self.formPicker = formPicker;
    self.formList = [NSArray arrayWithObjects:@"Photograper",@"Programmer", @"Writer",nil];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.formSelectCustomView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - self.navigationController.navigationBar.frame.size.height)];
        [self.view addSubview:self.formSelectCustomView];
    } completion:^(BOOL finished) {
        
    }];

}


#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.formList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.formList objectAtIndex:row];
}


- (void)selectForm {
    
    [self.defaults setObject:self.seletedForm forKey:@"myForm"];
    
    [self.formSelectCustomView removeFromSuperview];
    [self.effectView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 3;
    }else{
    //서버에서 보내주는 이력서 수 카운트로 변경할것(현재 서버 미완성)
    return [self.listData count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *allKey = [self.listData allKeys];
    NSString *key = [allKey objectAtIndex:indexPath.row];
    
    cell.image.image = [UIImage imageNamed:[self.listData objectForKey:key]];
    cell.label.text = key;
    [cell.label setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor blackColor]];
    
    return cell;
}

// 마이페이지 - 게시물(셀) 삭제
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.listData removeObjectForKey:(@"image_01")];
        [tableView reloadData];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
