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
@property (nonatomic) NSMutableArray *giveHashIDArray;


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
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.view addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //상단 user info 테이블에 보여질 이미지
    self.infoImageNames = @[@"NeutralUser-1.png", @"NewPost-1.png", @"job_1.png"];
    
}

-(void)successLoad {
    
    NSLog(@"😬 %@", self.networkObject.userInfoJSONArray);
    NSLog(@"😬contentlistarray %@", self.networkObject.myContentListJSONArray);
    
    NSArray *userinfoList = self.networkObject.userInfoJSONArray;
    NSString *firstName = [userinfoList objectAtIndex:0];
    NSString *lastName = [userinfoList objectAtIndex:1];
    
    //lastName + firstName 합쳐서 보여주기 위해. 성과 이름은 띄어쓴다
    NSString *name = [lastName stringByAppendingString:[@" " stringByAppendingString:firstName]];
    self.userInfoName = name;
    //NSLog(@"😇userInfoName - %@", self.userInfoName);
    
    self.myContentDataArray = [[NSMutableArray alloc] init];
    self.imageDataArray = [[NSMutableArray alloc] init];
    self.hashIDArray = [[NSMutableArray alloc] init];
    self.giveHashIDArray = [[NSMutableArray alloc] init];
    
    
    NSArray *myList = [self.networkObject myContentListJSONArray];
    NSLog(@"😍---- %@", myList);
    
    NSInteger myListCount = [myList count];
    
    for (NSInteger i = 0; i < myListCount; i++) {
        
        //목록에서 detail view로 넘어가려면 글마다 있는 hash_id 필요
        NSString *hashID = [[myList objectAtIndex:i] objectForKey:@"hash_id"];
        [self.hashIDArray addObject:[hashID stringByAppendingString:@"/"]];
        [self.giveHashIDArray addObject:hashID];
        ////        NSLog(@"😇hashID --- %@", hashID);
        
        NSArray *experiences = [[myList objectAtIndex:i] objectForKey:@"experiences"];
        NSInteger experiencesCount = [experiences count];
        NSLog(@"😍experiences---- %@", experiences);
        for (NSInteger j = 0; j < experiencesCount; j++) {
            
            NSInteger pageNum = [[[experiences objectAtIndex:j] objectForKey:@"page"] integerValue];
            
            //내가 쓴 글중 첫번쨰 페이지(page=1)만 노출되게한다.
            if (pageNum == 1) {
                
                NSString *content = [[experiences objectAtIndex:j] objectForKey:@"content"];
                NSLog(@"😇content - %@", content);
                NSString *imageUrl = [[experiences objectAtIndex:j] objectForKey:@"image"];
                NSLog(@"😇content - %@", imageUrl);
                
                [self.myContentDataArray addObject:content];
                [self.imageDataArray addObject:imageUrl];

            }
            
        }
        
        NSLog(@"contentDataCheck : %@", self.myContentDataArray);
        NSLog(@"imageDataCheck : %@", self.imageDataArray);
        NSLog(@"hashIDCheck : %@", self.hashIDArray);

    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}


-(void) refreshTable {
    //TODO: refresh your data
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
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
    //section == 1(내글목록) 에서는 서버에서 보내주는 이력서 수 카운트
    return [self.myContentDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        
        NSString *imageName = [self.infoImageNames objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        //userinfo view - 이름/이메일/직업 받아온다
        if(indexPath.row ==0) {
            cell.textLabel.text = self.userInfoName;
            
        } else if(indexPath.row == 1) {
            cell.textLabel.text = [self.networkObject.userInfoJSONArray objectAtIndex:2];
        } else if(indexPath.row == 2) {
            cell.textLabel.text = [self.networkObject.userInfoJSONArray objectAtIndex:3];
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
    
}

//내글목록 셀 터치시 디테일뷰 이동
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select cell");
    
    //userinfo section은 셀 터치시 이동이 되지 않게함.
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }else{
    
    [self.singleTone setHashID:[self.giveHashIDArray objectAtIndex:indexPath.row]];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Cheese" bundle:nil];
    DetailResumeViewController *detailResume = [storyBoard instantiateViewControllerWithIdentifier:@"DetailResume"];
        [self presentViewController:detailResume animated:YES completion:nil];
    
    }
    
}



// 마이페이지 - 내글목록 게시물(셀) 삭제
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        [self.myContentDataArray removeObjectAtIndex:indexPath.row];
        [self.imageDataArray removeObjectAtIndex:indexPath.row];
       [self.networkObject deleteMypage:[self.hashIDArray objectAtIndex:indexPath.row]];
        
        [tableView reloadData];
    }

}

//내글 목록 ui들
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return 48.0f;
        
    }else{
    
        return 112.f;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
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
