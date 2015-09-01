//
//  SubordinateCases.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 06/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "SubordinateCases.h"
#import "ChooseAdmin.h"
#import "CaseCell.h"
#import "EditCase.h"
#import "UpdateCase.h"

BOOL isForSubordinate;

@interface SubordinateCases () <SWTableViewCellDelegate>
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) LLARingSpinnerView *spinnerViewBtn;
@property (nonatomic, strong) NSMutableArray *arrCases;
@end

@implementation SubordinateCases
@synthesize spinnerView,spinnerViewBtn,arrCases;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCasesLocally:) name:kFetchSubordinateCases object:nil];
    
    [self loadSubordinatesCases];

    isForSubordinate = YES;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
    //    self.originalFrame = viewAddCourt.frame;
}
- (void)fetchCasesLocally:(NSNotification *)aNotification
{
    if (!arrCases) {
        arrCases = [[NSMutableArray alloc] init];
    }
    
    [arrCases removeAllObjects];
    [arrCases addObjectsFromArray:[Cases fetchCasesForSubordinate]];
    
    [self.tableView reloadData];
    
    [self sortCasesArray:arrCases];
    
    if (arrCases.count > 0) {
        [self showSpinner:NO withError:NO];
    }
}

- (NSMutableArray *)sortCasesArray:(NSArray *)toBeSortedArr
{
    NSMutableArray *resultArray = [NSMutableArray new];
    NSMutableArray *groupArr = [NSMutableArray new];
    for (int i = 0; i < toBeSortedArr.count; i++) {
        
        NSMutableDictionary *arrDict = [NSMutableDictionary new];
        
        NSArray *groups = [[toBeSortedArr[i] objectForKey:kAPIdata] valueForKeyPath:@"@distinctUnionOfObjects.nextHearingDate"];
        for (NSString *nextHearingDate in groups)
        {
            NSMutableDictionary *groupArrDict = [NSMutableDictionary new];
            [groupArrDict setObject:nextHearingDate forKey:@"nextHearingDate"];
            
            NSArray *groupCases = [[toBeSortedArr[i] objectForKey:kAPIdata] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"nextHearingDate = %@", nextHearingDate]];
            
            [groupArrDict setObject:[toBeSortedArr[i] objectForKey:kAPIadminData] forKey:kAPIadminData];
            
            [groupArrDict setObject:groupCases forKey:@"data"];
            
            //        for (int i = 0; i < groupCases.count; i++)
            //        {
            //            Cases *caseObj = groupCases[i];
            //            [entry setObject:caseObj forKey:[NSString stringWithFormat:@"index%d", i + 1]];
            //        }
            
            [groupArr addObject:groupArrDict];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nextHearingDate" ascending:YES];
            
            [groupArr sortUsingDescriptors:@[sortDescriptor]];
        }
        
        [arrDict setObject:[toBeSortedArr[i] objectForKey:kAPIadminData] forKey:kAPIadminData];
        [arrDict setObject:groupArr forKey:kAPIdata];
        
        [resultArray addObject:arrDict];
    }
    
    NSLog(@"%@", resultArray);
    
    return resultArray;
}

- (void)barBtnAddTaped:(id)sender
{
    ChooseAdmin *chooseAdminVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseAdmin"];
    [chooseAdminVC setDetailViewToChooseAdmin:kDetailViewCases];
    
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
    [self loadSubordinatesCases];
}

