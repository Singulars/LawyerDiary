//
//  SubordinateClients.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 06/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "SubordinateClients.h"
#import "Client.h"
#import "ClientCell.h"
#import "ChooseAdmin.h"
#import "ClientDetail.h"
#import "SubordinateAdmin.h"

BOOL isForSubordinate;

@interface SubordinateClients () <SWTableViewCellDelegate>

@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) LLARingSpinnerView *spinnerViewBtn;
@property (nonatomic, strong) NSMutableArray *arrClients;
@end

@implementation SubordinateClients
@synthesize spinnerView,spinnerViewBtn,arrClients;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblErrorMsg setTextColor:DARK_GRAY_COLOR];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];
    
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchClientsLocally:) name:kFetchSubordinateClients object:nil];
    
    [self loadSubordinatesClients];
    
    isForSubordinate = YES;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)barBtnAddTaped:(id)sender
{
    ChooseAdmin *chooseAdminVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseAdmin"];
    [chooseAdminVC setDetailViewToChooseAdmin:kDetailViewClients];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:chooseAdminVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)btnReloadTaped:(id)sender
{
    [self loadSubordinatesClients];
}

- (void)barBtnReloadTaped:(id)sender
{
    [self loadSubordinatesClients];
}

- (void)fetchClientsLocally:(NSNotification *)aNotification
{
    if (!arrClients) {
        arrClients = [[NSMutableArray alloc] init];
    }
    
    [arrClients removeAllObjects];
    [arrClients addObjectsFromArray:[Client fetchClientsForSubordinate]];
    
    [self.tableView reloadData];
    
    if (arrClients.count > 0) {
        [self showSpinner:NO withError:NO];
    }
}

