//
//  Subordinates.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 05/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "Subordinates.h"
#import "Subordinate.h"
#import "SubordinateCell.h"
#import "AddSubordinate.h"


@interface Subordinates () <SWTableViewCellDelegate>
{
    Subordinate *objWhoHasAccess;
}

@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) LLARingSpinnerView *spinnerViewBtn;
@property (nonatomic, strong) NSMutableArray *arrUsers;

@end

@implementation Subordinates

@synthesize spinnerView;
@synthesize spinnerViewBtn;
@synthesize arrUsers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblErrorMsg setTextColor:DARK_GRAY_COLOR];
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:18 andStrokeColor:CLEARCOLOUR]];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadSubordinates];
}

- (void)loadSubordinates
{
    if (IS_INTERNET_CONNECTED) {
        
        [self fetchSubordinatesWithCompletionHandler:^(BOOL finished) {
            [self setBarButton:AddBarButton];
            
            if (!arrUsers) {
                arrUsers = [[NSMutableArray alloc] init];
            }
            
            [arrUsers removeAllObjects];
            [arrUsers addObjectsFromArray:[Subordinate fetchSubordinates]];
            
            [self.tableView reloadData];
        }];
    }
    else {
        
        if (arrUsers.count > 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:kCHECK_INTERNET];
            [self showSpinner:NO withError:YES];
        }
    }
}

- (void)showSpinner:(BOOL)flag withError:(BOOL)errorFlag
{
    if (flag) {

        [lblErrorMsg setHidden:YES];
        [self.tableView setHidden:YES];
        [self.spinnerView startAnimating];
    }
    else {
        if (errorFlag) {
            [lblErrorMsg setHidden:NO];
            [self.tableView setHidden:YES];
        }
        else {
            [lblErrorMsg setHidden:YES];
            [self.tableView setHidden:NO];
        }
        
        [self.spinnerView stopAnimating];
    }
}

- (void)setBarButton:(UIBarButton)barBtnType
{
    switch (barBtnType) {
        case AddBarButton: {
            barBtnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(barBtnAddTaped:)];
            [barBtnAdd setTintColor:APP_TINT_COLOR];
            
            barBtnReload = [[UIBarButtonItem alloc] initWithImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"bar-btn-sync", kImageRenderModeTemplate) style:UIBarButtonItemStylePlain target:self action:@selector(barBtnReloadTaped:)];
            [barBtnReload setTintColor:APP_TINT_COLOR];
            
            [self.navigationItem setRightBarButtonItems:@[barBtnAdd, barBtnReload]];
            
            [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
        }
            break;
        case IndicatorBarButton: {
            barBtnAdd = [[UIBarButtonItem alloc] initWithCustomView:self.spinnerView];
            [barBtnAdd setTintColor:APP_TINT_COLOR];
            
            [self.spinnerView setBounds:CGRectMake(0, 0, 20, 20)];
            
            [self.navigationItem setRightBarButtonItems:nil];
            [self.navigationItem setRightBarButtonItem:barBtnAdd];
            [self.spinnerView startAnimating];
        }
            break;
        case NilBarButton: {
            [self.navigationItem setRightBarButtonItems:nil];
        }
        default:
            break;
    }
}

