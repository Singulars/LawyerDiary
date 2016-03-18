//
//  Search.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 31/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "Search.h"
#import "CaseCell.h"
#import "EditCase.h"
#import "UpdateCase.h"

BOOL isForSubordinate;

@interface Search () <SWTableViewCellDelegate>
{
    NSPredicate *filterPredicateTerm;
}
@end

@implementation Search

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:18 andStrokeColor:CLEARCOLOUR]];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 44, 0, 0)];
    
    [_searchBar setScopeBarBackgroundImage:[UIImage imageWithColor:GROUP_TABLEVIEW_COLOR]];
}

-(void)viewWillAppear:(BOOL)animated
{
    arrCases = [[NSMutableArray alloc]init];
    [arrCases addObjectsFromArray:[Cases fetchCases:USER_ID]];
    
    filteredCasesArray = arrCases;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
    //    self.originalFrame = viewAddCourt.frame;
}

#pragma Mark NavigationBar Butoon action

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    [self.searchBar resignFirstResponder];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CaseCell";
    CaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[CaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDelegate:self];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:44];
    [cell configureCellWithCaseObj:filteredCasesArray[indexPath.row] forIndexPath:indexPath];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filteredCasesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cases *caseObj = arrCases[indexPath.row];
    if ([caseObj.isSubordinate isEqualToNumber:@1]) {
        isForSubordinate = YES;
    }
    else {
        isForSubordinate = NO;
    }
    
    UpdateCase *updateCaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateCase"];
    [updateCaseVC setExistingCaseObj:caseObj];
    [self.navigationController pushViewController:updateCaseVC animated:YES];
    
    //    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtDetail"];
    //    CourtDetail *courtDetailVC = navController.viewControllers[0];
    //    [courtDetailVC setCourtObj:arrCourts[indexPath.row]];
    //    [self.navigationController pushViewController:courtDetailVC animated:YES];
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

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:WHITE_COLOR icon:IMAGE_WITH_NAME(IMG_edit_icon)];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:WHITE_COLOR icon:IMAGE_WITH_NAME(IMG_trash_icon)];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    @try {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Cases *caseObj = arrCases[indexPath.row];
        switch (index) {
            case 0:
            {
                NSLog(@"More button was pressed");
                
                EditCase *editCaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCase"];
                
                if ([caseObj.isSubordinate isEqualToNumber:@1]) {
                    isForSubordinate = YES;
                    [editCaseVC setExistingAdminObj:[SubordinateAdmin fetchSubordinateAdmin:caseObj.adminId]];
                }
                else {
                    isForSubordinate = NO;
                }
                
                [editCaseVC setExistingCaseObj:caseObj];
                [editCaseVC setExistingClientObj:[Client fetchClientLocally:caseObj.localClientId]];
                [editCaseVC setExistingCourtObj:[Court fetchCourtLocally:caseObj.localCourtId]];
                
                [self.navigationController pushViewController:editCaseVC animated:YES];
                
                [cell hideUtilityButtonsAnimated:YES];

                break;
            }
            case 1:
            {
                // Delete button was pressed
                
                if ([caseObj.isSubordinate isEqualToNumber:@1]) {
                    
                    SubordinateAdmin *adminObj = [SubordinateAdmin fetchSubordinateAdmin:caseObj.adminId];
                    
                    if ([adminObj.hasAccess isEqualToNumber:@1]) {
                        [self.tableView beginUpdates];
                        
                        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                        [Cases updatedCasePropertyofCase:caseObj withProperty:kCaseIsDeleted andValue:@1];
                        [self deleteCase:caseObj forAdmin:adminObj];
                        
                        [arrCases removeAllObjects];
                        [arrCases addObjectsFromArray:[Cases fetchCasesForSubordinate]];
                        [self.tableView endUpdates];
                        
                    }
                    else {
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        UI_ALERT(@"Warning", @"You don't have access to perform this operation.", nil);
                    }
                }
                else {
                    switch (ShareObj.fetchSubordinateStatus) {
                        case kStatusUndetermined: {
                            UI_ALERT(@"", @"The status of given access to subordinate is undermined yet.\nSo, you can not modify any records.", nil);
                        }
                            break;
                        case kStatusFailed: {
                            UI_ALERT(@"", @"The approach to get status of access failed somehow.\nSo, you can not modify any records.", nil);
                        }
                            break;
                        case kStatusFailedBecauseInternet: {
                            UI_ALERT(@"", @"The approach to get status of access failed because of internert inavailability.\nSo, you can not modify any records.", nil);
                        }
                            break;
                        case kStatusSuccess: {
                            if (ShareObj.hasAdminAccess) {
                                [self.tableView beginUpdates];
                                
                                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                                [Cases updatedCasePropertyofCase:arrCases[indexPath.row] withProperty:kCaseIsDeleted andValue:@1];
                                [self deleteCase:arrCases[indexPath.row]];
                                [arrCases removeObjectAtIndex:indexPath.row];
                                
                                [self.tableView endUpdates];
                            }
                            else {
                                UI_ALERT(@"", @"You have given access to one of your subordinate.\nSo, you can not modify any records.", nil);
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
            default:
                break;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

- (void)deleteCase:(Cases *)objCase
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kdeleteCase,
                                     kAPIuserId: USER_ID,
                                     kAPIcaseId: objCase.caseId
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:@"Case can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"Case can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        [Cases deleteCase:objCase.caseId];
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Global showNotificationWithTitle:@"Case can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        //        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

- (void)deleteCase:(Cases *)objCase forAdmin:(SubordinateAdmin *)adminObj
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kdeleteCase,
                                     kAPIuserId: USER_ID,
                                     kAPIcourtId: objCase.caseId,
                                     kAPIadminId: adminObj.adminId
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:@"Case can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"Case can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        [Cases deleteCase:objCase.caseId];
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Global showNotificationWithTitle:@"Case can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        //        [Global showNotificationWithTitle:@"Court will be delted from server, when you get online." titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        //        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0) {
        filteredCasesArray = arrCases;
    }
    else {
        switch (searchBar.selectedScopeButtonIndex) {
            case 0: {
                filterPredicateTerm = [NSPredicate predicateWithFormat:@"clientFirstName CONTAINS[c] %@", searchText];
            }
                break;
            case 1: {
                filterPredicateTerm = [NSPredicate predicateWithFormat:@"courtName CONTAINS[c] %@", searchText];
            }
                break;
            case 2: {
                filterPredicateTerm = [NSPredicate predicateWithFormat:@"caseNo CONTAINS[c] %@", searchText];
            }
                break;
            case 3: {
                
                
            }
                break;
            default:
                break;
        }
        
        filteredCasesArray = [arrCases filteredArrayUsingPredicate:filterPredicateTerm];
        NSLog(@"%@", filteredCasesArray);
    }
    
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    NSString *placeholder;
    switch (selectedScope) {
        case 0: {
            placeholder = @"Seach Cases by Client Name";
        }
            break;
        case 1: {
            placeholder = @"Seach Cases by Lawyer Name";
        }
            break;
        case 2: {
            placeholder = @"Seach Cases by Case No.";
        }
            break;
        case 3: {
            placeholder = @"Seach Cases by Case Next Hearing Date";
        }
            break;
        default:
            break;
    }
    
    [_searchBar setPlaceholder:placeholder];
    
    NSArray *searchBarSubViews = [[self.searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *view in searchBarSubViews) {
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField* search=(UITextField*)view;
            
            if (selectedScope == 3) {
                [search setInputView:datePicker];
            }
            else {
                [search setInputView:nil];
            }
        }
    }
    [self.searchBar reloadInputViews];
    [self.searchBar becomeFirstResponder];
    
    [_searchBar setText:@""];
}

- (IBAction)datePickerValueChanged:(id)sender
{
    [_searchBar setText:[Global getDateStringFromDate:[Global getDateWithoutSeconds:datePicker.date] ofFormat:DefaultBirthdateFormat]];
    
    NSString *dateText = [Global getDateStringOfFormat:kServerDateTimeFormat fromDateString:_searchBar.text ofFormat:DefaultBirthdateFormat];

    NSArray *dateArr = [dateText componentsSeparatedByString:@" "];
    
    filterPredicateTerm = [NSPredicate predicateWithFormat:@"nextHearingDate = %@", dateArr[0]];
    
    filteredCasesArray = [arrCases filteredArrayUsingPredicate:filterPredicateTerm];
    [self.tableView reloadData];
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
