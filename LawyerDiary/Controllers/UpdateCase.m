//
//  UpdateCase.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 21/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "UpdateCase.h"

#import "ChooseClient.h"
#import "ChooseCourt.h"
#import "ChooseAdmin.h"

#import "SubordinateCases.h"

BOOL isForSubordinate;
SubordinateAdmin *selectedAdminObj;

@interface UpdateCase () <UITextFieldDelegate, ChooseClientDelegate, ChooseCourtDelegate>
{
    BOOL isNHCellExpanded;
    BOOL isPHCellExpanded;
    BOOL isRDCellExpanded;
}

@property (nonatomic, strong) LLARingSpinnerView *spinnerView;

@end

@implementation UpdateCase

@synthesize existingCaseObj;
@synthesize existingClientObj;
@synthesize existingCourtObj;

//@synthesize isForSubordinate;
@synthesize existingAdminObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    if (existingCaseObj != nil) {
        
        [self setTitle:[NSString stringWithFormat:@"%@ v/s %@", CAPITALIZED_STRING(existingCaseObj.clientFirstName), CAPITALIZED_STRING(existingCaseObj.oppositionFirstName)]];
        
        [self setCaseDetail];
        [self setCourtDetail];
        
        existingCourtObj = [Court fetchCourt:existingCaseObj.localCourtId];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self setBarButton:SaveBarButton];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 20, 20)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:WHITE_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    
    if (selectedAdminObj != nil) {
        existingAdminObj = selectedAdminObj;
    }
    
    datePicker.minimumDate = [Global getDateWithoutSeconds:[NSDate date]];
    reminderDatePicker.minimumDate = [Global getDateWithoutSeconds:[NSDate date]];
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

- (void)setCaseDetail
{
    [tfLastCaseStatus setText:existingCaseObj.caseStatus];
    
    if (existingCaseObj.nextHearingDate.length == 0) {
        [tfPHeardDate setText:@"N/A"];
    }
    else {
        [tfPHeardDate setText:[Global getDateStringOfFormat:DefaultBirthdateFormat fromDateString:existingCaseObj.nextHearingDate ofFormat:ServerBirthdateFormat]];
    }
//    [tfNHearingDate setText:existingCaseObj.nextHearingDate];
//    [tfCaseStatus setText:existingCaseObj.caseStatus];
}

- (void)setCourtDetail
{
    [lblCourtName setText:existingCaseObj.courtName];
    [lblMegistrateName setText:existingCaseObj.megistrateName];
    [lblCourtCity setText:existingCaseObj.courtCity];
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}

