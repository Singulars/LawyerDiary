//
//  SubordinateCourts.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 06/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "SubordinateCourts.h"
#import "CourtDetail.h"
#import "Court.h"
#import "ChooseAdmin.h"

BOOL isForSubordinate;

@interface SubordinateCourts () <SWTableViewCellDelegate>

@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) LLARingSpinnerView *spinnerViewBtn;
@property (nonatomic, strong) NSMutableArray *arrCourts;

@end

@implementation SubordinateCourts
@synthesize spinnerView,spinnerViewBtn,arrCourts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblErrorMsg setTextColor:DARK_GRAY_COLOR];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];

    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCourtsLocally:) name:kFetchSubordinateCourts object:nil];
    
    [self loadSubordinatesCourts];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isForSubordinate = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
    //    self.originalFrame = viewAddCourt.frame;
}

- (void)fetchCourtsLocally:(NSNotification *)aNotification
{
    if (!arrCourts) {
        arrCourts = [[NSMutableArray alloc] init];
    }
    
    [arrCourts removeAllObjects];
    [arrCourts addObjectsFromArray:[Court fetchCourtsForSubordinate]];
    
    [self.tableView reloadData];
    
    if (arrCourts.count > 0) {
        [self showSpinner:NO withError:NO];
    }
}

- (void)barBtnAddTaped:(id)sender
{
    ChooseAdmin *chooseAdminVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseAdmin"];
    [chooseAdminVC setDetailViewToChooseAdmin:kDetailViewCourts];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:chooseAdminVC];
    [self presentViewController:navController animated:YES completion:nil];
    
//    SubordinateAdmin *adminObj = [SubordinateAdmin fetchAdminWhoHasGivenAccess];
//    if (adminObj != nil) {
//        ChooseAdmin *chooseSubordinatesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseAdmin"];
//        
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:chooseSubordinatesVC];
//        [self presentViewController:navController animated:YES completion:nil];
//    }
//    else {
//        
//    }
}

- (IBAction)btnReloadTaped:(id)sender
{
    [self loadSubordinatesCourts];
}

- (void)barBtnReloadTaped:(id)sender
{
    [self loadSubordinatesCourts];
}

- (void)loadSubordinatesCourts
{
    if (IS_INTERNET_CONNECTED) {
        
        [btnReload setHidden:YES];
        
        [self fetchSubordinatesWithCompletionHandler:^(BOOL finished) {
            [self setBarButton:AddBarButton];
            
            [self fetchCourtsLocally:nil];
        }];
    }
    else {
        
        [self fetchCourtsLocally:nil];
        
        [self setBarButton:AddBarButton];
        
        if (arrCourts.count > 0 || arrCourts.count == 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:@"No records stored locally!\n Please connect to the internet to get uodated data."];
            [self showSpinner:NO withError:YES];
            
            [btnReload setHidden:NO];
        }
    }
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
#pragma mark - UITableViewDataSource / UITableViewDelegate