- (void)fetchSubordinatesWithCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kloadSubordinate,
                                     kAPIuserId: USER_ID
                                     };
            
            if (arrUsers.count == 0) {
                [self showSpinner:YES withError:NO];
                [self setBarButton:NilBarButton];
            }
            else {
                [self setBarButton:IndicatorBarButton];
            }
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self showSpinner:NO withError:NO];
                
                RemoveHasAdminAccess;
                RemoveFetchSubordinateStatus;
                
                if (responseObject == nil) {
                    ShareObj.fetchSubordinateStatus = kStatusFailed;
                    if (arrUsers.count > 0) {
                        [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                    }
                    else {
                        [lblErrorMsg setText:kSOMETHING_WENT_WRONG];
                        [self showSpinner:NO withError:YES];
                    }
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        ShareObj.fetchSubordinateStatus = kStatusFailed;
                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        
                        [Subordinate deleteSubordinates];
                        
                        NSArray *arrSubordinates = [responseObject valueForKey:kAPIsubordinateData];
                        
                        if (arrSubordinates.count > 0) {
                            
                            for (NSDictionary *obj in arrSubordinates) {
                                [Subordinate saveSubordinate:obj];
                            }
                            
                            [self showSpinner:NO withError:NO];
                            
                            Subordinate *obj = [Subordinate fetchSubordinateWhoHasAccess];
                            if (obj != nil) {
                                ShareObj.hasAdminAccess = NO;
                            }
                            else {
                                ShareObj.hasAdminAccess = YES;
                            }
                            
                            ShareObj.fetchSubordinateStatus = kStatusSuccess;
                        }
                        else {
                            
                            [lblErrorMsg setText:@"No Subordiantes found."];
                            [self showSpinner:NO withError:YES];
                            
                            ShareObj.hasAdminAccess = YES;
                            ShareObj.fetchSubordinateStatus = kStatusSuccess;
                        }
                        
                        SetHasAdminAccess(ShareObj.hasAdminAccess);
                    }
                }
                
                SetFetchSubordinateStatus(ShareObj.fetchSubordinateStatus);
                
                [ShareObj updateAdminAccessVariablesValue];
                
                completionHandler(YES);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSString *strMsg;
                
                if (error.code == kCFURLErrorTimedOut) {
                    strMsg = kREQUEST_TIME_OUT;
                    ShareObj.fetchSubordinateStatus = kStatusFailedBecauseInternet;
                }
                else if (error.code == kCFURLErrorNetworkConnectionLost) {
                    strMsg = kCHECK_INTERNET;
                    ShareObj.fetchSubordinateStatus = kStatusFailedBecauseInternet;
                }
                else {
                    strMsg = kSOMETHING_WENT_WRONG;
                    ShareObj.fetchSubordinateStatus = kStatusFailed;
                }
                
                SetFetchSubordinateStatus(ShareObj.fetchSubordinateStatus);
                
                [ShareObj updateAdminAccessVariablesValue];
                
                [lblErrorMsg setText:strMsg];
                [self showSpinner:NO withError:YES];
                
                [Global showNotificationWithTitle:strMsg titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                
                if (arrUsers.count > 0) {
                    [self.tableView setHidden:NO];
                    [lblErrorMsg setHidden:YES];
                }
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        [self showSpinner:NO withError:YES];
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (void)barBtnAddTaped:(id)sender
{
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSubordinate"];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)barBtnReloadTaped:(id)sender
{
    [self loadSubordinates];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubordinateCell";
    SubordinateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SubordinateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDelegate:self];
    
    Subordinate *obj = arrUsers[indexPath.row];
    if ([obj.hasAccess isEqualToNumber:@1]) {
        [cell setRightUtilityButtons:[self rightButtonsWithAccess:NO] WithButtonWidth:40];
    }
    else {
        [cell setRightUtilityButtons:[self rightButtonsWithAccess:YES] WithButtonWidth:40];
    }
    
    [cell configureCellWithSubordinateObj:arrUsers[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (NSArray *)rightButtonsWithAccess:(BOOL)flag
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    if (flag) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:WHITE_COLOR icon:IMAGE_WITH_NAME(IMG_give_access)];
//        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0] title:@"Give\nAccess"];
    }
    else {
        [rightUtilityButtons sw_addUtilityButtonWithColor:WHITE_COLOR icon:IMAGE_WITH_NAME(IMG_revoke_access)];
//        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"Revoke\nAccess"];
    }
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:WHITE_COLOR icon:IMAGE_WITH_NAME(IMG_trash_icon)];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
    
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
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            Subordinate *obj = arrUsers[cellIndexPath.row];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            params[kAPIMode] = kaccessControl;
            params[kAPIuserId] = obj.userId;
            params[kAPIadminId] = USER_ID;
            
            if ([obj.hasAccess isEqualToNumber:@0]) {
                objWhoHasAccess = [Subordinate fetchSubordinateWhoHasAccess];
                
                if (objWhoHasAccess != nil) {
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:nil
                                                          message:[NSString stringWithFormat:@"You've already given access to subordinate user %@.\nNow, if you give access to user %@ then access will be revoked for %@.\n\nAre you sure you want to continue?", objWhoHasAccess.firstName, obj.firstName, objWhoHasAccess.firstName]
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                   style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       NSLog(@"Cancel action");
                                                       
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
                    
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:NSLocalizedString(@"Continue", @"Continue action")
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   NSLog(@"OK action");
                                                   
                                                   params[kAPIhasAccess] = @1;
                                                   
                                                   [self controlAccessForSubordinate:params];
                                                   
                                               }];
                    
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    
                    [cell hideUtilityButtonsAnimated:YES];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else {
                    params[kAPIhasAccess] = @1;
                    [cell hideUtilityButtonsAnimated:YES];
                    [self controlAccessForSubordinate:params];
                }
            }
            else {
                params[kAPIhasAccess] = @0;
                [cell hideUtilityButtonsAnimated:YES];
                [self controlAccessForSubordinate:params];
            }
            
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:cellIndexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
            
            [self deleteSubordinate:arrUsers[cellIndexPath.row]];
            [arrUsers removeObjectAtIndex:cellIndexPath.row];
            
            [self.tableView endUpdates];
            
            break;
        }
        default:
            break;
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

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView beginUpdates];
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
//        [self deleteSubordinate:arrUsers[indexPath.row]];
//    }
//    [tableView endUpdates];
//}

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


