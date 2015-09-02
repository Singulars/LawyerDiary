//
//  Courts.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "Courts.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "CourtDetail.h"
#import "Court.h"
#import "SVPullToRefresh.h"
#import "CourtDetail.h"

SubordinateAdmin *selectedAdminObj;

@interface Courts () <SWTableViewCellDelegate>
{
    NSInteger indexOlder;
    NSInteger indexNewer;
    BOOL isRequestForOlder;
}
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) NSMutableArray *arrCourts;
@property (nonatomic, strong) NSMutableArray *arrIndexPaths;
@property (nonatomic) CGRect originalFrame;
@end

@implementation Courts

@synthesize arrCourts;
@synthesize arrIndexPaths;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblErrorMsg setTextColor:DARK_GRAY_COLOR];
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];
    
//    [btnAddCourt setBackgroundColor:APP_TINT_COLOR];
//    [btnAddCourt setTintColor:WHITE_COLOR];
//    [btnAddCourt setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(IMG_btn_add, kImageRenderModeTemplate) forState:UIControlStateNormal];
    
    [Global applyCornerRadiusToViews:@[btnAddCourt] withRadius:ViewHeight(btnAddCourt)/2 borderColor:CLEARCOLOUR andBorderWidth:0];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    
    [btnReload setHidden:YES];
    
    [self loadCourts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCourtsLocally:) name:kFetchCourts object:nil];
    
//    [Court deleteCourtsForUser:USER_ID];
    /*
    arrCourts = [[NSMutableArray alloc] init];
    
    __weak Courts *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowsAtTop];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowsAtBottom];
    }];
    
//    [self loadCourts];
    
    if (arrCourts.count == 0) {
        [self showSpinner:YES withError:NO];
        
        [self fetchCourtsWithCompletionHandler:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }*/
}

- (void)fetchCourtsLocally:(NSNotification *)aNotification
{
    if (!arrCourts) {
        arrCourts = [[NSMutableArray alloc] init];
    }
    
    [arrCourts removeAllObjects];
    [arrCourts addObjectsFromArray:[Court fetchCourtsForAdmin]];
    
    [self.tableView reloadData];
    
    if (arrCourts.count > 0) {
        [self showSpinner:NO withError:NO];
    }
}