- (CGFloat)tableView:(nonnull UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SubordinateAdmin *adminObj = [arrCourts[section] objectForKey:kAPIadminData];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(self.tableView), 22)];
    [headerView setBackgroundColor:UICOLOR(50, 50, 50, 1)];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 22)];
    [lblHeader setBackgroundColor:CLEARCOLOUR];
    [lblHeader setFont:[UIFont boldSystemFontOfSize:13]];
    [lblHeader setTextColor:WHITE_COLOR];
    
    UILabel *lblHasAccess = [[UILabel alloc] initWithFrame:CGRectMake(ViewWidth(tableView)-200, 0, 192, 22)];
    [lblHasAccess setBackgroundColor:CLEARCOLOUR];
    [lblHasAccess setTextAlignment:NSTextAlignmentRight];
    [lblHasAccess setFont:[UIFont boldSystemFontOfSize:13]];
    [lblHasAccess setTextColor:WHITE_COLOR];
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
    NSArray *courtRecords = [arrCourts[indexPath.section] objectForKey:kAPIdata];
    
    if (courtRecords.count == 0) {
        rowHieght = 44;
    }
    return rowHieght;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return arrCourts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger noOfRow = [[arrCourts[section] objectForKey:kAPIdata] count];
    if (noOfRow == 0) {
        noOfRow = 1;
    }
    return noOfRow;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray *courtRecords = [arrCourts[indexPath.section] objectForKey:kAPIdata];
    
    if (courtRecords.count > 0) {
        static NSString *cellId=@"CourtCell";
        CourtCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil)
        {
            cell=[[CourtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        [cell setDelegate:self];
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60];
        [cell configureCellWithCourtObj:[courtRecords objectAtIndex:indexPath.row] forIndexPath:indexPath];
        
        return cell;
    }
    else {
        static NSString *cellId=@"NoRecordCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(ViewX(self.tableView)+15, 0, ViewWidth(self.tableView)-30, ViewHeight(cell))];
            [lblTitle setText:@"No Records Found!"];
            [lblTitle setTextAlignment:NSTextAlignmentCenter];
            [lblTitle setFont:[UIFont systemFontOfSize:16]];
            [lblTitle setTextColor:UICOLOR(109, 109, 114, 1)];
            [cell addSubview:lblTitle];
            
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        return cell;
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
            
            SubordinateAdmin *adminObj = [arrCourts[indexPath.section] objectForKey:kAPIadminData];
            
            if ([adminObj.hasAccess isEqualToNumber:@1]) {
                
                Court *toBeDeletedCourtObj = [[arrCourts[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row];
                
                if (![Cases isThisCourtExist:toBeDeletedCourtObj.localCourtId]) {
                    
                    [self.tableView beginUpdates];
                    
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                    
                    if ([toBeDeletedCourtObj.isSynced isEqualToNumber:@0] && [toBeDeletedCourtObj.courtId isEqualToNumber:@-1]) {
                        [Court deleteCourt:toBeDeletedCourtObj.localCourtId];
                    }
                    else {
                        [Court updatedCourtPropertyofCourt:[[arrCourts[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] withProperty:kCourtIsDeleted andValue:@1];
                        [self deleteCourt:[[arrCourts[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] forAdmin:adminObj];
                    }
                    
                    [arrCourts removeAllObjects];
                    [arrCourts addObjectsFromArray:[Court fetchCourtsForSubordinate]];
                    
                    [self.tableView endUpdates];
                    
                    if (arrCourts.count == 0) {
                        [lblErrorMsg setText:@"No Subordiantes Courts Found."];
                        [self showSpinner:NO withError:YES];
                    }
                }
                else {
                    UI_ALERT(@"", @"This Court is belongs to one of the existing Case. So you can't delete this Court. To delete this Court, you've to delete Case first.", nil);
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
    if ([[arrCourts[indexPath.section] valueForKey:@"data"] count] > 0) {
        
        CourtDetail *courtDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtDetail"];
        
        SubordinateAdmin *adminObj = [arrCourts[indexPath.section] objectForKey:kAPIadminData];
        [courtDetailVC setExistingAdminObj:adminObj];
//        [courtDetailVC setIsForSubordinate:YES];
        [courtDetailVC setCourtObj:[[arrCourts[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:courtDetailVC animated:YES];
    }
    else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
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

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubordinateAdmin *adminObj = [arrCourts[indexPath.section] objectForKey:kAPIadminData];
    
    if ([adminObj.hasAccess isEqualToNumber:@1]) {
        [tableView beginUpdates];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            Court *toBeDeletedCourtObj = [[arrCourts[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
            
            if ([toBeDeletedCourtObj.isSynced isEqualToNumber:@0] && [toBeDeletedCourtObj.courtId isEqualToNumber:@-1]) {
                [Court deleteCourt:toBeDeletedCourtObj.localCourtId];
            }
            else {
                [Court updatedCourtPropertyofCourt:[[arrCourts[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] withProperty:kCourtIsDeleted andValue:@1];
                [self deleteCourt:[[arrCourts[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] forAdmin:adminObj];
            }
            
            [arrCourts removeAllObjects];
            [arrCourts addObjectsFromArray:[Court fetchCourtsForSubordinate]];
        }
        [tableView endUpdates];
    }
    else {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        UI_ALERT(@"Warning", @"You don't have access to perform this operation.", nil);
    }
}
*/

- (void)deleteCourt:(Court *)objCourt forAdmin:(SubordinateAdmin *)adminObj
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kdeleteCourt,
                                     kAPIuserId: USER_ID,
                                     kAPIcourtId: objCourt.courtId,
                                     kAPIadminId: adminObj.adminId
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:@"Court can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"Court can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        [Court deleteCourt:objCourt.courtId];
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Global showNotificationWithTitle:@"Court can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
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

- (void)fetchSubordinatesWithCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kloadSubordinateCourt,
                                     kAPIsubordinateId: USER_ID
                                     };
            
            if (arrCourts.count == 0) {
                [self showSpinner:YES withError:NO];
                [self setBarButton:NilBarButton];
            }
            else {
                [self setBarButton:IndicatorBarButton];
            }
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self showSpinner:NO withError:NO];
                
                if (responseObject == nil) {
                    if (arrCourts.count > 0) {
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
                        NSArray *arrSubordinates = [responseObject valueForKey:kAPIcourData];
                        
                        if (arrSubordinates.count > 0) {
                            
                            [Court deleteCourtsForSubordinate];
                            
                            for (NSDictionary *obj in arrSubordinates) {
                                
                                [SubordinateAdmin saveSubordinateAdmin:obj];
                                [Court saveCourtsForSubordinate:obj];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
                            [Court deleteCourtsForSubordinate];
                            
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
                
                if (arrCourts.count > 0) {
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
        [self fetchCourtsLocally:nil];
        
        if (arrCourts.count > 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:@"No records stored locally!\n Please connect to the internet to get uodated data."];
            [self showSpinner:NO withError:YES];
            
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        
        completionHandler(YES);
        
//        [self showSpinner:NO withError:YES];
//        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

@end