- (void)controlAccessForSubordinate:(NSDictionary *)params
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            ShowNetworkActivityIndicator();
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                HideNetworkActivityIndicator();
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:@"You can't give/revoke access right now!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"You can't give/revoke access right now!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        
                        Subordinate *obj = [Subordinate fetchSubordinate:[params objectForKey:kAPIuserId]];
                        
                        if ([[params objectForKey:kAPIhasAccess] isEqualToNumber:@0]) {
                            [Subordinate updateAccessForUser:[params objectForKey:kAPIuserId] withValue:@0];
                            
                            [Global showNotificationWithTitle:[NSString stringWithFormat:@"Access revoked for %@.", obj.firstName] titleColor:WHITE_COLOR backgroundColor:GREEN_COLOR forDuration:1];
                            
                            SetHasAdminAccess(YES);
                        }
                        else {
                            [Subordinate updateAccessForUser:[params objectForKey:kAPIuserId] withValue:@1];
                            
                            if (objWhoHasAccess != nil) {
                                [Subordinate updateAccessForUser:objWhoHasAccess.userId withValue:@0];
                            }
                            
                            [Global showNotificationWithTitle:[NSString stringWithFormat:@"Access given to %@.", obj.firstName] titleColor:WHITE_COLOR backgroundColor:GREEN_COLOR forDuration:1];
                            
                            SetHasAdminAccess(NO);
                        }
                        
                        [self.tableView reloadData];
                    }
                }
                
                SetFetchSubordinateStatus(kStatusSuccess);
                
                ShareObj.hasAdminAccess = GetHasAdminAccess;
                ShareObj.fetchSubordinateStatus = GetFetchSubordinateStatus;
                
                [ShareObj updateAdminAccessVariablesValue];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                HideNetworkActivityIndicator();
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Global showNotificationWithTitle:@"You can't give/revoke access right now!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

- (void)deleteSubordinate:(Subordinate *)subordinateObj
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kdeleteSubordinate,
                                     kAPIuserId: subordinateObj.userId,
                                     kAPIadminId: USER_ID
                                     };
            
            ShowNetworkActivityIndicator();
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                HideNetworkActivityIndicator();
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:@"Subordinate can't be deleted right now!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"Subordinate can't be deleted right now!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        [Subordinate deleteSubordinate:subordinateObj.userId];
                        
                        [Global showNotificationWithTitle:@"Subordinate deleted successfully." titleColor:WHITE_COLOR backgroundColor:GREEN_COLOR forDuration:1];
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                HideNetworkActivityIndicator();
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error.code == kCFURLErrorTimedOut) {
                    [Global showNotificationWithTitle:kREQUEST_TIME_OUT titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else if (error.code == kCFURLErrorNetworkConnectionLost) {
                    [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
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
