//
//  ViewController.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 06/05/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "ViewController.h"

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)

typedef NS_ENUM(NSUInteger, InputFieldTags) {
    kTagFirstName = 0,
    kTagLastName,
    kTagBirthdate,
    kTagCurrentPass,
    kTagNewPass,
    kTagRegNo,
    kTagAdress
};

typedef NS_ENUM(NSUInteger, ActiveTableSection) {
    kActiveSectionProfile = 0,
    kActiveSectionPassword,
    kActiveSectionFirmInfo,
};

@interface ViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isPasswordSectionExpanded;
    BOOL isPickerVisible;
    
    ActiveTableSection activeTableSection;
    UITextField *activeTextField;
    
    UIButton *btnPasswordToggle;
    
    BOOL isImageSet;
    BOOL isPasswordChanged;
    
    NSString *newPassword;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:WHITE_COLOR];
    [self.navigationController.navigationBar setBarTintColor:APP_TINT_COLOR];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[Global setNavigationBarTitleTextAttributesLikeFont:APP_FONT fontColor:WHITE_COLOR andFontSize:22 andStrokeColor:CLEARCOLOUR]];
    
    [Global applyCornerRadiusToViews:@[imgViewProPic] withRadius:imgViewProPic.frame.size.width/2 borderColor:APP_TINT_COLOR andBorderWidth:1];
    
    [tfFirstName setTag:kTagFirstName];
    [tfLastName setTag:kTagLastName];
    [tfBirthdate setTag:kTagBirthdate];
    [tfCurrentPass setTag:kTagCurrentPass];
    [tfNewPass setTag:kTagNewPass];
    [tfRegNo setTag:kTagRegNo];
    [tvAddress setTag:kTagAdress];
    
    [tfFirstName setText:USER_OBJECT.firstName];
    [tfLastName setText:USER_OBJECT.lastName];
    [tfEmail setText:USER_OBJECT.email];
    [tfMobile setText:USER_OBJECT.mobile];
    [tfBirthdate setText:USER_OBJECT.birthdate];
    [tfRegNo setText:USER_OBJECT.registrationNo];
    [tvAddress setText:USER_OBJECT.address];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_TINT_COLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:APP_TINT_COLOR]];
    
    [imgViewRowDisclosure setTintColor:APP_TINT_COLOR];
    [imgViewRowDisclosure setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(IMG_row_disclosure, kImageRenderModeTemplate)];
    
    [self setTitle:NSStringf(@"%@ %@", USER_OBJECT.firstName, USER_OBJECT.lastName)];
    [imgViewProPic setImageWithURL:GetProPicURLForUser(USER_ID) withName:USER_OBJECT.proPic andSize:VIEWSIZE(imgViewProPic) withPlaceholderImageName:IMG_user_avatar_80];
    isImageSet = [Global isImageExist:USER_OBJECT.proPic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [tfCurrentPass addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [tfNewPass addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    btnPasswordToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPasswordToggle setTintColor:APP_TINT_COLOR];
    [btnPasswordToggle setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"btn-eye-closed", kImageRenderModeTemplate) forState:UIControlStateNormal];
    [btnPasswordToggle setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"btn-eye-opened", kImageRenderModeTemplate) forState:UIControlStateSelected];
    [btnPasswordToggle addTarget:self action:@selector(btnPasswordToggleTaped:) forControlEvents:UIControlEventTouchUpInside];
    [btnPasswordToggle setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    
    [tvAddress setInputAccessoryView:toolbar];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewTaped:)];
    [imgViewProPic addGestureRecognizer:tapGesture];
}

- (void)imgViewTaped:(id)sender {
    [activeTextField resignFirstResponder];
    [tvAddress resignFirstResponder];
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:isImageSet ? @"Remove Picture" : nil otherButtonTitles:@"Take From Camera", @"Take From Library", nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (buttonIndex == 0 && isImageSet) {
        [imgViewProPic setImage:IMAGE_WITH_NAME(IMG_user_avatar_80)];
        isImageSet = NO;
    }
    else if ((buttonIndex == 0 && !isImageSet) ||
             (buttonIndex == 1 && isImageSet))
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            MY_ALERT(WARNING, @"Device has no camera!", nil);
        }
        else {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if ((buttonIndex == 1 && !isImageSet) ||
             (buttonIndex == 2 && isImageSet)) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imgViewProPic.image = chosenImage;
    
    isImageSet = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    
    if (textField == tfCurrentPass || textField == tfNewPass) {
        // Set to custom font if the textfield is cleared, else set it to system font
        // This is a workaround because secure text fields don't play well with custom fonts
        if (textField.text.length == 0 && !textField.isSecureTextEntry) {
            textField.font = [UIFont fontWithName:APP_FONT size:textField.font.pointSize];
        }
        else {
            textField.font = [UIFont systemFontOfSize:textField.font.pointSize];
        }
    }
}

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

#pragma mark - Actions

- (IBAction)btnSaveTaped:(id)sender
{
    
}

