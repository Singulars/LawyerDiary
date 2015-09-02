//
//  CourtDetail.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 03/05/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "CourtDetail.h"
#import "Court.h"

BOOL isForSubordinate;
SubordinateAdmin *selectedAdminObj;

@interface CourtDetail ()
{
    UITextField *activeTextField;
}
@end

@implementation CourtDetail

@synthesize courtObj;
//@synthesize isForSubordinate;
@synthesize existingAdminObj;

#pragma mark - ViewLifeCycle
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:BLACK_COLOR];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT_BOLD fontColor:BLACK_COLOR andFontSize:20 andStrokeColor:CLEARCOLOUR]];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self setTitle:@"Court Detail"];
    
    if (courtObj) {
        [tfCourt setText:courtObj.courtName];
        [tfMegistrate setText:courtObj.megistrateName];
        [tfCity setText:courtObj.courtCity];
        
        [self.navigationItem setRightBarButtonItem:nil];
    }
    
    [btnSave setBackgroundColor:UICOLOR(50, 50, 50, 1)];
    
    if (selectedAdminObj != nil) {
        existingAdminObj = selectedAdminObj;
    }
    
    [self validateInputFiledsAccessibility];
}

- (void)validateInputFiledsAccessibility
{
    if (isForSubordinate) {
        if ([existingAdminObj.hasAccess isEqualToNumber:@1]) {
            [self enableInputFields:YES];
        }
        else {
            [self enableInputFields:NO];
        }
    }
    else {
        if (ShareObj.hasAdminAccess) {
            [self enableInputFields:YES];
        }
        else {
            if (ShareObj.fetchSubordinateStatus == kStatusUndetermined) {
                [self enableInputFields:YES];
            }
            else {
                [self enableInputFields:NO];
            }
        }
    }
}

- (void)enableInputFields:(BOOL)flag
{
    [tfCourt setUserInteractionEnabled:flag];
    [tfMegistrate setUserInteractionEnabled:flag];
    [tfCity setUserInteractionEnabled:flag];
}

