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

@interface ClientCases ()
{
    NSInteger indexOlder;
    NSInteger indexNewer;
    BOOL isRequestForOlder;
    
    BOOL isRequesting;
}
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) NSMutableArray *arrCases;
@property (nonatomic, strong) NSMutableArray *arrIndexPaths;

@end

@implementation ClientCases

@synthesize arrCases;
@synthesize arrIndexPaths;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SetStatusBarHidden(NO);
    
    NSLog(@"Fonts - %@", [UIFont fontNamesForFamilyName:APP_FONT]);
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 44, 0, 0)];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(caseSaved:)
                                                 name:@"CaseSaved"
                                               object:nil];
    
//    [Cases deleteCientsForUser:USER_ID];
    
    arrCases = [[NSMutableArray alloc] init];
    
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
    }
}

- (IBAction)btnReloadTaped:(id)sender
{
    [self showSpinner:YES withError:NO];
    [self fetchCases:kPriorityInitial withCompletionHandler:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}

- (void)caseSaved:(NSNotification *)aNotification
{
    [arrCases removeAllObjects];
    
    [arrCases addObjectsFromArray:[Cases fetchCases:USER_ID]];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!arrCases) {
        arrCases = [[NSMutableArray alloc] init];
    }
    [arrCases removeAllObjects];
    
    [arrCases addObjectsFromArray:[Cases fetchCases:USER_ID]];
    [self.tableView reloadData];
    
    if (arrCases.count > 0) {
        [self showSpinner:NO withError:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
    //    self.originalFrame = viewAddCourt.frame;
}

- (void)fetchCases:(PagingPriority)pagingPriority withCompletionHandler:(void (^)(BOOL finished))completionHandler
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
                        MY_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
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
}

- (void)loadCases
{
    if (!arrCases) {
        arrCases = [[NSMutableArray alloc] init];
    }
    [arrCases removeAllObjects];
    [arrCases addObjectsFromArray:[Cases fetchCases:USER_ID]];
    if (arrCases.count == 0) {
        [self fetchCases:kPriorityInitial withCompletionHandler:^(BOOL finished) {
            
        }];
    }
    [self.tableView reloadData];
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

- (void)insertRowsAtTop {
    
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
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)barBtnAddTaped:(id)sender
{
    
}


#pragma mark - UITableViewDataSource / UITableViewDelegate
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CaseCell";
    CaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell configureCellWithCaseObj:arrCases[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourtDetail"];
//    CourtDetail *courtDetailVC = navController.viewControllers[0];
//    [courtDetailVC setCourtObj:arrCourts[indexPath.row]];
//    [self.navigationController pushViewController:courtDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        [self deleteCase:arrCases[indexPath.row]];
        [arrCases removeObjectAtIndex:indexPath.row];
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
                        //                        MY_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
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