- (IBAction)actionToggleLeftDrawer:(id)sender {
    SetStatusBarLightContent(NO);
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)btnPasswordToggleTaped:(id)sender {
    [btnPasswordToggle setSelected:![btnPasswordToggle isSelected]];
    
    [tfCurrentPass setSecureTextEntry:![btnPasswordToggle isSelected]];
    [tfNewPass setSecureTextEntry:![btnPasswordToggle isSelected]];
    
    [tfCurrentPass setFont:[UIFont fontWithName:!tfCurrentPass.isSecureTextEntry ? APP_FONT : @"HelveticaNeue" size:tfCurrentPass.font.pointSize]];
    [tfNewPass setFont:[UIFont fontWithName:!tfCurrentPass.isSecureTextEntry ? APP_FONT : @"HelveticaNeue" size:tfNewPass.font.pointSize]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(self.tableView), 44)];
    [headerView setBackgroundColor:GROUP_TABLEVIEW_COLOR];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, headerView.frame.size.height-25, SCREEN_WIDTH(headerView)-10, 20)];
    [lblHeader setFont:FONT_WITH_NAME_SIZE(APP_FONT, 16)];
    [lblHeader setTextColor:UICOLOR(111, 111, 116, 1)];
    [headerView addSubview:lblHeader];
    
    NSString *headerTitle = @"";
    switch (section) {
        case 0:
            headerTitle = @"PROFILE";
            break;
        case 1: {
            headerTitle = @"UPDATE PASSWORD";
            [btnPasswordToggle setFrame:CGRectMake(headerView.frame.size.width-40, headerView.frame.origin.y, 40, headerView.frame.size.height-5)];
            
            [btnPasswordToggle setHidden:!isPasswordSectionExpanded];
            
            [headerView addSubview:btnPasswordToggle];
        }
            break;
        case 2:
            headerTitle = @"FIRM INFO";
            break;
        default:
            break;
    }
    
    [lblHeader setText:headerTitle];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                rowHeight = 88;
            }
            else if (indexPath.row == 4) {
                rowHeight = 162;
            }
            else {
                rowHeight = 44;
            }
        }
            break;
        case 1: {
            rowHeight = 44;
        }
            break;
        case 2: {
            if (indexPath.row == 0) {
                rowHeight = 44;
            }
            else {
                rowHeight = 88;
            }
        }
            break;
        default:
            break;
    }
    
    return rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    
    switch (section) {
        case 0: {
            rowCount = isPickerVisible ? 5 : 4;
        }
            break;
        case 1: {
            if (isPasswordSectionExpanded) {
                rowCount = 2;
            }
            else {
                rowCount = 1;
            }
        }
            break;
        case 2: {
            rowCount = 2;
        }
            break;
        default:
            break;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return cellFirst;
                    break;
                case 1:
                    return cellEmail;
                    break;
                case 2:
                    return cellMobile;
                    break;
                case 3:
                    return cellBirthdate;
                    break;
                case 4:
                    return cellPicker;
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (isPasswordSectionExpanded) {
                switch (indexPath.row) {
                    case 0:
                        return cellCurrentPass;
                        break;
                    case 1:
                        return cellNewPass;
                        break;
                    default:
                        break;
                }
            }
            else {
                switch (indexPath.row) {
                    case 0:
                        return cellChangePass;
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0:
                    return cellRegNo;
                    break;
                case 1:
                    return cellAdress;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0 && (activeTextField == nil || activeTextField.tag == kTagLastName || activeTextField.tag == kTagBirthdate)) {
                [tfFirstName setUserInteractionEnabled:YES];
                [tfFirstName becomeFirstResponder];
            }
            else if (indexPath.row == 0 && (activeTextField.tag == kTagFirstName || activeTextField.tag == kTagBirthdate)) {
                [tfLastName setUserInteractionEnabled:YES];
                [tfLastName becomeFirstResponder];
            }
            else if (indexPath.row == 3) {
                if (!isPickerVisible) {
                    [self showBirthdatePicker:YES];
                }
            }
        }
            break;
        case 1: {
            if (!isPasswordSectionExpanded) {
                
                isPasswordSectionExpanded = YES;
                NSArray *indexPathToBeDeleted = @[
                                                  [NSIndexPath indexPathForRow:0 inSection:indexPath.section],
                                                  ];
                NSArray *indexPathToBeAdded = @[
                                                [NSIndexPath indexPathForRow:1 inSection:indexPath.section],
                                                [NSIndexPath indexPathForRow:0 inSection:indexPath.section],
                                                ];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPathToBeDeleted withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView insertRowsAtIndexPaths:indexPathToBeAdded withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
                
                [UIView animateWithDuration:0.2 animations:^{
                    imgViewRowDisclosure.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
                }];
                
                [tfCurrentPass setUserInteractionEnabled:YES];
                [tfCurrentPass becomeFirstResponder];
                
                [btnPasswordToggle setHidden:NO];
                [btnPasswordToggle setSelected:NO];
            }
            else {
                if (indexPath.row == 0) {
                    [tfCurrentPass setUserInteractionEnabled:YES];
                    [tfCurrentPass becomeFirstResponder];
                }
                else if (indexPath.row == 1) {
                    [tfNewPass setUserInteractionEnabled:YES];
                    [tfNewPass becomeFirstResponder];
                }
            }
        }
            break;
        case 2: {
            if (indexPath.row == 0) {
                [tfRegNo setUserInteractionEnabled:YES];
                [tfRegNo becomeFirstResponder];
            }
            else if (indexPath.row == 1) {
                [tvAddress becomeFirstResponder];
            }
        }
            break;
        default:
            break;
    }
}