- (void)loadCourts
{
    if (IS_INTERNET_CONNECTED) {
        
        [btnReload setHidden:YES];
        
        [self fetchCourtsWithCompletionHandler:^(BOOL finished) {
            [self setBarButton:AddBarButton];
            
            [self fetchCourtsLocally:nil];
        }];
    }
    else {
        
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        
        [self fetchCourtsLocally:nil];
        
        [self setBarButton:AddBarButton];
        
        if (arrCourts.count > 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:@"No records stored locally!\n Please connect to the internet to get updated data."];
            [self showSpinner:NO withError:YES];
            
            [btnReload setHidden:NO];
        }
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

- (IBAction)btnReloadTaped:(id)sender
{
    [self loadCourts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
//    self.originalFrame = viewAddCourt.frame;
}

- (void)fetchCourtsWithCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kloadCourts,
                                     kAPIuserId: USER_ID
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
                        NSArray *arrCourtObj = [responseObject valueForKey:kAPIcourData];
                        
                        if (arrCourtObj.count > 0) {
                            
                            if (arrCourts.count > 0) {
                                [Court deleteCourtsForAdmin];
                            }
                            
                            for (NSDictionary *courtObj in arrCourtObj) {
                                [Court saveCourt:courtObj forSubordiante:NO withAdminDetail:nil];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
                            [Court deleteCourtsForAdmin];
                            
                            [lblErrorMsg setText:@"No Courts Found."];
                            
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

- (void)barBtnReloadTaped:(id)sender
{
    [self loadCourts];
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
/*
- (void)showSpinner:(BOOL)flag withError:(BOOL)errorFlag
{
    if (flag) {
        [btnReload setHidden:YES];
        [lblErrorMsg setHidden:YES];
        [self.tableView setHidden:YES];
        //        [viewAddCourt setHidden:YES];
        [self.spinnerView startAnimating];
        
        //        [self.navigationItem setRightBarButtonItem:nil];
    }
    else {
        if (errorFlag) {
            [lblErrorMsg setHidden:NO];
            [self.tableView setHidden:YES];
            //            [viewAddCourt setHidden:YES];
        }
        else {
            [lblErrorMsg setHidden:YES];
            [self.tableView setHidden:NO];
            //            [viewAddCourt setHidden:NO];
            
            [btnReload setHidden:YES];
        }
        
        [self.spinnerView stopAnimating];
        
        //        [self.navigationItem setRightBarButtonItem:barBtnSync];
    }
}

- (void)insertRowsAtTop {
    
    [self fetchCourts:kPriorityNewer withCompletionHandler:^(BOOL finished) {
        if (arrIndexPaths.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        }
        
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}


- (void)insertRowsAtBottom {
    
    [self fetchCourts:kPriorityOlder withCompletionHandler:^(BOOL finished) {
        if (arrIndexPaths.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
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
                
                CourtDetail *courtDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtDetail"];
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:courtDetailVC];
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

- (IBAction)btnAddTaped:(id)sender
{
    
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCourts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CourtCell";
    CourtCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CourtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDelegate:self];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60];
    [cell configureCellWithCourtObj:arrCourts[indexPath.row] forIndexPath:indexPath];
    
    return cell;
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
                    if (ShareObj.hasAdminAccess) {
                        Court *toBeDeletedCourtObj = arrCourts[indexPath.row];
                        
                        if (![Cases isThisCourtExist:toBeDeletedCourtObj.localCourtId]) {
                            
                            [self.tableView beginUpdates];
                            
                            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                            
                            if ([toBeDeletedCourtObj.isSynced isEqualToNumber:@0] && [toBeDeletedCourtObj.courtId isEqualToNumber:@-1]) {
                                [Court deleteCourt:toBeDeletedCourtObj.localCourtId];
                            }
                            else {
                                [Court updatedCourtPropertyofCourt:arrCourts[indexPath.row] withProperty:kCourtIsDeleted andValue:@1];
                                [self deleteCourt:arrCourts[indexPath.row]];
                            }
                            
                            [arrCourts removeObjectAtIndex:indexPath.row];
                            [self.tableView endUpdates];
                            
                            if (arrCourts.count == 0) {
                                [lblErrorMsg setText:@"No Courts Found."];
                                [self showSpinner:NO withError:YES];
                            }
                        }
                        else {
                            UI_ALERT(@"", @"This Court is belongs to one of the existing Case. So you can't delete this Court. To delete this Court, you've to delete Case first.", nil);
                        }
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
    CourtDetail *courtDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtDetail"];
    [courtDetailVC setCourtObj:arrCourts[indexPath.row]];
    [self.navigationController pushViewController:courtDetailVC animated:YES];
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                [tableView beginUpdates];
                if (editingStyle == UITableViewCellEditingStyleDelete) {
                    
                    Court *toBeDeletedCourtObj = arrCourts[indexPath.row];
                    
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                    
                    if ([toBeDeletedCourtObj.isSynced isEqualToNumber:@0] && [toBeDeletedCourtObj.courtId isEqualToNumber:@-1]) {
                        [Court deleteCourt:toBeDeletedCourtObj.localCourtId];
                    }
                    else {
                        [Court updatedCourtPropertyofCourt:arrCourts[indexPath.row] withProperty:kCourtIsDeleted andValue:@1];
                        [self deleteCourt:arrCourts[indexPath.row]];
                    }
                    
                    [arrCourts removeObjectAtIndex:indexPath.row];
                }
                [tableView endUpdates];
                
                if (arrCourts.count == 0) {
                    [lblErrorMsg setText:@"No Courts found."];
                    [self showSpinner:NO withError:YES];
                }
            }
        }
            break;
        default:
            break;
    }
}*/

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

- (void)deleteCourt:(Court *)objCourt
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kdeleteCourt,
                                     kAPIuserId: USER_ID,
                                     kAPIcourtId: objCourt.courtId,
                                     kAPIadminId: @0
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:@"Court can't be deleted right now!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"Court can't be deleted right now!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        [Court deleteCourt:objCourt.courtId];
                        [Global showNotificationWithTitle:@"Court deleted successfully!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Global showNotificationWithTitle:@"Court can't be deleted right now!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
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


#pragma mark - UIScrollViewDelegate
#pragma mark -

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSInteger yOffset = scrollView.contentOffset.y;
//    if (yOffset > 0) {
//        viewAddCourt.frame = CGRectMake(viewAddCourt.frame.origin.x, self.originalFrame.origin.y + yOffset, viewAddCourt.frame.size.width, viewAddCourt.frame.size.height);
//    }
//    if (yOffset < 1) viewAddCourt.frame = self.originalFrame;
//}

#pragma mark - Memory Management
#pragma mark -
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
