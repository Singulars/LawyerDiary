//
//  ChooseClient.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 22/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "ChooseClient.h"
#import "CaseClientCell.h"
#import "ChooseCourt.h"

@interface ChooseClient ()
{
    NSIndexPath *previusSelectedIndexPath;
}
@property (nonatomic, strong) NSArray *arrClients;
@end

@implementation ChooseClient

@synthesize arrClients;
@synthesize existingClientObj;
@synthesize existingAdminObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];

    [lblErrorMsg setHidden:YES];
    
    [lblErrorMsg setTextColor:DARK_GRAY_COLOR];

    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 44, 0, 0)];
    
    if (existingAdminObj)
    {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setBackBarButtonItem:[Global hideBackBarButtonTitle]];
        
        arrClients = [Client fetchClientsForAdmin:existingAdminObj.adminId];
    }
    
    if (arrClients.count == 0) {
        [self.tableView setHidden:YES];
        
        [lblErrorMsg setText:@"No Clients to show!\nEiethr no clients added or not fetched from server."];
        [lblErrorMsg setHidden:NO];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    
    if (_delegate) {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        
        for (int i = 0; i < arrClients.count; i++) {
            Client *objClient = arrClients[i];
            if ([objClient.clientId isEqualToNumber:existingClientObj.clientId]) {
                previusSelectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrClients.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CaseClientCell";
    CaseClientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CaseClientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (existingClientObj != nil) {
        [cell setSelectedClientId:existingClientObj.clientId];
    }
    
    [cell configureCellWithClientObj:arrClients[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    existingClientObj = arrClients[indexPath.row];
    
    NSMutableArray *toBeReloadIndexPaths = [[NSMutableArray alloc] init];
    [toBeReloadIndexPaths addObject:indexPath];
    
    if (previusSelectedIndexPath != nil && previusSelectedIndexPath.row != indexPath.row) {
        [toBeReloadIndexPaths addObject:previusSelectedIndexPath];
    }
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:toBeReloadIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    previusSelectedIndexPath = indexPath;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        //        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)barBtnCancelTaped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)barBtnNextTaped:(id)sender
{
    if (_delegate) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(clientSelected:)]) {
            [_delegate clientSelected:existingClientObj];
        }
    }
    else {
        ChooseCourt *courtVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseCourt"];
        [courtVC setExistingClientObj:existingClientObj];
        [self.navigationController pushViewController:courtVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