- (CGFloat) tableView:(nonnull UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 48;
    }
    else if (section == 1){
        return 48;
    }
    return 1;
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(self.tableView), 48)];
    [headerView setBackgroundColor:UICOLOR(239, 239, 244, 1)];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, ViewHeight(headerView)-30, ViewWidth(headerView)-30, 30)];
    [lblHeader setBackgroundColor:CLEARCOLOUR];
    [lblHeader setFont:[UIFont systemFontOfSize:14]];
    [lblHeader setTextColor:UICOLOR(109, 109, 114, 1)];
    
    [headerView addSubview:lblHeader];
    NSString *headerTitle;
    
    switch (section) {
        case 0: {
            headerTitle = @"Case Detail";
        }
            break;
        case 1: {
            headerTitle = @"Court Detail";
        }
            break;
        case 2: {
            headerTitle = @"Client Detail";
        }
            break;
        case 3: {
            headerTitle = @"Oppostition Detail";
        }
            break;
        default:
            break;
    }
    
    [lblHeader setText:UPPERCASE_STRING(headerTitle)];
    
    return headerView;
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(self.tableView), 48)];
    [headerView setBackgroundColor:UICOLOR(239, 239, 244, 1)];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, ViewY(headerView)+10, ViewWidth(headerView)-30, 40)];
    [lblHeader setBackgroundColor:CLEARCOLOUR];
    [lblHeader setNumberOfLines:3];
    [lblHeader setFont:[UIFont systemFontOfSize:10]];
    [lblHeader setTextColor:LIGHT_GRAY_COLOR];
    [lblHeader setTextAlignment:NSTextAlignmentCenter];
    
    [headerView addSubview:lblHeader];
    NSString *headerTitle;
    
    switch (section) {
        case 0: {
            headerTitle = @"Reminder Date by default is one day before\nNext Hearing Date. And also it can be modified\nby simply taping on reminder date.";
        }
            break;
        default:
            break;
    }
    
    [lblHeader setText:UPPERCASE_STRING(headerTitle)];
    
    return headerView;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    
    switch (indexPath.section) {
        case 0: {
            rowHeight = 44;
            if ((isPHCellExpanded && indexPath.row == 2) || (isNHCellExpanded && indexPath.row == 3)) {
                rowHeight = 162;
            }
            else if (((isPHCellExpanded || isNHCellExpanded) && (indexPath.row == 5 && isRDCellExpanded)) ||
                     ((!isPHCellExpanded && !isNHCellExpanded) && (indexPath.row == 4 && isRDCellExpanded))) {
                rowHeight = 206;
            }
        }
            break;
        case 1: {
            rowHeight = 60;
        }
            break;
        default:
            break;
    }
    return rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger noOfRow;
    
    switch (section) {
        case 0: {
            if ((isPHCellExpanded || isNHCellExpanded)) {
                noOfRow = 6;
            }
            else {
                noOfRow = 5;
            }
        }
            break;
        case 1: {
            noOfRow = 1;
        }
            break;
        default:
            break;
    }
    return noOfRow;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    return cellLastCaseStatus;
                }
                    break;
                case 1: {
                    return cellPHeardDate;
                }
                    break;
                    //                case 2: {
                    //                    if (isPHCellExpanded) {
                    //                        return cellCaseDatePicker;
                    //                    }
                    //                    else {
                    //                        return cellNHearingDate;
                    //                    }
                    //                }
                    //                    break;
                case 2: {
                    if (isPHCellExpanded) {
                        return cellCaseDatePicker;
                    }
                    else {
                        return cellNHearingDate;
                    }
                }
                    break;
                case 3: {
                    if (isNHCellExpanded) {
                        return cellCaseDatePicker;
                    }
                    else {
                        return cellCaseStatus;
                    }
                }
                    break;
                case 4: {
                    if (isPHCellExpanded || isNHCellExpanded) {
                        return cellCaseStatus;
                    }
                    else {
                        return cellReminderDate;
                    }
                }
                    break;
                case 5: {
                    return cellReminderDate;
                }
                default:
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    return cellCourtDetail;
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
    
    return nil;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView beginUpdates];
        
