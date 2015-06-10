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

@interface Courts ()
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) NSArray *arrCourts;
@property (nonatomic) CGRect originalFrame;
@end

@implementation Courts

@synthesize arrCourts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:WHITE_COLOR];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT fontColor:WHITE_COLOR andFontSize:22 andStrokeColor:CLEARCOLOUR]];
    
    [btnAddCourt setBackgroundColor:APP_TINT_COLOR];
    [btnAddCourt setTintColor:WHITE_COLOR];
    [btnAddCourt setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(IMG_btn_add, kImageRenderModeTemplate) forState:UIControlStateNormal];
    
    [Global applyCornerRadiusToViews:@[btnAddCourt] withRadius:ViewHeight(btnAddCourt)/2 borderColor:CLEARCOLOUR andBorderWidth:0];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    
    [self fetchCourts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadCourts];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.originalFrame = viewAddCourt.frame;
}

- (void)fetchCourts
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            [self showSpinner:YES withError:NO];
            
            NSDictionary *params = @{
                                     kAPIMode: kloadCourts,
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
                        [Court deleteCourtsForUser:USER_ID];
                        for (NSDictionary *courtObj in [responseObject valueForKey:kAPIcourData]) {
                            [Court saveCourt:courtObj forUser:USER_ID];
                        }
                        
                        [self loadCourts];
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

- (void)loadCourts
{
    arrCourts = nil;
    arrCourts = [Court fetchCourts:USER_ID];
    if (arrCourts.count == 0) {
        [self fetchCourts];
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
        
        [self.navigationItem setRightBarButtonItem:nil];
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
    [self fetchCourts];
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

#pragma mark - UIScrollViewDelegate
#pragma mark -

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger yOffset = scrollView.contentOffset.y;
    if (yOffset > 0) {
        viewAddCourt.frame = CGRectMake(viewAddCourt.frame.origin.x, self.originalFrame.origin.y + yOffset, viewAddCourt.frame.size.width, viewAddCourt.frame.size.height);
    }
    if (yOffset < 1) viewAddCourt.frame = self.originalFrame;
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
