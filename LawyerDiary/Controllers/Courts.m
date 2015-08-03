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

@interface Courts ()
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
    
    [self.navigationController.navigationBar setTintColor:APP_TINT_COLOR];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:APP_TINT_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];
    
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
    
//    [Court deleteCourtsForUser:USER_ID];
    
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
        
        [self fetchCourts:kPriorityInitial withCompletionHandler:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }
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

- (void)fetchCourts:(PagingPriority)pagingPriority withCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            isRequestForOlder = pagingPriority == kPriorityOlder ? YES : NO;
            
            switch (pagingPriority) {
                case kPriorityInitial: {
                    
                }
                    break;
                case kPriorityNewer: {
                    Court *objCort = [arrCourts firstObject];
                    indexNewer = objCort.courtId.integerValue;
                }
                    break;
                case kPriorityOlder: {
                    Court *objCort = [arrCourts lastObject];
                    indexOlder = objCort.courtId.integerValue;
                }
                    break;
                default:
                    break;
            }
            
//            if (pagingPriority != kPriorityInitial) {
//                if (isRequestForOlder) {
//                    Court *objCort = [arrCourts lastObject];
//                    indexOlder = objCort.courtId.integerValue;
//                }
//                else {
//                    Court *objCort = [arrCourts firstObject];
//                    indexNewer = objCort.courtId.integerValue;
//                }
//            }
            
            NSDictionary *params = @{
                                     kAPIMode: kloadCourts,
                                     kAPIuserId: USER_ID,
                                     kAPIisBefore: pagingPriority == kPriorityNewer ? @1 : @0,
                                     kAPIindex: pagingPriority == kPriorityInitial ? @0 : (pagingPriority == kPriorityNewer ? @(indexNewer) : @(indexOlder)),
                                     kAPIoffset: @10
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (responseObject == nil) {
                    if (arrCourts.count > 0) {
                        [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                    }
                    else {
                        [lblErrorMsg setText:kSOMETHING_WENT_WRONG];
                        
                        [self showSpinner:NO withError:NO];
                    }
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        MY_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        
                        NSMutableArray *arrCourt = [[NSMutableArray alloc] init];
                        if (!arrIndexPaths) {
                            arrIndexPaths = [[NSMutableArray alloc] init];
                        }
                        
                        [arrIndexPaths removeAllObjects];
                        
                        NSArray *arrCourtObj = [responseObject valueForKey:kAPIcourData];
                        
                        if (arrCourtObj.count > 0) {
                            for (NSDictionary *courtObj in [responseObject valueForKey:kAPIcourData]) {
                                Court *objCourt = [Court saveCourt:courtObj forUser:USER_ID];
                                [arrCourt addObject:objCourt];
                            }
                            
                            NSInteger totalArrCount = arrCourts.count + arrCourt.count;
                            
                            NSInteger startIndex = isRequestForOlder ? arrCourts.count : 0;
                            NSInteger endIndex = isRequestForOlder ? totalArrCount : arrCourt.count;
                            
                            for (NSInteger i = startIndex; i < endIndex; i++) {
                                [arrCourts insertObject:isRequestForOlder ? arrCourt[i-startIndex] : arrCourt[i] atIndex:i];
                                
                                [arrIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
                            if (arrCourts.count > 0) {
                                [Global showNotificationWithTitle:@"All Courts Loaded!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
                            }
                            else {
                                [lblErrorMsg setText:@"No Courts found."];
                                
                                [self showSpinner:NO withError:NO];
                            }
                        }
                    }
                }
                completionHandler(YES);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self showSpinner:NO withError:YES];
                
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
                
                [Global showNotificationWithTitle:kREQUEST_TIME_OUT titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                
                if (arrCourts.count > 0) {
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

- (void)loadCourts
{
    if (!arrCourts) {
        arrCourts = [[NSMutableArray alloc] init];
    }
    [arrCourts removeAllObjects];
    [arrCourts addObjectsFromArray:[Court fetchCourts:USER_ID]];
    if (arrCourts.count == 0) {
        [self fetchCourts:kPriorityInitial withCompletionHandler:^(BOOL finished) {
            
        }];
    }
    [self.tableView reloadData];
}

- (void)showSpinner:(BOOL)flag withError:(BOOL)errorFlag
{
    if (flag) {
        [lblErrorMsg setHidden:YES];
        [self.tableView setHidden:YES];
        [viewAddCourt setHidden:YES];
        [self.spinnerView startAnimating];
        
//        [self.navigationItem setRightBarButtonItem:nil];
    }
    else {
        if (errorFlag) {
            [lblErrorMsg setHidden:NO];
            [self.tableView setHidden:YES];
            [viewAddCourt setHidden:YES];
        }
        else {
            [lblErrorMsg setHidden:YES];
            [self.tableView setHidden:NO];
            [viewAddCourt setHidden:NO];;
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
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
//    SetStatusBarLightContent(NO);
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)barBtnAddTaped:(id)sender
{
    
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
    
    [cell configureCellWithCourtObj:arrCourts[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtDetail"];
    CourtDetail *courtDetailVC = navController.viewControllers[0];
    [courtDetailVC setCourtObj:arrCourts[indexPath.row]];
    [self.navigationController pushViewController:courtDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        [self deleteCourt:arrCourts[indexPath.row]];
        [arrCourts removeObjectAtIndex:indexPath.row];
    }
    [tableView endUpdates];
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

- (void)deleteCourt:(Court *)objCourt
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kdeleteCourt,
                                     kAPIuserId: USER_ID,
                                     kAPIcourtId: objCourt.courtId
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:@"Court can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:@"Court can't be deleted right now" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        MY_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
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
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
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