//        if (indexPath.row == 2) {
//            
//            if (isNHCellExpanded) {
//                isNHCellExpanded = NO;
//                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//                [tfNHearingDate setText:[Global getDateStringFromDate:datePicker.date ofFormat:DefaultBirthdateFormat]];
//            }
//            else {
//                isNHCellExpanded = YES;
//                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
//            }
//        }
        
        
        /*if (indexPath.row == 1) {
            if (isPHCellExpanded) {
                isPHCellExpanded = NO;
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                [tfPHeardDate setText:[Global getDateStringFromDate:datePicker.date ofFormat:DefaultBirthdateFormat]];
            }
            else if (isNHCellExpanded) {
                isNHCellExpanded = NO;
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                isPHCellExpanded = YES;
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                isPHCellExpanded = YES;
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            }
        }
        else */if (indexPath.row == 2 && !isPHCellExpanded && !isNHCellExpanded) {
            isNHCellExpanded = YES;
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else if (indexPath.row == 2 && isNHCellExpanded) {
            isNHCellExpanded = NO;
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [tfNHearingDate setText:[Global getDateStringFromDate:datePicker.date ofFormat:DefaultBirthdateFormat]];
        }
        else if (indexPath.row == 3 && isPHCellExpanded) {
            isPHCellExpanded = NO;
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            isNHCellExpanded = YES;
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else if (((isPHCellExpanded || isNHCellExpanded) && (indexPath.row == 5 && !isRDCellExpanded)) ||
                 ((!isPHCellExpanded && !isNHCellExpanded) && (indexPath.row == 4 && !isRDCellExpanded))) {
            isRDCellExpanded = YES;
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else if (((isPHCellExpanded || isNHCellExpanded) && (indexPath.row == 5 && isRDCellExpanded)) ||
                 ((!isPHCellExpanded && !isNHCellExpanded) && (indexPath.row == 4 && isRDCellExpanded))) {
            isRDCellExpanded = NO;
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
//        if (isPHCellExpanded) {
//            //            [datePicker setMinimumDate:nil];
//            //            [datePicker setMaximumDate:[NSDate date]];
//            
//            if (tfPHeardDate.text.length > 0) {
//                [datePicker setDate:[Global getDatefromDateString:tfPHeardDate.text ofFormat:DefaultBirthdateFormat]];
//            }
//            else {
//                [datePicker setDate:[NSDate date]];
//            }
//        }
//        else
        
        if (isNHCellExpanded) {
            
            if (tfNHearingDate.text.length > 0) {
                [datePicker setDate:[Global getDateWithoutSeconds:[Global getDatefromDateString:tfNHearingDate.text ofFormat:DefaultBirthdateFormat]]];
            }
            else {
                [datePicker setDate:[NSDate date]];
            }
        }
        else if (isRDCellExpanded) {
            if (lblReminderDate.text.length > 0) {
                [reminderDatePicker setDate:[Global getDateWithoutSeconds:[Global getDatefromDateString:lblReminderDate.text ofFormat:DefaultBirthdateFormat]]];
            }
            else {
                [reminderDatePicker setDate:[NSDate date]];
            }
        }
        
        [self.tableView endUpdates];
    }
    else if (indexPath.section == 1) {
        ChooseCourt *courtVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseCourt"];
        [courtVC setDelegate:self];
        [courtVC setExistingCourtObj:existingCourtObj];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:courtVC];
        [self presentViewController:navController animated:YES completion:nil];
    }
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

- (void)courtSelected:(Court *)courtObj
{
    existingCourtObj = courtObj;
    
    if (existingCaseObj != nil) {
        [existingCaseObj setCourtId:existingCourtObj.courtId];
        [existingCaseObj setCourtName:existingCourtObj.courtName];
        [existingCaseObj setCourtName:existingCourtObj.courtCity];
        [existingCaseObj setMegistrateName:existingCourtObj.megistrateName];
    }
    
    [lblCourtName setText:existingCourtObj.courtName];
    [lblMegistrateName setText:existingCourtObj.megistrateName];
    [lblCourtCity setText:existingCourtObj.courtCity];
    
    [self.tableView reloadData];
}
- (IBAction)barBtnSaveTaped:(id)sender
{
    NSString *errMsg = [self validateDetails];
    if ([errMsg isEqualToString:@""]) {
        [self saveCase];
    }
    else {
        UI_ALERT(nil, errMsg, nil);
    }
}

- (void)saveCase
{
    [self.view endEditing:YES];
    
    NSLog(@"date - %@", [Global getDateStringOfFormat:ServerBirthdateFormat fromDateString:tfNHearingDate.text ofFormat:DefaultBirthdateFormat]);
    
    NSMutableDictionary *caseParams = [[NSMutableDictionary alloc] init];
    caseParams[kAPIuserId] = USER_ID;
    caseParams[kAPIcaseNo] = existingCaseObj.caseNo;
    caseParams[kAPIlastHeardDate] = [Global getDateStringOfFormat:ServerBirthdateFormat fromDateString:existingCaseObj.nextHearingDate ofFormat:DefaultBirthdateFormat];
    caseParams[kAPInextHearingDate] = [Global getDateStringOfFormat:ServerBirthdateFormat fromDateString:tfNHearingDate.text ofFormat:DefaultBirthdateFormat];
    caseParams[kAPIcaseStatus] = tfCaseStatus.text;
    caseParams[kAPIlocalClientId] = existingCaseObj.localClientId;
    caseParams[kAPIclientId] = existingCaseObj.clientId;
    caseParams[kAPIclientFirstName] = existingCaseObj.clientFirstName;
    caseParams[kAPIclientLastName] = existingCaseObj.clientLastName;
    caseParams[kAPImobile] = existingCaseObj.mobile;
    caseParams[kAPIoppositionFirstName] = existingCaseObj.oppositionFirstName;
    caseParams[kAPIoppositionLastName] = existingCaseObj.oppositionLastName;
    caseParams[kAPIoppositionLawyerName] = existingCaseObj.oppositionLawyerName;
    caseParams[kAPIlocalCourtId] = existingCaseObj.localCourtId;
    caseParams[kAPIcourtId] = existingCaseObj.courtId;
    caseParams[kAPIcourtName] = existingCaseObj.courtName;
    caseParams[kAPImegistrateName] = existingCaseObj.megistrateName;
    caseParams[kAPIcourtCity] = existingCaseObj.courtCity;
    caseParams[kIsSynced] = @0;
    
    if (existingCaseObj) {
        if ([existingCaseObj.isSynced isEqualToNumber:@1]) {
            caseParams[kAPIcaseId] = existingCaseObj.caseId;
        }
        
        caseParams[kAPIlocalCaseId] = existingCaseObj.localCaseId;
    }
    Cases *tempCaseObj = [Cases saveCase:caseParams forSubordiante:isForSubordinate withAdminDetail:isForSubordinate ? @{
                                                                                                                         kAPIadminId: existingAdminObj.adminId,
                                                                                                                         kAPIadminName: existingAdminObj.adminName,
                                                                                                                         kAPIhasAccess: existingAdminObj.hasAccess
                                                                                                                         } : nil];
    
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: ksaveCase,
                                     kAPIuserId: USER_ID,
                                     kAPIlocalCaseId: tempCaseObj.localCaseId,
                                     kAPIcaseId: ![existingCaseObj.caseId isEqualToNumber:@-1] ? existingCaseObj.caseId : @"",
                                     kAPIcaseNo: tempCaseObj.caseNo,
                                     kAPIlastHeardDate: tempCaseObj.lastHeardDate,
                                     kAPInextHearingDate: tempCaseObj.nextHearingDate,
                                     kAPIcaseStatus: tempCaseObj.caseStatus,
                                     kAPIlocalClientId: tempCaseObj.localClientId,
                                     kAPIclientId: tempCaseObj.clientId,
                                     kAPIclientFirstName: tempCaseObj.clientFirstName,
                                     kAPIclientLastName: tempCaseObj.clientLastName,
                                     kAPImobile: tempCaseObj.mobile,
                                     kAPIemail: @"",
                                     kAPIaddress: @"",
                                     kAPIoppositionFirstName: tempCaseObj.oppositionFirstName,
                                     kAPIoppositionLastName: tempCaseObj.oppositionLastName,
                                     kAPIoppositionLawyerName: tempCaseObj.oppositionLawyerName,
                                     kAPIlocalCourtId: tempCaseObj.localCourtId,
                                     kAPIcourtId: tempCaseObj.courtId,
                                     kAPIcourtName: tempCaseObj.courtName,
                                     kAPImegistrateName: tempCaseObj.megistrateName,
                                     kAPIcourtCity: tempCaseObj.courtCity,
                                     kAPIadminId: isForSubordinate ? existingAdminObj.adminId : @0
                                     };
            
            NSLog(@"%@", params);
            
            [self setBarButton:IndicatorBarButton];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [self setBarButton:SaveBarButton];
                    
                    if (responseObject == nil) {
                        [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                    }
                    else {
                        if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                            [Global showNotificationWithTitle:[responseObject valueForKey:kAPImessage] titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                            //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                        }
                        else {
                            [Cases updateCase:responseObject forUser:USER_ID];
                            
                            [self dismissViewControllerAnimated:YES completion:^{
                                POST_NOTIFICATION(kFetchCases, nil);
                                [Global showNotificationWithTitle:@"Case saved successfully!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
                            }];
                        }
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [self setBarButton:SaveBarButton];
                    
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
            });
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        //        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        
        POST_NOTIFICATION(isForSubordinate ? kFetchSubordinateCases : kFetchCases, nil);
        
        if (existingCaseObj) {
            [self.navigationController popViewControllerAnimated:YES];
            [Global showNotificationWithTitle:@"Case saved successfully!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:^{
                [Global showNotificationWithTitle:@"Case saved successfully!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
            }];
        }
    }
}

- (void)setBarButton:(UIBarButton)barBtnType
{
    switch (barBtnType) {
        case SaveBarButton: {
            barBtnSave = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnSaveTaped:)];
            [barBtnSave setTintColor:BLACK_COLOR];
            [self.navigationItem setRightBarButtonItem:barBtnSave];
            
            UserIntrectionEnable(YES);
        }
            break;
        case IndicatorBarButton: {
            barBtnSave = [[UIBarButtonItem alloc] initWithCustomView:self.spinnerView];
            [barBtnSave setTintColor:WHITE_COLOR];
            [self.navigationItem setRightBarButtonItem:barBtnSave];
            [self.spinnerView startAnimating];
            
            UserIntrectionEnable(NO);
        }
            break;
        default:
            break;
    }
}

