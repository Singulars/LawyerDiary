//
//  Clients.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "Clients.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>

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
@end

@implementation Clients

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:WHITE_COLOR];
    [self.navigationController.navigationBar setBarTintColor:APP_TINT_COLOR];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT fontColor:WHITE_COLOR andFontSize:22 andStrokeColor:CLEARCOLOUR]];
    
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    [self.spinnerView setBounds:CGRectMake(0, 0, 35, 35)];
    [self.spinnerView setHidesWhenStopped:YES];
    [self.spinnerView setTintColor:APP_TINT_COLOR];
    [self.spinnerView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-NavBarHeight)];
    [self.view addSubview:self.spinnerView];
    
    [self.spinnerView startAnimating];
    
    //setTag
    [tfClientName setTag:kTagClientName];
    [tfOppositionName setTag:kTagOppositionName];
    [tfOppositionLawyerName setTag:kTagOppositionLawyerName];
    [tfMobile setTag:kTagMobile];
    [tfEmail setTag:kTagEmail];
    [tfCaseNo setTag:kTagCaseNo];
    [tvAddress setTag:kTagAddress];
    [tfCourtName setTag:kTagCourtName];
    [tfLastHeardDate setTag:kTagLastHeardDate];
    [tfNextHearingDate setTag:kTagNextHearingDate];
    
    [tvAddress setInputAccessoryView:toolbar];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.spinnerView stopAnimating];
    });
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - KeyBoardHideShow

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 6) {
                rowHeight = 88;
            }
            else {
                rowHeight = 44;
            }
        }
            break;
        default:
            break;
    }
    
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 10;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return cellClientName;
            break;
        case 1:
            return cellOppositionName;
            break;
        case 2:
            return cellOppositionLawyerName;
            break;
        case 3:
            return cellMobile;
            break;
        case 4:
            return cellEmail;
            break;
        case 5:
            return cellCaseNo;
            break;
        case 6:
            return cellAddress;
            break;
        case 7:
            return cellCourtName;
            break;
        case 8:
            return cellLastHeardDate;
            break;
        case 9:
            return cellNextHearingDate;
            break;
        default:
            break;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                [tfClientName setUserInteractionEnabled:YES];
                [tfClientName becomeFirstResponder];
            }
            else if (indexPath.row == 1) {
                [tfOppositionName setUserInteractionEnabled:YES];
                [tfOppositionName becomeFirstResponder];
            }
            else if (indexPath.row == 2) {
                [tfOppositionLawyerName setUserInteractionEnabled:YES];
                [tfOppositionLawyerName becomeFirstResponder];
            }
            else if (indexPath.row == 3) {
                [tfMobile setUserInteractionEnabled:YES];
                [tfMobile becomeFirstResponder];
            }
            else if (indexPath.row == 4) {
                [tfEmail setUserInteractionEnabled:YES];
                [tfEmail becomeFirstResponder];
            }
            else if (indexPath.row == 5) {
                [tfCaseNo setUserInteractionEnabled:YES];
                [tfCaseNo becomeFirstResponder];
            }
            else if (indexPath.row == 6) {
                [tvAddress becomeFirstResponder];
            }
            else if (indexPath.row == 7) {
                [tfCourtName setUserInteractionEnabled:YES];
                [tfCourtName becomeFirstResponder];
            }
            else if (indexPath.row == 8) {
                if (!isPickerVisible) {
                    [self showBirthdatePicker:YES];
                }
            }
            
            break;
        default:
            break;
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    CGRect newFrame = CGRectMake(ViewX(cell), ViewY(cell), ViewWidth(cell), ViewHeight(cell)*2);
    [self.tableView scrollRectToVisible:newFrame animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [tvAddress setUserInteractionEnabled:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    NSInteger cellIndex;
    switch (activeTextField.tag) {
        case kTagClientName: {
            cellIndex = 0;
        }
            break;
        case kTagOppositionName: {
            cellIndex = 1;
        }
            break;
        case kTagOppositionLawyerName: {
            cellIndex = 2;
        }
            break;
        case kTagMobile: {
            cellIndex = 3;
        }
            break;
        case kTagEmail: {
            cellIndex = 4;
        }
            break;
        case kTagCaseNo: {
            cellIndex = 5;
        }
            break;
        case kTagAddress: {
            cellIndex = 6;
        }
            break;
        case kTagCourtName: {
            cellIndex = 7;
        }
            break;
        case kTagNextHearingDate: {
            cellIndex = 8;
        }
            break;
        case kTagLastHeardDate: {
            cellIndex = 9;
        }
            break;
        default:
            break;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
    [self.tableView scrollRectToVisible:cell.frame animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [activeTextField setUserInteractionEnabled:NO];
    activeTextField = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    switch (activeTextField.tag) {
        case kTagClientName: {
            [tfClientName setUserInteractionEnabled:YES];
            [tfClientName becomeFirstResponder];
        }
            break;
        case kTagOppositionName: {
            [tfOppositionName setUserInteractionEnabled:YES];
            [tfOppositionName becomeFirstResponder];
        }
            break;
        case kTagOppositionLawyerName: {
            [tfOppositionLawyerName setUserInteractionEnabled:YES];
            [tfOppositionLawyerName becomeFirstResponder];
        }
        case kTagMobile: {
            [tfMobile setUserInteractionEnabled:YES];
            [tfMobile becomeFirstResponder];
        }
        case kTagEmail: {
            [tfEmail setUserInteractionEnabled:YES];
            [tfEmail becomeFirstResponder];
        }
        case kTagCaseNo: {
            [tfCaseNo setUserInteractionEnabled:YES];
            [tfCaseNo becomeFirstResponder];
        }
        case kTagAddress: {
            [tvAddress setUserInteractionEnabled:YES];
            [tvAddress becomeFirstResponder];
        }
        case kTagCourtName: {
            [tfCourtName setUserInteractionEnabled:YES];
            [tfCourtName becomeFirstResponder];
        }
        case kTagNextHearingDate: {
            [activeTextField resignFirstResponder];
        }
        case kTagLastHeardDate: {
            [activeTextField resignFirstResponder];
        }
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (IBAction)btnDoneTaped:(id)sender
{
    [self showBirthdatePicker:NO];
}

- (IBAction)pickerBirthdateChanged:(id)sender
{
    [tfNextHearingDate setText:[Global getDateStringFromDate:pickerBirthdate.date ofFormat:DefaultBirthdateFormat]];
}

- (void)showBirthdatePicker:(BOOL)flag
{
    @try {
        if (flag) {
            
            [activeTextField resignFirstResponder];
            
            isPickerVisible = YES;
            NSArray *indexPathToBeAdded = @[
                                            [NSIndexPath indexPathForRow:4 inSection:0]
                                            ];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathToBeAdded withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            
            [btnDone setHidden:NO];
            
            if (tfNextHearingDate.text.length > 0) {
                [pickerBirthdate setDate:[Global getDatefromDateString:tfNextHearingDate.text ofFormat:DefaultBirthdateFormat]];
            }
        }
        else {
            isPickerVisible = NO;
            NSArray *indexPathToBeDeleted = @[
                                              [NSIndexPath indexPathForRow:4 inSection:0]
                                              ];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathToBeDeleted withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            
            [btnDone setHidden:YES];
            
            [tfNextHearingDate setText:[Global getDateStringFromDate:pickerBirthdate.date ofFormat:DefaultBirthdateFormat]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [NSException debugDescription]);
    }
    @finally {
        
    }
}

#pragma mark - Actions

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
