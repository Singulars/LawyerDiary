//
//  ChooseCourt.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 23/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "ChooseCourt.h"
#import "CaseCourtCell.h"
#import "EditCase.h"

@interface ChooseCourt ()
{
    NSIndexPath *previusSelectedIndexPath;
}
@property (nonatomic, strong) NSArray *arrCourts;
@end

@implementation ChooseCourt

@synthesize arrCourts;
@synthesize existingClientObj;
@synthesize existingCourtObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblErrorMsg setHidden:YES];
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    arrCourts = [Court fetchCourts:USER_ID];
    
    if (arrCourts.count == 0) {
        [self.tableView setHidden:YES];
        
        [lblErrorMsg setText:@"No Courts to show!\nEiethr no courts added or not fetched from server."];
        [lblErrorMsg setHidden:NO];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    
    if (_delegate) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        
        for (int i = 0; i < arrCourts.count; i++) {
            Court *objCourt = arrCourts[i];
            if ([objCourt.courtId isEqualToNumber:existingCourtObj.courtId]) {
                previusSelectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }
        }
    }
    
    [self.navigationItem setBackBarButtonItem:[Global hideBackBarButtonTitle]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCourts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CaseCourtCell";
    CaseCourtCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CaseCourtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (existingCourtObj != nil) {
        [cell setSelectedCourtId:existingCourtObj.courtId];
    }
    
    [cell configureCellWithCourtObj:arrCourts[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    existingCourtObj = arrCourts[indexPath.row];
    
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

- (IBAction)barBtnNextTaped:(id)sender
{
    if (_delegate) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(courtSelected:)]) {
            [_delegate courtSelected:existingCourtObj];
        }
    }
    else {
        EditCase *editCaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCase"];
        [editCaseVC setExistingClientObj:existingClientObj];
        [editCaseVC setExistingCourtObj:existingCourtObj];
        [self.navigationController pushViewController:editCaseVC animated:YES];
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