- (NSString *)validateDetails
{
    NSString *errMsg = @"";
    if ([Global validateTextField:tfNHearingDate]) {
        errMsg = @"Please enter Next Hearing date for Case.";
    }
    else if ([Global validateTextField:tfCaseStatus]) {
        errMsg = @"Please enter current case status.";
    }
    
    return errMsg;
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)datePickerValueChanged:(id)sender {
    if (isPHCellExpanded) {
        
        [tfPHeardDate setText:[Global getDateStringFromDate:datePicker.date ofFormat:DefaultBirthdateFormat]];
    }
    else if (isNHCellExpanded) {
        
        NSDate* oneSecondAfterPickersDate = [datePicker.date dateByAddingTimeInterval:1] ;
        if ( [datePicker.date compare:datePicker.minimumDate] == NSOrderedSame ) {
            NSLog(@"date is at or below the minimum") ;
            datePicker.date = oneSecondAfterPickersDate ;
        }
        else if ( [datePicker.date compare:datePicker.maximumDate] == NSOrderedSame ) {
            NSLog(@"date is at or above the maximum") ;
            datePicker.date = oneSecondAfterPickersDate ;
        }
        
        [tfNHearingDate setText:[Global getDateStringFromDate:[Global getDateWithoutSeconds:datePicker.date] ofFormat:DefaultBirthdateFormat]];
        
        [lblReminderDate setText:[Global getDateStringFromDate:[Global removeDays:1 fromDate:[Global getDateWithoutSeconds:datePicker.date]] ofFormat:DefaultBirthdateFormat]];
        
        [reminderDatePicker setMaximumDate:[Global getDateWithoutSeconds:[Global getDatefromDateString:lblReminderDate.text ofFormat:DefaultBirthdateFormat]]];
        
        [reminderDatePicker setDate:[Global getDateWithoutSeconds:[Global getDatefromDateString:lblReminderDate.text ofFormat:DefaultBirthdateFormat]]];
    }
}

- (IBAction)reminderDatePickerValueChanged:(id)sender {
    
    NSDate* oneSecondAfterPickersDate = [reminderDatePicker.date dateByAddingTimeInterval:1] ;
    if ( [datePicker.date compare:reminderDatePicker.minimumDate] == NSOrderedSame ) {
        NSLog(@"date is at or below the minimum") ;
        reminderDatePicker.date = oneSecondAfterPickersDate ;
    }
    else if ( [datePicker.date compare:reminderDatePicker.maximumDate] == NSOrderedSame ) {
        NSLog(@"date is at or above the maximum") ;
        reminderDatePicker.date = oneSecondAfterPickersDate ;
    }
    
    [lblReminderDate setText:[Global getDateStringFromDate:[Global getDateWithoutSeconds:reminderDatePicker.date] ofFormat:DefaultBirthdateFormat]];
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
