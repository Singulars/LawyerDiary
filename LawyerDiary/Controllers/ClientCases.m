//
//  Cases.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "ClientCases.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "Cases.h"
#import "CaseCell.h"
#import "ChooseClient.h"
#import "UpdateCase.h"
#import "EditCase.h"

BOOL isForSubordinate;
SubordinateAdmin *selectedAdminObj;

@interface ClientCases ()<SWTableViewCellDelegate>
{
    NSInteger indexOlder;
    NSInteger indexNewer;
    BOOL isRequestForOlder;
    
    BOOL isRequesting;
}
@property (nonatomic, strong) NSMutableArray *arrCases;
@property (nonatomic, strong) NSMutableArray *arrIndexPaths;

@end

@implementation ClientCases

@synthesize arrCases;
@synthesize arrIndexPaths;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SetStatusBarHidden(NO);
    
    [lblErrorMsg setTextColor:DARK_GRAY_COLOR];
    
    NSLog(@"Fonts - %@", [UIFont fontNamesForFamilyName:APP_FONT]);
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:18 andStrokeColor:CLEARCOLOUR]];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 64, 0, 0)];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    
    [self loadCases];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCasesLocally:) name:kFetchCases object:nil];
    
    [self.navigationItem setBackBarButtonItem:[Global hideBackBarButtonTitle]];
    
    //    [Cases deleteCientsForUser:USER_ID];
    
    /* arrCases = [[NSMutableArray alloc] init];
     
     __weak ClientCases *weakSelf = self;
     
     // setup pull-to-refresh
     [self.tableView addPullToRefreshWithActionHandler:^{
     [weakSelf insertRowsAtTop];
     }];
     
     // setup infinite scrolling
     [self.tableView addInfiniteScrollingWithActionHandler:^{
     [weakSelf insertRowsAtBottom];
     }];
     
     //    [self loadCourts];
     
     if (arrCases.count == 0) {
     [self showSpinner:YES withError:NO];
     
     [self fetchCases:kPriorityInitial withCompletionHandler:^(BOOL finished) {
     [self.tableView reloadData];
     }];
     }*/
    
}
- (void)fetchCasesLocally:(NSNotification *)aNotification
{
    if (!arrCases) {
        arrCases = [[NSMutableArray alloc] init];
    }
    
    NSArray *casesArr = [Cases fetchCasesForAdmin];
    
    [arrCases removeAllObjects];
    [arrCases addObjectsFromArray:[self sortCasesArray:casesArr]];
    
    if (arrCases.count > 0) {
        [self showSpinner:NO withError:NO];
    }
    else {
        [lblErrorMsg setText:@"No Cases Found."];
        [self showSpinner:NO withError:YES];
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)sortCasesArray:(NSArray *)toBeSortedArr
{
    NSMutableArray *resultArray = [NSMutableArray new];
    NSArray *groups = [toBeSortedArr valueForKeyPath:@"@distinctUnionOfObjects.nextHearingDate"];
    for (NSString *nextHearingDate in groups)
    {
        NSMutableDictionary *entry = [NSMutableDictionary new];
        [entry setObject:nextHearingDate forKey:@"nextHearingDate"];
        
        NSArray *groupCases = [toBeSortedArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"nextHearingDate = %@", nextHearingDate]];
        
        [entry setObject:groupCases forKey:@"data"];
        
//        for (int i = 0; i < groupCases.count; i++)
//        {
//            Cases *caseObj = groupCases[i];
//            [entry setObject:caseObj forKey:[NSString stringWithFormat:@"index%d", i + 1]];
//        }
        
        [resultArray addObject:entry];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nextHearingDate" ascending:YES];
        
        [resultArray sortUsingDescriptors:@[sortDescriptor]];
    }
    
//    NSLog(@"%@", resultArray);
    
    return resultArray;
}