#pragma mark - UIKeyboardNOtifications
#pragma mark -
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
#pragma mark -
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isForSubordinate) {
        if ([existingAdminObj.hasAccess isEqualToNumber:@1]) {
            return 4;
        }
        else {
            return 3;
        }
    }
    else {
        if (ShareObj.hasAdminAccess) {
            return 4;
        }
        else {
            if (ShareObj.fetchSubordinateStatus == kStatusUndetermined) {
                return 4;
            }
            else return 3;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowHeight;
    
    if (indexPath.row == 3) {
        rowHeight = 64;
    }
    else {
        rowHeight = 44;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            return cellCourt;
        }
            break;
        case 1: {
            return cellMegistrate;
        }
            break;
        case 2: {
            return cellCity;
        }
            break;
        case 3: {
            return cellBtn;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        if (tfCourt.text.length == 0 || tfMegistrate.text.length == 0 || tfCity.text.length == 0) {
            [Global showNotificationWithTitle:@"Court detail can't be blanked!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            
            if (isForSubordinate) {
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
                            [self saveCourt];
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
            else {
                [self saveCourt];
            }
        }
    }
}

#pragma mark - Action Methods
#pragma mark -
- (IBAction)btnCancelTaped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSaveTaped:(id)sender
{
    
}

- (void)saveCourt
{
    [activeTextField resignFirstResponder];
    
    NSMutableDictionary *courtParams = [[NSMutableDictionary alloc] init];
    courtParams[kAPIuserId] = USER_ID;
    courtParams[kAPIcourtName] = tfCourt.text;
    courtParams[kAPImegistrateName] = tfMegistrate.text;
    courtParams[kAPIcourtCity] = tfCity.text;
    courtParams[kIsSynced] = @0;
    
    if (courtObj) {
        if ([courtObj.isSynced isEqualToNumber:@1]) {
            courtParams[kAPIcourtId] = courtObj.courtId;
        }
        
        courtParams[kAPIlocalCourtId] = courtObj.localCourtId;
    }
    
    Court *tempCourtObj = [Court saveCourt:courtParams forSubordiante:isForSubordinate withAdminDetail:isForSubordinate ? @{
                                                                                                                            kAPIadminId: existingAdminObj.adminId,
                                                                                                                            kAPIadminName: existingAdminObj.adminName,
                                                                                                                            kAPIhasAccess: existingAdminObj.hasAccess
                                                                                                                            } : nil];
    
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            [self showIndicator:YES];
            
            NSDictionary *params = @{
                                     kAPIMode: ksaveCourt,
                                     kAPIuserId: USER_ID,
                                     kAPIlocalCourtId: tempCourtObj.localCourtId,
                                     kAPIcourtId: [tempCourtObj.courtId isEqualToNumber:@-1] ? @"" : tempCourtObj.courtId,
                                     kAPIcourtName: tempCourtObj.courtName,
                                     kAPImegistrateName: tempCourtObj.megistrateName,
                                     kAPIcourtCity: tempCourtObj.courtCity,
                                     kAPIadminId: isForSubordinate ? existingAdminObj.adminId : @0
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self showIndicator:NO];
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        [Global showNotificationWithTitle:[responseObject valueForKey:kAPImessage] titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
//                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        [Court saveCourt:responseObject[kAPIcourData] forSubordiante:isForSubordinate withAdminDetail:isForSubordinate ? @{
                                                                                                                                           kAPIadminId: existingAdminObj.adminId,
                                                                                                                                           kAPIadminName: existingAdminObj.adminName,
                                                                                                                                           kAPIhasAccess: existingAdminObj.hasAccess
                                                                                                                                           } : nil];

                        POST_NOTIFICATION(isForSubordinate ? kFetchSubordinateCourts : kFetchCourts, nil);
                        
                        if (courtObj) {
                            [self.navigationController popViewControllerAnimated:YES];
                            [Global showNotificationWithTitle:@"Court saved successfully!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
                        }
                        else {
                            [self dismissViewControllerAnimated:YES completion:^{
                                [Global showNotificationWithTitle:@"Court saved successfully!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
                            }];
                        }
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self showIndicator:NO];
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
//        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        POST_NOTIFICATION(isForSubordinate ? kFetchSubordinateCourts : kFetchCourts, nil);
        
        if (courtObj) {
            [self.navigationController popViewControllerAnimated:YES];
            [Global showNotificationWithTitle:@"Court saved successfully!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:^{
                [Global showNotificationWithTitle:@"Court saved successfully!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
            }];
        }
    }
}

- (void)showIndicator:(BOOL)flag
{
    [btnSave setTitle:flag ? @"" : @"Save" forState:UIControlStateNormal];
    flag ? [indicator startAnimating] : [indicator stopAnimating];
//    UserIntrectionEnable(!flag);
}

#pragma mark - UITextFieldDelegate
#pragma mark -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    NSInteger cellIndex;
    NSInteger cellSection;
    
    cellIndex = activeTextField.tag;
    cellSection = 0;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:cellSection]];
    [self.tableView scrollRectToVisible:cell.frame animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    switch (activeTextField.tag) {
        case 0: {
            [tfMegistrate becomeFirstResponder];
        }
            break;
        case 1: {
            [tfCity becomeFirstResponder];
        }
            break;
        case 2: {
            
            if (tfCourt.text.length == 0) {
                [tfCourt becomeFirstResponder];
            }
            else if (tfMegistrate.text.length == 0) {
                [tfMegistrate becomeFirstResponder];
            }
            else {
                if (tfCourt.text.length == 0 || tfMegistrate.text.length == 0 || tfCity.text.length == 0) {
                    [Global showNotificationWithTitle:@"Court detail can't be blanked!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    [self.view endEditing:YES];
//                    [self saveCourt];
                }
            }
        }
            break;
        default:
            break;
    }
    return YES;
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
