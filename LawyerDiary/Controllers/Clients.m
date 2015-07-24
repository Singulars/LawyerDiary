//
//  Clients.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "Clients.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "Client.h"
#import "ClientDetail.h"
#import "ClientCell.h"

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
@interface Clients ()
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

@implementation Clients

@synthesize arrClients;
@synthesize arrIndexPaths;

#pragma mark - ViewLifeCycle
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:WHITE_COLOR];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT fontColor:WHITE_COLOR andFontSize:22 andStrokeColor:CLEARCOLOUR]];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    
//    [Client deleteCientsForUser:USER_ID];
    
    arrClients = [[NSMutableArray alloc] init];
    
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
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
//    self.originalFrame = viewAddClient.frame;
}

- (void)fetchClients:(PagingPriority)pagingPriority withCompletionHandler:(void (^)(BOOL finished))completionHandler
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
                        
                        [self showSpinner:NO withError:NO];
                    }
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        MY_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        
                        NSMutableArray *arrClient = [[NSMutableArray alloc] init];
                        if (!arrIndexPaths) {
                            arrIndexPaths = [[NSMutableArray alloc] init];
                        }
                        
                        [arrIndexPaths removeAllObjects];
                        
                        NSArray *arrClinetObj = [responseObject valueForKey:kAPIclientData];
                        
                        if (arrClinetObj.count > 0) {
                            for (NSDictionary *clientObj in [responseObject valueForKey:kAPIclientData]) {
                                Client *objClient = [Client saveClient:clientObj forUser:USER_ID];
                                [arrClient addObject:objClient];
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
                                
                                [self showSpinner:NO withError:NO];
                            }
                        }
                    }
                }
                completionHandler(YES);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self showSpinner:NO withError:YES];
                
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
        [self showSpinner:NO withError:YES];
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

- (void)insertRowsAtTop {
    
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
}

- (void)loadClients
{
    if (!arrClients) {
        arrClients = [[NSMutableArray alloc] init];
    }
    [arrClients removeAllObjects];
    [arrClients addObjectsFromArray:[Client fetchClients:USER_ID]];
    if (arrClients.count == 0) {
//        [self fetchClients];
    }
    [self.tableView reloadData];
}
- (void)showSpinner:(BOOL)flag withError:(BOOL)errorFlag
{
    if (flag) {
        [lblErrorMsg setHidden:YES];
        [self.tableView setHidden:YES];
        [viewAddClient setHidden:YES];
        [self.spinnerView startAnimating];
        
//        [self.navigationItem setRightBarButtonItem:nil];
    }
    else {
        if (errorFlag) {
            [lblErrorMsg setHidden:NO];
            [self.tableView setHidden:YES];
            [viewAddClient setHidden:YES];
        }
        else {
            [lblErrorMsg setHidden:YES];
            [self.tableView setHidden:NO];
            [viewAddClient setHidden:NO];;
        }
        
        [self.spinnerView stopAnimating];
        
//        [self.navigationItem setRightBarButtonItem:barBtnSync];
    }
}
#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    SetStatusBarLightContent(NO);
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
    return arrClients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClientCell";
    ClientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ClientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell configureCellWithClientObj:arrClients[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClientDetail"];
    ClientDetail *clientDetailVC = navController.viewControllers[0];
    [clientDetailVC setClientObj:arrClients[indexPath.row]];
    [self.navigationController pushViewController:clientDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        [self deleteClient:arrClients[indexPath.row]];
        [arrClients removeObjectAtIndex:indexPath.row];
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
                        //                        MY_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
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
