//
//  MyPageTableViewController.m
//  Hoomi
//
//  Created by 이은경 on 2016. 7. 5..
//  Copyright © 2016년 Jyo. All rights reserved.
//

#import "MyPageTableViewController.h"
#import "MyPageListTableViewCell.h"
#import "NetworkObject.h"
#import "Singletone.h"
#import "DetailResumeViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyPageTableViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableDictionary *listData;
@property (nonatomic) NSArray *formList;
@property (nonatomic) NSArray *infoImageNames;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, weak) UIPickerView *formPicker;
@property (nonatomic, weak) NSString *seletedForm;

@property (nonatomic, strong) UIView *formSelectCustomView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic) NSUserDefaults *defaults;

@property (nonatomic) Singletone *singleTone; // 싱글톤 객체
@property (nonatomic) NetworkObject *networkObject;
@property (nonatomic, weak) NSString *token;

@property (nonatomic) NSMutableArray *myContentDataArray;
@property (nonatomic) NSMutableArray *imageDataArray;
@property (nonatomic) NSMutableArray *hashIDArray;

@property (nonatomic, strong) NSString *userInfoName;


@end

@implementation MyPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //비동기통신으로 인한 옵져버등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoad) name:UserInfoListNotification object:nil];
    
    
    /* 네트워크 테스트 */
    self.singleTone = [Singletone requestInstance];
    self.networkObject = [NetworkObject requestInstance];
    [self.networkObject requestMypage];
    
    /*임포트 네트워크오브젝트를 객체로 만든것*/
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.view addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //마이페이지 로드(내글목록)
    
//    self.listData = [[NSMutableDictionary alloc] init];
//    
//    [self.listData setObject:@"nature11.jpg" forKey:@"image_01"];
//    [self.listData setObject:@"nature22.jpg" forKey:@"image_02"];
//    [self.listData setObject:@"nature33.jpg" forKey:@"image_03"];
//    [self.listData setObject:@"nature44.jpg" forKey:@"image_04"];
    
    self.infoImageNames = @[@"NeutralUser-1.png", @"NewPost-1.png", @"EmployeeCard-1.png"];
    
}

-(void)successLoad {

    NSLog(@"😬 %@", self.networkObject.userInfoJSONArray);
    NSLog(@"😬 %@", self.networkObject.myContentListJSONArray);
    
    NSArray *userinfoList = self.networkObject.userInfoJSONArray;
    NSString *firstName = [[userinfoList objectAtIndex:0] objectAtIndex:0];
    NSString *lastName = [[userinfoList objectAtIndex:1] objectAtIndex:0];
    NSString *name = [firstName stringByAppendingString:lastName];
   
    NSLog(@"😇name - %@", name);
    self.userInfoName = name;
    NSLog(@"😇userInfoName - %@", self.userInfoName);
    
    self.myContentDataArray = [[NSMutableArray alloc] init];
    self.imageDataArray = [[NSMutableArray alloc] init];
    self.hashIDArray = [[NSMutableArray alloc] init];
    
    NSArray *myList = [self.networkObject myContentListJSONArray];
    
    NSLog(@"😍---- %@", myList);
    
    for (NSInteger i = 0; i < [myList count]; i++) {
        NSLog(@"😇index - %@", [myList objectAtIndex:i]);
        
        NSString *content = [[myList objectAtIndex:i] objectForKey:@"content"];
        NSLog(@"😇content - %@", content);
        NSString *imageUrl = [[myList objectAtIndex:i] objectForKey:@"image"];

        [self.myContentDataArray addObject:content];
        [self.imageDataArray addObject:imageUrl];
        
    }
    
    NSLog(@"contentData : %@", self.myContentDataArray);
    NSLog(@"imageData : %@", self.imageDataArray);

    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

- (void)loadMyContentDataList {
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [self.tableView reloadData];
//    });


}


-(void) refreshTable {
    //TODO: refresh your data
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
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
    
    if (section == 0) {
        return 3;
    }
  //서버에서 보내주는 이력서 수 카운트
    return [self.myContentDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        
        NSString *imageName = [self.infoImageNames objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        //userinfoview - 이름/이메일/직업 받아온다
        if(indexPath.row ==0) {
            cell.textLabel.text = self.userInfoName;
            
        } else if(indexPath.row == 1) {
            cell.textLabel.text = [[self.networkObject.userInfoJSONArray objectAtIndex:2] objectAtIndex:0];
        } else if(indexPath.row == 2) {
            cell.textLabel.text = [[self.networkObject.userInfoJSONArray objectAtIndex:3] objectAtIndex:0];
        }
        
        return cell;
    } else {
        
        // 내글 목록을 받아온다
        static NSString *Cell = @"Cell";
        
        MyPageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
        
        cell.label.text = [self.myContentDataArray objectAtIndex:indexPath.row];
        [cell.label setTextColor:[UIColor whiteColor]];
        //    [cell.label setFont:[UIFont fontWithName:@"HUDStarNight140" size:20.0f]];
        
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[self.imageDataArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"default-placeholder.png"]];
    
        return cell;
    }
    return 0;
}

//내글목록 셀 터치시 디테일뷰 이동
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select cell");
    
    [self.singleTone setHashID:[self.hashIDArray objectAtIndex:indexPath.row]];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Cheese" bundle:nil];
    DetailResumeViewController *detailResume = [storyBoard instantiateViewControllerWithIdentifier:@"DetailResume"];
    [self presentViewController:detailResume animated:YES completion:nil];
    
}



// 마이페이지 - 게시물(셀) 삭제
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.myContentDataArray removeObject:@"experiences"];
        [tableView reloadData];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.f;
    }
    return 140.f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
