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

@end

@implementation MyPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 네트워크 테스트 */
    self.singleTone = [Singletone requestInstance];
    self.networkObject = [NetworkObject requestInstance];
    /*임포트 네트워크오브젝트를 객체로 만든것*/
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.view addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //마이페이지 로드(내글목록)
    [self.networkObject requestMypage];
    
    
//    self.listData = [[NSMutableDictionary alloc] init];
//    
//    [self.listData setObject:@"nature11.jpg" forKey:@"image_01"];
//    [self.listData setObject:@"nature22.jpg" forKey:@"image_02"];
//    [self.listData setObject:@"nature33.jpg" forKey:@"image_03"];
//    [self.listData setObject:@"nature44.jpg" forKey:@"image_04"];
    
    
    
    self.infoImageNames = @[@"NeutralUser-1.png", @"NewPost-1.png", @"EmployeeCard-1.png"];
    
}

- (void)loadMyContentDataList {
    
    self.myContentDataArray = [[NSMutableArray alloc] init];
    self.imageDataArray = [[NSMutableArray alloc] init];
    self.hashIDArray = [[NSMutableArray alloc] init];
    
    NSArray *myList = [self.networkObject myContentListJSONArray];
    
    for (NSInteger i = 0; i < [myList count]; i++) {
        NSDictionary *dic = [myList objectAtIndex:i];
        NSArray *experiences = [dic objectForKey:@"experiences"];
        
        [self.hashIDArray addObject:[dic objectForKey:@"hash_id"]];
        
        NSString *content = [[experiences objectAtIndex:0] objectForKey:@"content"];
        NSString *imageUrl = [[experiences objectAtIndex:0] objectForKey:@"image"];
        
        [self.myContentDataArray addObject:content];
        [self.imageDataArray addObject:imageUrl];
        
    }
    NSLog(@"contentData : %@", self.myContentDataArray);
    NSLog(@"imageData : %@", self.imageDataArray);
    NSLog(@"hash_id : %@", self.hashIDArray);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });

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
    return [[self.networkObject myContentListJSONArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        
        NSString *imageName = [self.infoImageNames objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        
        if(indexPath.section == 0) {
            if(indexPath.row ==0) {
                cell.textLabel.text = @"지호";
            } else if(indexPath.row == 1) {
                cell.textLabel.text = @"najanda89@gmail.com";
            } else if(indexPath.row == 2) {
                cell.textLabel.text = @"Photographer";
            }
        }
        
        return cell;
    }
    
    
    MyPageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    // null해결후 수정할것
    NSArray *allKey = [self.listData allKeys];
    NSString *key = [allKey objectAtIndex:indexPath.row];
    
    cell.image.image = [UIImage imageNamed:[self.listData objectForKey:key]];
    cell.label.text = key;
    [cell.label setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}

// 마이페이지 - 게시물(셀) 삭제
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.listData removeObjectForKey:(@"image_01")];
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