- (IBAction)btnReloadTaped:(id)sender
{
    [self loadCases];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isForSubordinate = NO;
    
    [self fetchCasesLocally:nil];
    
    //    if (!arrCases) {
    //        arrCases = [[NSMutableArray alloc] init];
    //    }
    //    [arrCases removeAllObjects];
    //
    //    [arrCases addObjectsFromArray:[Cases fetchCases:USER_ID]];
    //    [self.tableView reloadData];
    //
    //    if (arrCases.count > 0) {
    //        [self showSpinner:NO withError:NO];
    //    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
    //    self.originalFrame = viewAddCourt.frame;
}

- (void)barBtnReloadTaped:(id)sender
{
    [self loadCases];
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
- (void)fetchCasesWithCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kloadCase,
                                     kAPIuserId: USER_ID
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
                        NSArray *arrCasesObj = [responseObject valueForKey:kAPIcaseList];
                        
                        if (arrCasesObj.count > 0) {

                            [Cases deleteCaseForAdmin];
                            
                            for (NSDictionary *casesObj in arrCasesObj) {
                                [Cases saveCase:casesObj forSubordiante:NO withAdminDetail:nil];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
                            [Cases deleteCaseForAdmin];
                            
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


- (void)loadCases
{
    /*if (!arrCases) {
     arrCases = [[NSMutableArray alloc] init];
     }
     [arrCases removeAllObjects];
     [arrCases addObjectsFromArray:[Cases fetchCases:USER_ID]];
     if (arrCases.count == 0) {
     [self fetchCases:kPriorityInitial withCompletionHandler:^(BOOL finished) {
     
     }];
     }
     [self.tableView reloadData];*/
    
    //Edited By Vishal
    
    if (IS_INTERNET_CONNECTED) {
        
        [btnReload setHidden:YES];
        [self fetchCasesWithCompletionHandler:^(BOOL finished) {
            [self setBarButton:AddBarButton];
            
            [self fetchCasesLocally:nil];
        }];
    }
    else {
        
        [self fetchCasesLocally:nil];
        
        [self setBarButton:AddBarButton];
        
        if (arrCases.count > 0 || arrCases.count == 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:@"No records stored locally!\n Please connect to the internet to get updated data."];
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

//- (void)showSpinner:(BOOL)flag withError:(BOOL)errorFlag
//{
//    if (flag) {
//        [btnReload setHidden:YES];
//        [lblErrorMsg setHidden:YES];
//        [self.tableView setHidden:YES];
//        //        [viewAddCourt setHidden:YES];
//        [self.spinnerView startAnimating];
//        
//        //        [self.navigationItem setRightBarButtonItem:nil];
//    }
//    else {
//        if (errorFlag) {
//            [lblErrorMsg setHidden:NO];
//            [self.tableView setHidden:YES];
//            //            [viewAddCourt setHidden:YES];
//        }
//        else {
//            [lblErrorMsg setHidden:YES];
//            [self.tableView setHidden:NO];
//            //            [viewAddCourt setHidden:NO];
//            
//            [btnReload setHidden:YES];
//        }
//        
//        [self.spinnerView stopAnimating];
//        
//        //        [self.navigationItem setRightBarButtonItem:barBtnSync];
//    }
//}

/*- (void)insertRowsAtTop {
 
 //    if (!isRequesting) {
 isRequesting = YES;
 [self fetchCases:kPriorityNewer withCompletionHandler:^(BOOL finished) {
 if (arrIndexPaths.count > 0) {
 [self.tableView beginUpdates];
 [self.tableView insertRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
 [self.tableView endUpdates];
 }
 
 [self.tableView.pullToRefreshView stopAnimating];
 isRequesting = NO;
 }];
 //    } else {
 //        [self.tableView.pullToRefreshView stopAnimating];
 //    }
 }
 
 
 - (void)insertRowsAtBottom {
 
 //    if (!isRequesting) {
 isRequesting = YES;
 [self fetchCases:kPriorityOlder withCompletionHandler:^(BOOL finished) {
 if (arrIndexPaths.count > 0) {
 [self.tableView beginUpdates];
 [self.tableView insertRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationTop];
 [self.tableView endUpdates];
 }
 
 [self.tableView.infiniteScrollingView stopAnimating];
 
 isRequesting = NO;
 }];
 //    } else {
 //        [self.tableView.infiniteScrollingView stopAnimating];
 //    }
 }*/

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)barBtnAddTaped:(id)sender
{
    switch (ShareObj.fetchSubordinateStatus) {
        case kStatusUndetermined: {
            UI_ALERT(@"", @"The status of given access to subordinate is undermined yet.\nSo, you can not modify or add any new records.", nil);
        }
            break;
        case kStatusFailed: {
            UI_ALERT(@"", @"Somehow, the approach to get status of given access to subordinate failed.\nSo, you can not modify or add any new records.", nil);
        }
            break;
        case kStatusFailedBecauseInternet: {
            UI_ALERT(@"", @"The approach to get status of access failed because of internert inavailability.\nSo, you can not modify or add any new records.", nil);
        }
            break;
        case kStatusSuccess: {
            if (ShareObj.hasAdminAccess) {
                
                selectedAdminObj = nil;
                
                ChooseClient *chooseClientVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseClient"];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:chooseClientVC];
                [self presentViewController:navController animated:YES completion:nil];
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


#pragma mark - UITableViewDataSource / UITableViewDelegate
#pragma mark -

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *date = [arrCases[section] objectForKey:@"nextHearingDate"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(self.tableView), 22)];
    [headerView setBackgroundColor:UICOLOR(239, 239, 244, 1)];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 22)];
    [lblHeader setBackgroundColor:CLEARCOLOUR];
    [lblHeader setFont:[UIFont boldSystemFontOfSize:13]];
    [lblHeader setTextColor:UICOLOR(109, 109, 114, 1)];
    
    [headerView addSubview:lblHeader];
    NSString *headerTitle = [Global getDateStringOfFormat:DefaultBirthdateFormat fromDateString:date ofFormat:ServerBirthdateFormat];
    
    
    NSDate *caseDate = [Global getDateWithoutSeconds:[Global getDatefromDateString:headerTitle ofFormat:DefaultBirthdateFormat]];
    
    NSDate *todayDate = [Global getDatefromDateString:[Global getDateStringFromDate:[NSDate date] ofFormat:ServerBirthdateFormat] ofFormat:ServerBirthdateFormat];
    
    if ([caseDate compare:todayDate] == NSOrderedSame) {
        NSLog(@"Case date matched with today date");
        headerTitle = @"Today";
    }
    
    NSDate *tomorrowDate = [Global getDatefromDateString:[Global getDateStringFromDate:[Global addDays:1 inDate:todayDate] ofFormat:ServerBirthdateFormat] ofFormat:ServerBirthdateFormat];
    
    if ([caseDate compare:tomorrowDate] == NSOrderedSame) {
        headerTitle = @"Tomorrow";
    }
    
    NSLog(@"%@ %@", caseDate, todayDate);
    
    [lblHeader setText:headerTitle];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCases.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arrCases[section] objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CaseCell";
    CaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *caseRecords = [arrCases[indexPath.section] objectForKey:kAPIdata];
    
    [cell setDelegate:self];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60];
    [cell configureCellWithCaseObj:[caseRecords objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdateCase *updateCaseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateCase"];
    [updateCaseVC setExistingCaseObj:[[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:updateCaseVC animated:YES];
    
    [self.view endEditing:YES];
    
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
            [editCaseVC setExistingCaseObj:caseObj];
            [editCaseVC setExistingClientObj:[Client fetchClientLocally:caseObj.localClientId]];
            [editCaseVC setExistingCourtObj:[Court fetchCourtLocally:caseObj.localCourtId]];
            
            [self.navigationController pushViewController:editCaseVC animated:YES];
            
            [cell hideUtilityButtonsAnimated:YES];
            
            [self.view endEditing:YES];
            
            break;
        }
        case 1:
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
                    if (ShareObj.hasAdminAccess) {
                        [Cases updatedCasePropertyofCase:[[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] withProperty:kCaseIsDeleted andValue:@1];
                        [self deleteCase:[[arrCases[indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row]];

                        [self fetchCasesLocally:nil];
                    }
                    else {
                        UI_ALERT(@"", @"You have given access to one of your subordinate.\nSo, you can not modify any records.", nil);
                    }
                }
                    break;
                default:
                    break;
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
                    if ([self respondsToSelector:@selector(viewDidLoad)]) {
                        [Global showNotificationWithTitle:@"Case can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                    }
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"Case can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*- (void)fetchCases:(PagingPriority)pagingPriority withCompletionHandler:(void (^)(BOOL finished))completionHandler
 {
 if (IS_INTERNET_CONNECTED) {
 
 @try {
 
 isRequestForOlder = pagingPriority == kPriorityOlder ? YES : NO;
 
 switch (pagingPriority) {
 case kPriorityInitial: {
 
 }
 break;
 case kPriorityNewer: {
 Cases *objCase = [arrCases firstObject];
 indexNewer = objCase.caseId.integerValue;
 }
 break;
 case kPriorityOlder: {
 Cases *objCase = [arrCases lastObject];
 indexOlder = objCase.caseId.integerValue;
 }
 break;
 default:
 break;
 }
 
 //            if (pagingPriority != kPriorityInitial) {
 //                if (isRequestForOlder) {
 //                    Cases *objCase = [arrCases lastObject];
 //                    indexOlder = objCase.caseId.integerValue;
 //                }
 //                else {
 //                    Cases *objCase = [arrCases firstObject];
 //                    indexNewer = objCase.caseId.integerValue;
 //                }
 //            }
 
 NSDictionary *params = @{
 kAPIMode: kloadCase,
 kAPIuserId: USER_ID,
 kAPIisBefore: pagingPriority == kPriorityNewer ? @1 : @0,
 kAPIindex: pagingPriority == kPriorityInitial ? @0 : (pagingPriority == kPriorityNewer ? @(indexNewer) : @(indexOlder)),
 kAPIoffset: @10
 };
 
 [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 if (responseObject == nil) {
 if (arrCases.count > 0) {
 [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
 }
 else {
 [lblErrorMsg setText:kSOMETHING_WENT_WRONG];
 
 [self showSpinner:NO withError:YES];
 
 [btnReload setHidden:NO];
 }
 }
 else {
 if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
 UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
 }
 else {
 
 NSMutableArray *arrCourt = [[NSMutableArray alloc] init];
 if (!arrIndexPaths) {
 arrIndexPaths = [[NSMutableArray alloc] init];
 }
 
 [arrIndexPaths removeAllObjects];
 
 NSArray *arrCasesObj = [responseObject valueForKey:kAPIcaseList];
 
 if (arrCasesObj.count > 0) {
 for (NSDictionary *caseObj in [responseObject valueForKey:kAPIcaseList]) {
 Cases *objCase = [Cases saveCase:caseObj forUser:USER_ID];
 [arrCourt addObject:objCase];
 }
 
 NSInteger totalArrCount = arrCases.count + arrCourt.count;
 
 NSInteger startIndex = isRequestForOlder ? arrCases.count : 0;
 NSInteger endIndex = isRequestForOlder ? totalArrCount : arrCourt.count;
 
 for (NSInteger i = startIndex; i < endIndex; i++) {
 [arrCases insertObject:isRequestForOlder ? arrCourt[i-startIndex] : arrCourt[i] atIndex:i];
 
 [arrIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
 }
 
 [self showSpinner:NO withError:NO];
 }
 else {
 
 if (arrCases.count > 0) {
 [Global showNotificationWithTitle:@"All Cases Loaded!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
 }
 else {
 [lblErrorMsg setText:@"No Cases found."];
 
 [self showSpinner:NO withError:YES];
 
 [btnReload setHidden:NO];
 }
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
 }*/

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