- (void)loadSubordinatesClients
{
    if (IS_INTERNET_CONNECTED) {
        
        [btnReload setHidden:YES];
        
        [self fetchSubordinatesWithCompletionHandler:^(BOOL finished) {
            [self setBarButton:AddBarButton];
            
            [self fetchClientsLocally:nil];
        }];
    }
    else {
        
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        
        [self fetchClientsLocally:nil];
        
        [self setBarButton:AddBarButton];
        
        if (arrClients.count > 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:@"No records stored locally!\n Please connect to the internet to get uodated data."];
            [self showSpinner:NO withError:YES];
            
            [btnReload setHidden:NO];
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
#pragma mark
#pragma mark - UITableViewDataSource / UITableViewDelegate

- (CGFloat)tableView:(nonnull UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SubordinateAdmin *adminObj = [arrClients[section] objectForKey:kAPIadminData];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(self.tableView), 22)];
    [headerView setBackgroundColor:UICOLOR(239, 239, 244, 1)];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 22)];
    [lblHeader setBackgroundColor:CLEARCOLOUR];
    [lblHeader setFont:[UIFont boldSystemFontOfSize:13]];
    [lblHeader setTextColor:UICOLOR(109, 109, 114, 1)];
    
    UILabel *lblHasAccess = [[UILabel alloc] initWithFrame:CGRectMake(ViewWidth(tableView)-200, 0, 192, 22)];
    [lblHasAccess setBackgroundColor:CLEARCOLOUR];
    [lblHasAccess setTextAlignment:NSTextAlignmentRight];
    [lblHasAccess setFont:[UIFont boldSystemFontOfSize:13]];
    [lblHasAccess setTextColor:UICOLOR(109, 109, 114, 1)];
    [lblHasAccess setText:[NSString stringWithFormat:@"ACCESS GIVEN: %@", [adminObj.hasAccess isEqualToNumber:@0] ? @"NO" : @"YES"]];
    [headerView addSubview:lblHasAccess];
    
    
    [headerView addSubview:lblHeader];
    NSString *headerTitle;
    
    headerTitle = adminObj.adminName;
    
    
    [lblHeader setText:UPPERCASE_STRING(headerTitle)];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowHieght = 60;
    NSArray *courtRecords = [arrClients[indexPath.row] objectForKey:kAPIdata];
    
    if (courtRecords.count == 0) {
        rowHieght = 44;
    }
    return rowHieght;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return arrClients.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger noOfRow = [[arrClients[section] objectForKey:kAPIdata] count];
    if (noOfRow == 0) {
        noOfRow = 1;
    }
    return noOfRow;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray *clientRecords = [arrClients[indexPath.row] objectForKey:kAPIdata];
    
    if (clientRecords.count > 0) {
        static NSString *cellId=@"ClientCell";
        ClientCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        if (cell==nil)
        {
            cell=[[ClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        [cell setDelegate:self];
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60];
        [cell configureCellWithClientObj:[clientRecords objectAtIndex:indexPath.row] forIndexPath:indexPath];
        
        return cell;
    }
    else {
        return cellNoRecords;
    }
    return nil;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            
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
                    SubordinateAdmin *adminObj = [arrClients[indexPath.section] objectForKey:kAPIadminData];
                    
                    if ([adminObj.hasAccess isEqualToNumber:@1]) {
                        
                        Client *toBeDeletedClientObj = [[arrClients[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row];
                        
                        if (![Cases isThisClientExist:toBeDeletedClientObj.localClientId]) {
                            
                            [self.tableView beginUpdates];
                            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                            
                            if ([toBeDeletedClientObj.isSynced isEqualToNumber:@0] && [toBeDeletedClientObj.clientId isEqualToNumber:@-1]) {
                                [Client deleteClient:toBeDeletedClientObj.localClientId];
                            }
                            else {
                                [Client updatedClientPropertyofClient:[[arrClients[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] withProperty:kClientIsDeleted andValue:@1];
                                [self deleteClient:[[arrClients[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] forAdmin:adminObj];
                            }
                            
                            [arrClients removeAllObjects];
                            [arrClients addObjectsFromArray:[Client fetchClientsForSubordinate]];
                            
                            [self.tableView endUpdates];
                            
                            if (arrClients.count == 0) {
                                [lblErrorMsg setText:@"No Clients found."];
                                [self showSpinner:NO withError:YES];
                            }

                        }
                        else {
                            UI_ALERT(@"", @"This Client is belongs to one of the existing Case. So you can't delete this Client. To delete this Court, you've to delete Case first.", nil);
                        }
                    }
                    else {
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        UI_ALERT(@"Warning", @"You don't have access to perform this operation.", nil);
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrClients[indexPath.section] valueForKey:@"data"] count] > 0) {
        
        ClientDetail *clientDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ClientDetail"];
        
        SubordinateAdmin *adminObj = [arrClients[indexPath.section] objectForKey:kAPIadminData];
        [clientDetailVC setExistingAdminObj:adminObj];
//        [clientDetailVC setIsForSubordinate:YES];
        [clientDetailVC setClientObj:[[arrClients[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:clientDetailVC animated:YES];
    }
    else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubordinateAdmin *adminObj = [arrClients[indexPath.section] objectForKey:kAPIadminData];
    
    if ([adminObj.hasAccess isEqualToNumber:@1]) {
        [tableView beginUpdates];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            Client *toBeDeletedClientObj = [[arrClients[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
            
            if ([toBeDeletedClientObj.isSynced isEqualToNumber:@0] && [toBeDeletedClientObj.clientId isEqualToNumber:@-1]) {
                [Client deleteClient:toBeDeletedClientObj.localClientId];
            }
            else {
                [Client updatedClientPropertyofClient:[[arrClients[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] withProperty:kClientIsDeleted andValue:@1];
                [self deleteClient:[[arrClients[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] forAdmin:adminObj];
            }
            
            [arrClients removeAllObjects];
            [arrClients addObjectsFromArray:[Client fetchClientsForSubordinate]];
        }
        [tableView endUpdates];
    }
    else {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        UI_ALERT(@"Warning", @"You don't have access to perform this operation.", nil);
    }
}

- (void)deleteClient:(Client *)objClient forAdmin:(SubordinateAdmin *)adminObj
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kdeleteCourt,
                                     kAPIuserId: USER_ID,
                                     kAPIcourtId: objClient.clientId,
                                     kAPIadminId: adminObj.adminId
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:@"Client can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"Client can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        [Client deleteClient:objClient.clientId];
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Global showNotificationWithTitle:@"Client can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
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

- (void)fetchSubordinatesWithCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kloadSubordinateClient,
                                     kAPIsubordinateId: USER_ID
                                     };
            
            if (arrClients.count == 0) {
                [self showSpinner:YES withError:NO];
                [self setBarButton:NilBarButton];
            }
            else {
                [self setBarButton:IndicatorBarButton];
            }
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self showSpinner:NO withError:NO];
                
                if (responseObject == nil) {
                    if (arrClients.count > 0) {
                        [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                    }
                    else {
                        [lblErrorMsg setText:kSOMETHING_WENT_WRONG];
                        [self showSpinner:NO withError:YES];
                    }
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        NSArray *arrSubordinates = [responseObject valueForKey:kAPIclientData];
                        
                        if (arrSubordinates.count > 0) {
                            
                            [Client deleteCientsForSubordinate];
                            
                            for (NSDictionary *obj in arrSubordinates) {
                                [SubordinateAdmin saveSubordinateAdmin:obj];
                                [Client saveClientsForSubordinate:obj];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
                            [Client deleteCientsForSubordinate];
                            
                            [lblErrorMsg setText:@"No Subordiantes Courts Found."];
                            [self showSpinner:NO withError:YES];
                        }
                    }
                }
                completionHandler(YES);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSString *strMsg;
                
                if (error.code == kCFURLErrorTimedOut) {
                    strMsg = kREQUEST_TIME_OUT;
                }
                else if (error.code == kCFURLErrorNetworkConnectionLost) {
                    strMsg = kCHECK_INTERNET;
                }
                else {
                    strMsg = kSOMETHING_WENT_WRONG;
                }
                
                [lblErrorMsg setText:strMsg];
                [self showSpinner:NO withError:YES];
                
                [Global showNotificationWithTitle:strMsg titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                
                if (arrClients.count > 0) {
                    [self.tableView setHidden:NO];
                    [lblErrorMsg setHidden:YES];
                }
                else {
                    [btnReload setHidden:NO];
                }
                
                completionHandler(YES);
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        [self fetchClientsLocally:nil];
        
        if (arrClients.count > 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:@"No records stored locally!\n Please connect to the internet to get uodated data."];
            [self showSpinner:NO withError:YES];
            
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        
//        [self showSpinner:NO withError:YES];
//        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        
        completionHandler(YES);
    }
}

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
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
