//
//  Clients.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "ClientsViewController.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "Client.h"
#import "ClientDetail.h"
#import "ClientCell.h"

BOOL isForSubordinate;
SubordinateAdmin *selectedAdminObj;

typedef NS_ENUM(NSUInteger, InputFieldTags) {
    kTagClientName = 0,
    kTagOppositionName,
    kTagOppositionLawyerName,
    kTagMobile,
    kTagEmail,
    kTagCaseNo,
    kTagAddress,
    kTagCourtName,
    kTagLastHeardDate,
    kTagNextHearingDate
};
@interface ClientsViewController () <SWTableViewCellDelegate>
{
    NSInteger indexOlder;
    NSInteger indexNewer;
    BOOL isRequestForOlder;
}
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) NSMutableArray *arrClients;
@property (nonatomic, strong) NSMutableArray *arrIndexPaths;
@property (nonatomic) CGRect originalFrame;

@end

@implementation ClientsViewController

@synthesize arrClients;
@synthesize arrIndexPaths;

#pragma mark - ViewLifeCycle
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblErrorMsg setTextColor:DARK_GRAY_COLOR];
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];
//    [Global applyCornerRadiusToViews:@[btnAddClient] withRadius:ViewHeight(btnAddClient)/2 borderColor:CLEARCOLOUR andBorderWidth:0];

    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    [btnReload setHidden:YES];

    [self loadClients];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchClientsLocally:) name:kFetchClients object:nil];
    
    
//    [Client deleteCientsForUser:USER_ID];
    
  /*  arrClients = [[NSMutableArray alloc] init];
    
    __weak Clients *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowsAtTop];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowsAtBottom];
    }];
    
    //    [self loadCourts];
    
    if (arrClients.count == 0) {
        [self showSpinner:YES withError:NO];
        
        [self fetchClients:kPriorityInitial withCompletionHandler:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }*/
}

- (IBAction)btnReloadTaped:(id)sender
{
    [self loadClients];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isForSubordinate = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
//    self.originalFrame = viewAddClient.frame;
}


/*- (void)insertRowsAtTop {
    
    [self fetchClients:kPriorityNewer withCompletionHandler:^(BOOL finished) {
        if (arrIndexPaths.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        }
        
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}


- (void)insertRowsAtBottom {
    
    [self fetchClients:kPriorityOlder withCompletionHandler:^(BOOL finished) {
        if (arrIndexPaths.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}*/

- (void)fetchClientsLocally:(NSNotification *)aNotification
{
    if (!arrClients) {
        arrClients = [[NSMutableArray alloc] init];
    }
    
    [arrClients removeAllObjects];
    [arrClients addObjectsFromArray:[Client fetchClientsForAdmin]];
    
    [self.tableView reloadData];
    
    if (arrClients.count > 0) {
        [self showSpinner:NO withError:NO];
    }
}

- (void)loadClients
{
//    if (!arrClients) {
//        arrClients = [[NSMutableArray alloc] init];
//    }
//    [arrClients removeAllObjects];
//    [arrClients addObjectsFromArray:[Client fetchClients:USER_ID]];
//    if (arrClients.count == 0) {
////        [self fetchClients];
//    }
//    [self.tableView reloadData];
    
    if (IS_INTERNET_CONNECTED) {
        
        [self fetchClientsWithCompletionHandler:^(BOOL finished) {
            [self setBarButton:AddBarButton];
            
            [self fetchClientsLocally:nil];
        }];
    }
    else {
        
        [self fetchClientsLocally:nil];
        
        [self setBarButton:AddBarButton];
        
        if (arrClients.count > 0 || arrClients.count == 0) {
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
                
                ClientDetail *clientDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ClientDetail"];
            
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:clientDetailVC];
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
    return arrClients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClientCell";
    ClientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ClientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDelegate:self];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60];
    [cell configureCellWithClientObj:arrClients[indexPath.row] forIndexPath:indexPath];
    
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
                    
                        Client *toBeDeletedClientObj = arrClients[indexPath.row];
                        
                        [self.tableView beginUpdates];
                        
                        if (![Cases isThisClientExist:toBeDeletedClientObj.localClientId]) {
                            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                            //                    [self deleteClient:arrClients[indexPath.row]];
                            if ([toBeDeletedClientObj.isSynced isEqualToNumber:@0] && [toBeDeletedClientObj.clientId isEqualToNumber:@-1]) {
                                [Client deleteClient:toBeDeletedClientObj.localClientId];
                            }
                            else {
                                [Client updatedClientPropertyofClient:arrClients[indexPath.row] withProperty:kClientIsDeleted andValue:@1];
                                [self deleteClient:arrClients[indexPath.row]];
                            }
                            
                            [arrClients removeObjectAtIndex:indexPath.row];
                            //                    if (1) {
                            //
                            //                    }
                            //                    else {
                            
                            //                    }
                            [self.tableView endUpdates];
                            
                            if (arrClients.count == 0) {
                                [lblErrorMsg setText:@"No Clients Found."];
                                [self showSpinner:NO withError:YES];
                            }
                        }
                        else {
                            UI_ALERT(@"", @"This Client is belongs to one of the existing Case. So you can't delete this Client. To delete this Court, you've to delete Case first.", nil);
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
    ClientDetail *clientDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ClientDetail"];
    [clientDetailVC setClientObj:arrClients[indexPath.row]];
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:clientDetailVC];
    [self.navigationController pushViewController:clientDetailVC animated:YES];
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
                    
                    Client *toBeDeletedClientObj = arrClients[indexPath.row];
                    
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
//                    [self deleteClient:arrClients[indexPath.row]];
                    if ([toBeDeletedClientObj.isSynced isEqualToNumber:@0] && [toBeDeletedClientObj.clientId isEqualToNumber:@-1]) {
                        [Client deleteClient:toBeDeletedClientObj.localClientId];
                    }
                    else {
                        [Client updatedClientPropertyofClient:arrClients[indexPath.row] withProperty:kClientIsDeleted andValue:@1];
                        [self deleteClient:arrClients[indexPath.row]];
                    }
                    
                    [arrClients removeObjectAtIndex:indexPath.row];
