//
//  MainTableViewController.m
//  Hoomi
//
//  Created by Jyo on 2016. 7. 5..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "MainTableViewController.h"
#import "JobSelectViewController.h"
#import "ImageListTableViewCell.h"

@interface MainTableViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic) NSMutableDictionary *imageData;
@property (nonatomic) NSArray *jobList;
@property (nonatomic, weak) UIPickerView *jobPicker;
@property (nonatomic, weak) NSString *selectedJob;
@property (nonatomic, strong) UIView *jobSelectCustomView;

@property (nonatomic) NSUserDefaults *defaults;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self selectJobList];
    
    self.jobPicker.delegate = self;
    self.jobPicker.dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadServerData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    self.jobList = [NSArray arrayWithObjects:@"Photograper",@"Programmer", @"Editor", @"Writer",nil];
    
    self.imageData = [[NSMutableDictionary alloc] init];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    if([[self.defaults objectForKey:@"userJob"] isEqualToString:@""]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self selectJobList];
            
        });
        
    }
    
    
    
    [self.imageData setObject:@"nature.jpg" forKey:@"image_01"];
    [self.imageData setObject:@"nature1.jpg" forKey:@"image_02"];
    
    
    self.title = @"HOOMI";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.94 green:0.51 blue:0.44 alpha:1.00]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor dargra]]
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.imageData count];
}

- (void)selectJobList {
    
    
    // 뷰컨트롤러 뒷배경 블러처리
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    
    effectView.frame = self.view.frame;
    [self.view addSubview:effectView];
    
    
    
    // 직군선택화면을 새로운 뷰컨트롤러에서 표시
    /*
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JobSelectViewController *jobSelect = [storyBoard instantiateViewControllerWithIdentifier:@"SelectJob"];
    
    [self presentViewController:jobSelect animated:YES completion:nil];
    */
    
    // 직군선택화면을 현재뷰에서 커스텀뷰로 만들어서 표시
    NSInteger margin = 60;
    UIView *jobSelectCustomView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - margin, margin * 5)];
    [jobSelectCustomView setBackgroundColor:[UIColor whiteColor]];
    [jobSelectCustomView setCenter:CGPointMake(self.view.frame.size.width  / 2,
                                               self.view.frame.size.height / 2 - self.navigationController.navigationBar.frame.size.height)];
    
    jobSelectCustomView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    jobSelectCustomView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    jobSelectCustomView.layer.borderWidth = 3.0f;
    
    self.jobSelectCustomView = jobSelectCustomView;
    
    
    // jobSelectCustomView에 PickerView 추가
    UIPickerView *jobPicker = [[UIPickerView alloc] init];
    [jobPicker setFrame:CGRectMake(0, 0, jobSelectCustomView.frame.size.width, jobSelectCustomView.frame.size.height - margin * 2)];
//    [jobPicker setBackgroundColor:[UIColor darkGrayColor]];
    [jobSelectCustomView addSubview:jobPicker];
    self.jobPicker = jobPicker;
    
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton setFrame:CGRectMake(30, jobPicker.frame.size.height + 30, jobSelectCustomView.frame.size.width - 60, 45)];
    [selectButton addTarget:self action:@selector(selectUserJob) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger cornerRadius = 3;
    BOOL clipsToBounds = YES;
    CGFloat buttonTitleFont = 15.f;
    
    selectButton.layer.cornerRadius = cornerRadius;
    selectButton.clipsToBounds = clipsToBounds;
    [selectButton setBackgroundColor:[UIColor colorWithRed:0.94 green:0.51 blue:0.44 alpha:1.00]];
    [selectButton setTitle:@"등록" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton setFont:[UIFont boldSystemFontOfSize:buttonTitleFont]];
    
    [jobSelectCustomView addSubview:selectButton];
    
    [self.view addSubview:jobSelectCustomView];
    
    
}

- (void)selectUserJob {
    
    [self.defaults setObject:self.selectedJob forKey:@"userJob"];
    
    [self.jobSelectCustomView removeFromSuperview];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *allKey = [self.imageData allKeys];
    NSString *key = [allKey objectAtIndex:indexPath.row];
    
    cell.image.image = [UIImage imageNamed:[self.imageData objectForKey:key]];
    cell.label.text = key;
    [cell.label setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor blackColor]];

    
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select cell");
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadServerData:(UIRefreshControl *)refreshControl {
    
        NSLog(@"load server data");
    [refreshControl endRefreshing];
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.jobList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return [self.jobList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    self.selectedJob = [self.jobList objectAtIndex:row];
    NSLog(@"selectedJob : %@", self.selectedJob);
    
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
