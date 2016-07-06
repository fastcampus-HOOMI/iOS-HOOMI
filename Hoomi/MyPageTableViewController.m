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

@property (nonatomic) NSMutableDictionary *listData;

@end

@implementation MyPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

// +버튼 누를시, alert창

-(IBAction)clickAddButton:(id)sender{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form 추가"
                                                                    message:@"form을 추가 하시겠습니까"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * formOneAction = [UIAlertAction actionWithTitle:@"Form 1"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               NSLog(@"Alert Form 1");
                                                           }];
    
    UIAlertAction * formTwoAction = [UIAlertAction actionWithTitle:@"Form 2"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               NSLog(@"Alert Form 2");
                                                           }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       NSLog(@"cancel");
                                                   }];
    
    [alert addAction:formOneAction];
    [alert addAction:formTwoAction];
    [alert addAction:cancel];
                                                            
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
    //서버에서 보내주는 이력서 수 카운트로 변경할것(현재 서버 미완성)
    return [self.listData count];
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
