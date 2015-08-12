//
//  ChooseSubordinates.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 09/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "ChooseAdmin.h"
#import "ChooseAdminCell.h"
#import "CourtDetail.h"

@interface ChooseAdmin ()
{
    NSIndexPath *previusSelectedIndexPath;

}
@property (nonatomic, strong) NSArray *arrAdmin;

@end

@implementation ChooseAdmin
@synthesize existingAdminObj;
@synthesize arrAdmin;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    [self setTitle:@"Select Admin"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];
    
    [lblErrorMsg setHidden:YES];
    
    [lblErrorMsg setTextColor:DARK_GRAY_COLOR];
    
    arrAdmin = [SubordinateAdmin fetchSubordinateAdmins];
    NSLog(@"%@",arrAdmin);
    if (arrAdmin.count == 0) {
        [self.tableView setHidden:YES];
        
        [lblErrorMsg setText:@"Non of the Admin has not added you as their Subordinate!"];
        [lblErrorMsg setHidden:NO];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    
    if (_delegate) {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        
        for (int i = 0; i < arrAdmin.count; i++) {
            SubordinateAdmin *objClient = arrAdmin[i];
            if ([objClient.adminId isEqualToNumber:existingAdminObj.adminId]) {
                previusSelectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }
        }
    }

    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.navigationItem setBackBarButtonItem:[Global hideBackBarButtonTitle]];

    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAdmin.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChooseAdminCell";
    ChooseAdminCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ChooseAdminCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (existingAdminObj != nil) {
        [cell setSelectedClientId:existingAdminObj.adminId];
    }
    
    [cell configureCellWithAdminObj:arrAdmin[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubordinateAdmin *adminObj = arrAdmin[indexPath.row];
    
    if ([adminObj.hasAccess isEqualToNumber:@1]) {
        existingAdminObj = arrAdmin[indexPath.row];
        
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
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (IBAction)barBtnNextTaped:(id)sender
{
    if (existingAdminObj == nil) {
        MY_ALERT(nil, @"Please select Admin you want to add record.", nil);
    }
    else {
        
        CourtDetail *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtDetail"];
        [detailVC setIsForSubordinate:YES];
        [detailVC setExistingAdminObj:existingAdminObj];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)barBtnCancelTaped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
