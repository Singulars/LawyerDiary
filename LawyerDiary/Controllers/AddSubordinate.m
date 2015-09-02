//
//  AddSubordinate.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 05/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "AddSubordinate.h"
#import "NetworkManager.h"
#import "Subordinate.h"

@interface AddSubordinate ()
{
    UITextField *activeTextField;
}
@end

@implementation AddSubordinate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Add Subordiante"];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [btnSave setBackgroundColor:UICOLOR(50, 50, 50, 1)];
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
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowHeight;
    
    if (indexPath.row == 4) {
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
            return cellFirstName;
        }
            break;
        case 1: {
            return cellLastName;
        }
            break;
        case 2: {
            return cellMobile;
        }
            break;
        case 3: {
            return cellAccess;
        }
            break;
        case 4: {
            return cellBtn;
        }
            break;
        case 5: {
            return cellMsg;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        if (tfFirstName.text.length == 0 || tfLastName.text.length == 0 || tfMobile.text.length == 0) {
            [Global showNotificationWithTitle:@"Subordinate detail can't be blanked!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            
            [activeTextField resignFirstResponder];
            
            Subordinate *objWhoHasAccess = [Subordinate fetchSubordinateWhoHasAccess];
            
            if (objWhoHasAccess != nil && [switchAccess isOn]) {
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:nil
                                                      message:[NSString stringWithFormat:@"You've already given access to subordinate user %@.\nNow, if you give access to user %@ then access will be revoked for %@.\n\nAre you sure you want to continue?", objWhoHasAccess.firstName, tfFirstName.text, objWhoHasAccess.firstName]
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   NSLog(@"Cancel action");
                                                   
                                                   [alertController dismissViewControllerAnimated:YES completion:nil];
                                               }];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Continue", @"Continue action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"OK action");
                                               
                                               [self saveSubordinate];
                                           }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else {
                [self saveSubordinate];
            }
        }
    }
}

- (void)saveSubordinate
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            [activeTextField resignFirstResponder];
            
            [self showIndicator:YES];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            params[kAPIMode] = kaddSubordinate;
            params[kAPIuserId] = USER_ID;
            params[kAPIfirstName] = tfFirstName.text;
            params[kAPIlastName] = tfLastName.text;
            params[kAPImobile] = tfMobile.text;
            params[kAPIhasAccess] = @(switchAccess.isOn);
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self showIndicator:NO];
                if (responseObject == nil) {
                    [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToNumber:@0]) {
                        [Global showNotificationWithTitle:[responseObject valueForKey:kAPImessage] titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                        //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                    }
                    else {
                        
                        [params setObject:[responseObject objectForKey:kAPIuserId] forKey:kAPIuserId];
                        
                        [Subordinate saveSubordinate:params];
                        [self dismissViewControllerAnimated:YES completion:^{
                            [Global showNotificationWithTitle:@"Subordinate added successfully!" titleColor:WHITE_COLOR backgroundColor:APP_GREEN_COLOR forDuration:1];
                        }];
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
        [Global showNotificationWithTitle:kCHECK_INTERNET titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

- (void)showIndicator:(BOOL)flag
{
    [btnSave setTitle:flag ? @"" : @"Save" forState:UIControlStateNormal];
    flag ? [indicator startAnimating] : [indicator stopAnimating];
    UserIntrectionEnable(!flag);
}

- (void)textFieldDidBeginEditing:(nonnull UITextField *)textField
{
    activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
