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
    UITextField *activeTextField;
    BOOL isPickerVisible;
    
}
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) NSMutableArray *arrClients;
@property (nonatomic) CGRect originalFrame;

@end

@implementation Clients

@synthesize arrClients;

#pragma mark - ViewLifeCycle
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:WHITE_COLOR];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT fontColor:WHITE_COLOR andFontSize:22 andStrokeColor:CLEARCOLOUR]];
    
    [btnAddClient setBackgroundColor:APP_TINT_COLOR];
    [btnAddClient setTintColor:WHITE_COLOR];
    [btnAddClient setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(IMG_btn_add, kImageRenderModeTemplate) forState:UIControlStateNormal];
    
    [Global applyCornerRadiusToViews:@[btnAddClient] withRadius:ViewHeight(btnAddClient)/2 borderColor:CLEARCOLOUR andBorderWidth:0];
    
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
    [self loadClients];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.originalFrame = viewAddClient.frame;
}

- (void)fetchClients
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            [self showSpinner:YES withError:NO];
            
            NSDictionary *params = @{
                                     kAPIMode: kloadClients,
                                     kAPIuserId: USER_ID
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self showSpinner:NO withError:NO];
                
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        MY_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        [Client deleteCientsForUser:USER_ID];
                        for (NSDictionary *clientObj in [responseObject valueForKey:kAPIclientData]) {
                            [Client saveClient:clientObj forUser:USER_ID];
                        }
                        
                        NSArray *arrCourt = [responseObject valueForKey:kAPIclientData];
                        if (arrCourt.count > 0) {
                            [arrClients removeAllObjects];
                            [arrClients addObjectsFromArray:[Client fetchClients:USER_ID]];
                        }
                        else {
                            [Global showNotificationWithTitle:arrClients.count > 0 ? @"All Clients Loaded!" : @"No Clients to show!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
                        }
                        [self.tableView reloadData];
                        
                    }
                }
                
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

- (void)loadClients
{
    if (!arrClients) {
        arrClients = [[NSMutableArray alloc] init];
    }
    [arrClients removeAllObjects];
    [arrClients addObjectsFromArray:[Client fetchClients:USER_ID]];
    if (arrClients.count == 0) {
        [self fetchClients];
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
        
        [self.navigationItem setRightBarButtonItem:nil];
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
        
        [self.navigationItem setRightBarButtonItem:barBtnSync];
    }
}
#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    SetStatusBarLightContent(NO);
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)barBtnSyncTaped:(id)sender
{
    [self fetchClients];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger yOffset = scrollView.contentOffset.y;
    if (yOffset > 0) {
        viewAddClient.frame = CGRectMake(viewAddClient.frame.origin.x, self.originalFrame.origin.y + yOffset, viewAddClient.frame.size.width, viewAddClient.frame.size.height);
    }
    if (yOffset < 1) viewAddClient.frame = self.originalFrame;
}

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