- (IBAction)barBtnDoneTaped:(id)sender
{
    if (tfRegNo.text.length == 0) {
        [tfRegNo setUserInteractionEnabled:YES];
        [tfRegNo becomeFirstResponder];
    }
    
    [tvAddress resignFirstResponder];
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
    NSInteger cellSection;
    switch (activeTextField.tag) {
        case kTagFirstName: {
            cellIndex = 0;
            cellSection = 0;
        }
            break;
        case kTagLastName: {
            cellIndex = 0;
            cellSection = 0;
        }
            break;
        case kTagBirthdate: {
            cellIndex = 3;
            cellSection = 0;
        }
            break;
        case kTagCurrentPass: {
            cellIndex = 0;
            cellSection = 1;
        }
            break;
        case kTagNewPass: {
            cellIndex = 1;
            cellSection = 1;
        }
            break;
        case kTagRegNo: {
            cellIndex = 0;
            cellSection = 2;
        }
            break;
        default:
            break;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:cellSection]];
    [self.tableView scrollRectToVisible:cell.frame animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [activeTextField setUserInteractionEnabled:NO];
    activeTextField = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [btnPasswordToggle setHidden:YES];
    switch (activeTextField.tag) {
        case kTagFirstName: {
            [tfLastName setUserInteractionEnabled:YES];
            [tfLastName becomeFirstResponder];
        }
            break;
        case kTagLastName: {
            if (!isPickerVisible) {
                [self showBirthdatePicker:YES];
            }
            [activeTextField resignFirstResponder];
        }
            break;
        case kTagBirthdate: {
            
            if (tfFirstName.text.length == 0) {
                [tfFirstName setUserInteractionEnabled:YES];
                [tfFirstName becomeFirstResponder];
            }
            else if (tfLastName.text.length == 0) {
                [tfLastName setUserInteractionEnabled:YES];
                [tfLastName becomeFirstResponder];
            }
            else {
                [activeTextField resignFirstResponder];
            }
        }
            break;
        case kTagCurrentPass: {
            [tfNewPass setUserInteractionEnabled:YES];
            [tfNewPass becomeFirstResponder];
            
            [btnPasswordToggle setHidden:NO];
        }
            break;
        case kTagNewPass: {
            [btnPasswordToggle setHidden:NO];
            
            if (tfCurrentPass.text.length == 0) {
                [tfCurrentPass setUserInteractionEnabled:YES];
                [tfCurrentPass becomeFirstResponder];
                
            }
            else {
                if (![tfCurrentPass.text isEqualToString:GetLoginUserPassword]) {
                    [Global showNotificationWithTitle:@"Current password doesn't match!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else if ([tfNewPass.text length] < 8 && [tfNewPass.text length] <= 25) {
                    [Global showNotificationWithTitle:@"Password should be 8 characters long!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else if ([tfNewPass.text length] > 25) {
                    [Global showNotificationWithTitle:@"Password should be less than 25 characters!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                }
                else {
                    [activeTextField resignFirstResponder];
                    NSArray *indexPathToBeDeleted = @[
                                                      [NSIndexPath indexPathForRow:1 inSection:1],
                                                      [NSIndexPath indexPathForRow:0 inSection:1],
                                                      ];
                    NSArray *indexPathToBeAdded = @[
                                                    [NSIndexPath indexPathForRow:0 inSection:1],
                                                    ];
                    isPasswordSectionExpanded = NO;
                    
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:indexPathToBeDeleted withRowAnimation:UITableViewRowAnimationBottom];
                    [self.tableView insertRowsAtIndexPaths:indexPathToBeAdded withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        imgViewRowDisclosure.transform = CGAffineTransformIdentity;
                    }];
                    
                    [btnPasswordToggle setSelected:NO];
                    [btnPasswordToggle setHidden:YES];
                    
                    newPassword = tfNewPass.text;
                    [tfCurrentPass setText:@""];
                    [tfNewPass setText:@""];
                }
            }
        }
            break;
        case kTagRegNo: {
            [tvAddress setUserInteractionEnabled:YES];
            [tvAddress becomeFirstResponder];
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
    [tfBirthdate setText:[Global getDateStringFromDate:pickerBirthdate.date ofFormat:DefaultBirthdateFormat]];
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
            
            if (tfBirthdate.text.length > 0) {
                [pickerBirthdate setDate:[Global getDatefromDateString:tfBirthdate.text ofFormat:DefaultBirthdateFormat]];
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
            
            [tfBirthdate setText:[Global getDateStringFromDate:pickerBirthdate.date ofFormat:DefaultBirthdateFormat]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [NSException debugDescription]);
    }
    @finally {
        
    }
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