- (void)barBtnReloadTaped:(id)sender
{
    [self loadSubordinatesCases];
}
- (void)loadSubordinatesCases
{
    if (IS_INTERNET_CONNECTED) {
        
        [btnReload setHidden:YES];
        
        [self fetchSubordinatesWithCompletionHandler:^(BOOL finished) {
            [self setBarButton:AddBarButton];
            
            [self fetchCasesLocally:nil];
        }];
    }
    else {
        
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        
        [self fetchCasesLocally:nil];
        
        [self setBarButton:AddBarButton];
        
        if (arrCases.count > 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:@"No records stored locally!\n Please connect to the internet to get updated data."];
            [self showSpinner:NO withError:YES];
            
            [btnReload setHidden:NO];
        }
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
    SubordinateAdmin *adminObj = [arrCases[section] objectForKey:kAPIadminData];
    
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
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return arrCases.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger noOfRow = [[arrCases[section] objectForKey:kAPIdata] count];
    if (noOfRow == 0) {
        noOfRow = 1;
    }
    return noOfRow;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray *caseRecords = [arrCases[indexPath.section] objectForKey:kAPIdata];
    
    if (caseRecords.count > 0) {
        static NSString *cellId=@"CaseCell";
        CaseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil)
        {
            cell=[[CaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell setDelegate:self];
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:44];
        [cell configureCellWithCaseObj:[caseRecords objectAtIndex:indexPath.row] forIndexPath:indexPath];
        
        return cell;
    }
    else {
        static NSString *cellId=@"NoRecordCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(ViewX(self.tableView)+15, 0, ViewWidth(self.tableView)-30, ViewHeight(cell))];
        [lblTitle setText:@"No Records Found!"];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setFont:[UIFont systemFontOfSize:16]];
        [cell addSubview:lblTitle];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdateCase *updateCaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateCase"];
    [updateCaseVC setExistingCaseObj:[[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:updateCaseVC animated:YES];
    
    //    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtDetail"];
    //    CourtDetail *courtDetailVC = navController.viewControllers[0];
    //    [courtDetailVC setCourtObj:arrCourts[indexPath.row]];
    //    [self.navigationController pushViewController:courtDetailVC animated:YES];
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            
            Cases *caseObj = [[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row];
            
            EditCase *editCaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCase"];
            [editCaseVC setExistingAdminObj:[SubordinateAdmin fetchSubordinateAdmin:caseObj.adminId]];
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
            
            SubordinateAdmin *adminObj = [arrCases[indexPath.section] objectForKey:kAPIadminData];
            
            if ([adminObj.hasAccess isEqualToNumber:@1]) {
                [self.tableView beginUpdates];
                
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                [Cases updatedCasePropertyofCase:[[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] withProperty:kCaseIsDeleted andValue:@1];
                [self deleteCase:[[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] forAdmin:adminObj];
                
                [arrCases removeAllObjects];
                [arrCases addObjectsFromArray:[Cases fetchCasesForSubordinate]];
                [self.tableView endUpdates];
            
            }
            else {
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                UI_ALERT(@"Warning", @"You don't have access to perform this operation.", nil);
            }
            
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

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SubordinateAdmin *adminObj = [arrCases[indexPath.section] objectForKey:kAPIadminData];
//    
//    if ([adminObj.hasAccess isEqualToNumber:@1]) {
//        [tableView beginUpdates];
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
//            [Cases updatedCasePropertyofCase:[[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] withProperty:kCaseIsDeleted andValue:@1];
//            [self deleteCase:[[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] forAdmin:adminObj];
//         
//            [arrCases removeAllObjects];
//            [arrCases addObjectsFromArray:[Cases fetchCasesForSubordinate]];
//        }
//        [tableView endUpdates];
//    }
//    else {
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        UI_ALERT(@"Warning", @"You don't have access to perform this operation.", nil);
//    }
//}

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
                                     kAPIMode: kloadSubordinateCase,
                                     kAPIsubordinateId: USER_ID
                                     };
            
            if (arrCases.count == 0) {
                [self showSpinner:YES withError:NO];
                [self setBarButton:NilBarButton];
            }
            else {
                [self setBarButton:IndicatorBarButton];
            }
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self showSpinner:NO withError:NO];
                
                if (responseObject == nil) {
                    if (arrCases.count > 0) {
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
                            
                            [Cases deleteCaseForSubordinate];
                            
                            for (NSDictionary *obj in arrSubordinates) {
                                [SubordinateAdmin saveSubordinateAdmin:obj];
                                [Cases saveCasesForSubordinate:obj];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
                            [Cases deleteCaseForSubordinate];
                            
                            [lblErrorMsg setText:@"No Cases Found."];
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
                
                if (arrCases.count > 0) {
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
        [self fetchCasesLocally:nil];
        
        if (arrCases.count > 0) {
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
