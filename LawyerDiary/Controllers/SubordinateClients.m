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

@interface SubordinateClients ()

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
    
    [self loadSubordinatesClients];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)barBtnAddTaped:(id)sender
{
    ChooseAdmin *chooseAdminVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseAdmin"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:chooseAdminVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)barBtnReloadTaped:(id)sender
{
    [self loadSubordinatesClients];
}
- (void)loadSubordinatesClients
{
    if (IS_INTERNET_CONNECTED) {
        
        [self fetchSubordinatesWithCompletionHandler:^(BOOL finished) {
            [self setBarButton:AddBarButton];
            
            if (!arrClients) {
                arrClients = [[NSMutableArray alloc] init];
            }
            
            [arrClients removeAllObjects];
            [arrClients addObjectsFromArray:[Client fetchClientsForSubordinate]];
            
            [self.tableView reloadData];
        }];
    }
    else {
        
        if (arrClients.count > 0) {
            [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [lblErrorMsg setText:kCHECK_INTERNET];
            [self showSpinner:NO withError:YES];
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
        [cell configureCellWithClientObj:[clientRecords objectAtIndex:indexPath.row] forIndexPath:indexPath];
        
        return cell;
    }
    else {
        return cellNoRecords;
    }
    return nil;
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
                        MY_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        NSArray *arrSubordinates = [responseObject valueForKey:kAPIclientData];
                        
                        if (arrSubordinates.count > 0) {
                            
                            for (NSDictionary *obj in arrSubordinates) {
                                [SubordinateAdmin saveSubordinateAdmin:obj];
                                [Client saveClientsForSubordinate:obj];
                            }
                            
                            [self showSpinner:NO withError:NO];
                        }
                        else {
                            
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