//                    if (1) {
//                        
//                    }
//                    else {
                    
//                    }
                }
                [tableView endUpdates];
                
                if (arrClients.count == 0) {
                    [lblErrorMsg setText:@"No Clients found."];
                    [self showSpinner:NO withError:YES];
                }
            }
        }
            break;
        default:
            break;
    }
}
*/

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

- (void)deleteClient:(Client *)objClient
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kdeleteClient,
                                     kAPIuserId: USER_ID,
                                     kAPIclientId: objClient.clientId
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
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

/*- (void)fetchClients:(PagingPriority)pagingPriority withCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            isRequestForOlder = pagingPriority == kPriorityOlder ? YES : NO;
            
            switch (pagingPriority) {
                case kPriorityInitial: {
                    
                }
                    break;
                case kPriorityNewer: {
                    Client *objClient = [arrClients firstObject];
                    indexNewer = objClient.clientId.integerValue;
                }
                    break;
                case kPriorityOlder: {
                    Client *objClient = [arrClients lastObject];
                    indexOlder = objClient.clientId.integerValue;
                }
                    break;
                default:
                    break;
            }
            
            
            //            if (pagingPriority != kPriorityInitial) {
            //                if (isRequestForOlder) {
            //                    Client *objClient = [arrClients lastObject];
            //                    indexOlder = objClient.clientId.integerValue;
            //                }
            //                else {
            //                    Client *objClient = [arrClients firstObject];
            //                    indexNewer = objClient.clientId.integerValue;
            //                }
            //            }
            
            NSDictionary *params = @{
                                     kAPIMode: kloadClients,
                                     kAPIuserId: USER_ID,
                                     kAPIisBefore: pagingPriority == kPriorityNewer ? @1 : @0,
                                     kAPIindex: pagingPriority == kPriorityInitial ? @0 : (pagingPriority == kPriorityNewer ? @(indexNewer) : @(indexOlder)),
                                     kAPIoffset: @10
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self showSpinner:NO withError:NO];
                
                if (responseObject == nil) {
                    if (arrClients.count > 0) {
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
                        
                        NSMutableArray *arrClient = [[NSMutableArray alloc] init];
                        if (!arrIndexPaths) {
                            arrIndexPaths = [[NSMutableArray alloc] init];
                        }
                        
                        [arrIndexPaths removeAllObjects];
                        
                        NSArray *arrClinetObj = [responseObject valueForKey:kAPIclientData];
                        
                        if (arrClinetObj.count > 0) {
                            if (arrClients.count > 0) {
                                [Client deleteCientsForUser:USER_ID];
                            }
                            
                            for (NSDictionary *clientObj in arrClinetObj) {
                                //Client *objClient = [Client saveClient:clientObj forUser:USER_ID];
                                [Client saveClients:clientObj forSubordiante:NO withAdminDetail:nil];
                                
                                [arrClient addObject:clientObj];
                                
                                }
                            
                            NSInteger totalArrCount = arrClients.count + arrClient.count;
                            
                            NSInteger startIndex = isRequestForOlder ? arrClients.count : 0;
                            NSInteger endIndex = isRequestForOlder ? totalArrCount : arrClient.count;
                            
                            for (NSInteger i = startIndex; i < endIndex; i++) {
                                [arrClients insertObject:isRequestForOlder ? arrClient[i-startIndex] : arrClient[i] atIndex:i];
                                
                                [arrIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
                            if (arrClients.count > 0) {
                                [Global showNotificationWithTitle:@"All Clients Loaded!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
                            }
                            else {
                                [lblErrorMsg setText:@"No Clients found."];
                                
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
                
                if (arrClients.count > 0) {
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
- (void)barBtnReloadTaped:(id)sender
{
    [self loadClients];
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

- (void)fetchClientsWithCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kloadClients,
                                     kAPIuserId: USER_ID
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
                        NSArray *arrCaseObj = [responseObject valueForKey:kAPIclientData];
                        
                        if (arrCaseObj.count > 0) {
                            
                            [Client deleteCientsForAdmin];
                            
                            for (NSDictionary *courtObj in arrCaseObj) {
                                [Client saveClients:courtObj forSubordiante:NO withAdminDetail:nil];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
                            [Client deleteCientsForAdmin];
                            
                            [lblErrorMsg setText:@"No Clients Found."];
                            
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
     
        completionHandler(YES);
        
//        [self showSpinner:NO withError:YES];
//        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}


#pragma mark - UIScrollViewDelegate
#pragma mark -

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSInteger yOffset = scrollView.contentOffset.y;
//    if (yOffset > 0) {
//        viewAddClient.frame = CGRectMake(viewAddClient.frame.origin.x, self.originalFrame.origin.y + yOffset, viewAddClient.frame.size.width, viewAddClient.frame.size.height);
//    }
//    if (yOffset < 1) viewAddClient.frame = self.originalFrame;
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
