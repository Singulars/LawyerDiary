//
//  Register.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/19/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "Register.h"

#define LOGIN_FIELDS_COUNT  2
#define SIGNUP_FIELDS_COUNT 3
#define FORGOTPASS_FIELDS_COUNT 1

#define ShakeDelta      7.f
#define ShakeSpeed      0.05f
#define ShakeShakes     4.f

static NSString *kFirstCellID = @"FirstCell";
static NSString *kEmailCellID = @"EmailCell";
static NSString *kPasswordCellID = @"PasswordCell";
static NSString *kMobileCellID = @"MobileCell";
static NSString *kBirthdateCellID = @"BirthdateCell";
static NSString *kActionButtonCellID = @"ActionButtonCell";
static NSString *kOtherButtonCellID = @"OtherButtonCell";

typedef NS_ENUM(NSUInteger, AlertMsgType) {
    InternetOffline = 0,
    RequestTimeOut,
    InvalidCredentials,
    InvalidEmail,
    EmailExist,
    PasswordSent,
    Signedup,
    SomethingWentWrong,
    HideMsg
} ;

@interface Register () <UIBarPositioning, UINavigationBarDelegate>

@end

@implementation Register

#pragma mark - UIViewLifeCycle
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (_viewType == LOGIN_VIEW) {
//        [navItem setTitle:@"Log In"];
//    }
//    else if (_viewType == SIGN_UP_VIEW) {
//        [navItem setTitle:@"Sign Up"];
//    }
    [navItem setTitle:@"Register an account"];
    
    navBar = [[UINavigationBar alloc] init];
    [navBar setFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
//    [navBar setBarTintColor:APP_TINT_COLOR];
    [navBar setTranslucent:NO];
    [navBar setDelegate:self];
//    [navBar setShadowImage:[UIImage new]];
    
    UIImage *navBarImage;
    navBarImage = [[UIImage imageWithColor:WHITE_COLOR] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    [navBar setBackgroundImage:navBarImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:navBar];
    
    [navItem setRightBarButtonItem:barBtnClose];
    
    [barBtnClose setTintColor:BLACK_COLOR];
    
    [navBar setItems:@[navItem] animated:YES];
    [navBar setTitleTextAttributes:[Global getTextAttributesForFont:APP_FONT fontSize:20 fontColor:BLACK_COLOR strokeColor:CLEAR_COLOR]];
    [navBar setTintColor:BLACK_COLOR];
    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
//        [self setUpView];
//    }
    
    [Global applyCornerRadiusToViews:@[imgViewProPic] withRadius:35 borderColor:APP_TINT_COLOR andBorderWidth:1.5];
    
    [self updateButtonLookFeel];
    [self updateTextFieldTag];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewTaped:)];
    [imgViewProPic addGestureRecognizer:tapGesture];
    
    [tfEmail setAttributedPlaceholder:[Global getAttributedString:@"Email" withFont:APP_FONT fontSize:18 fontColor:UICOLOR(0, 0, 0, 0.3) strokeColor:CLEAR_COLOR]];
    [tfPassword setAttributedPlaceholder:[Global getAttributedString:@"Password" withFont:@"HelveticaNeue" fontSize:18 fontColor:UICOLOR(0, 0, 0, 0.3) strokeColor:CLEAR_COLOR]];
    [tfFirstName setAttributedPlaceholder:[Global getAttributedString:@"First Name" withFont:APP_FONT fontSize:18 fontColor:UICOLOR(0, 0, 0, 0.3) strokeColor:CLEAR_COLOR]];
    [tfLastName setAttributedPlaceholder:[Global getAttributedString:@"Last Name" withFont:APP_FONT fontSize:18 fontColor:UICOLOR(0, 0, 0, 0.3) strokeColor:CLEAR_COLOR]];
    [tfMobile setAttributedPlaceholder:[Global getAttributedString:@"Mobile" withFont:APP_FONT fontSize:18 fontColor:UICOLOR(0, 0, 0, 0.3) strokeColor:CLEAR_COLOR]];
    
    [Global setFont:APP_FONT withSize:18 color:BLACK_COLOR toUIViewType:TextField objectArr:@[tfEmail, tfFirstName, tfLastName, tfMobile, tfBirthdate]];
    
    [Global setFont:@"HelveticaNeue" withSize:18 color:APP_TINT_COLOR toUIViewType:TextField objectArr:@[tfPassword]];
    
    
    [lblFooterView setFont:FONT_WITH_NAME_SIZE(APP_FONT, 11)];
    [lblFooterView setTextColor:APP_TINT_COLOR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    [btnLogin setTitle:@"Log in" forState:UIControlStateNormal];
    [btnLogin setTitle:@"Loging in" forState:UIControlStateSelected];
    
    [btnSignup setTitle:@"Register" forState:UIControlStateNormal];
    [btnSignup setTitle:@"Registering..." forState:UIControlStateSelected];
    
    
    [datePicker setMaximumDate:[NSDate date]];
    
//    [tfEmail setText:@"nareshkharecha@gmail.com"];
//    [tfPassword setText:@"nareshnaresh"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    // fixing bug for leaving view
    [self.view setBackgroundColor:CLEAR_COLOR];
    [imgViewBackground setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    // fixing bug for entering view
    
    [imgViewBackground setHidden:NO];
    [imgViewBackground setImage:self.imageFromPreviousScreen];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - View Setup
#pragma mark -
- (void)setUpView
{
    // Blur Effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bluredEffectView setFrame:imgViewVisualEffect.bounds];
    
    [imgViewVisualEffect addSubview:bluredEffectView];
}

#pragma mark - Shake TextField
#pragma mark -
- (void)shakeTextField:(UITextField *)tf
{
    [tf shake:ShakeShakes withDelta:ShakeDelta andSpeed:ShakeSpeed shakeDirection:ShakeDirectionHorizontal];
}

#pragma mark - KeyboardNotification
#pragma mark -
- (void)registerToReciveKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (keyboardShown) {
        return;
    }
    
    NSDictionary *userInfo = [aNotification userInfo];
    
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
    
    keyboardShown = YES;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [self.tableView setContentInset:UIEdgeInsetsZero];
    [UIView commitAnimations];
    
    activeTextField = nil;
    
    keyboardShown = NO;
}

#pragma mark - Misc
#pragma mark -

- (NSString *)getAlertMessageType:(AlertMsgType)msgType
{
    NSString *strAlertMsg;
    switch (msgType) {
        case InternetOffline: {
            strAlertMsg = kCHECK_INTERNET;
        }
            break;
        case RequestTimeOut: {
            strAlertMsg = kREQUEST_TIME_OUT;
        }
            break;
        case InvalidCredentials: {
            strAlertMsg = @"Invalid Username/Password!";
        }
            break;
        case InvalidEmail: {
            strAlertMsg = @"Email not found";
        }
            break;
        case EmailExist: {
            strAlertMsg = @"Email already exist!";
        }
            break;
        case PasswordSent: {
            strAlertMsg = @"Password has been sent.";
            [btnLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case Signedup: {
            strAlertMsg = @"You've Signed Up successfully!";
            [btnLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case SomethingWentWrong: {
            strAlertMsg = kSOMETHING_WENT_WRONG;
        }
        default:
            break;
    }
    return strAlertMsg;
}

- (void)textFieldValueChanged
{
    switch (_viewType) {
        case LOGIN_VIEW: {
            if ([tfEmail.text length] != 0 &&
                [tfPassword.text length] != 0) {
                [btnLogin setEnabled:YES];
            }
            else {
                [btnLogin setEnabled:NO];
            }
            
            [btnSignup setEnabled:YES];
            [btnForgotPass setEnabled:YES];
        }
            break;
        case SIGN_UP_VIEW: {
            if ([tfEmail.text length] != 0 &&
//                [tfPassword.text length] != 0 &&
                [tfFirstName.text length] != 0 &&
                [tfLastName.text length] != 0)
//                [tfMobile.text length] != 0 &&
//                [tfBirthdate.text length] != 0)
            {
                [btnSignup setEnabled:YES];
            }
            else {
                [btnSignup setEnabled:NO];
            }
            
            if ((activeTextField == tfFirstName || activeTextField == tfLastName) &&
                [activeTextField.text length] > 15) {
                [self shakeTextField:activeTextField];
            }
            
            [btnLogin setEnabled:YES];
            [btnForgotPass setEnabled:YES];
        }
            break;
        case FORGOT_PASS_VIEW: {
            if ([tfEmail.text length] != 0) {
                [btnForgotPass setEnabled:YES];
            }
            else {
                [btnForgotPass setEnabled:NO];
            }
            
            [btnLogin setEnabled:YES];
            [btnSignup setEnabled:YES];
        }
            break;
        default:
            break;
    }
}

- (void)updateTextFieldTag
{
    switch (_viewType) {
        case LOGIN_VIEW: {
            [self removeKeyboardNotificationObserver];
            [tfEmail setTag:0];
            [tfEmail setReturnKeyType:UIReturnKeyNext];
            [tfPassword setTag:1];
            [tfPassword setReturnKeyType:UIReturnKeyGo];
        }
            break;
        case SIGN_UP_VIEW: {
            [self registerToReciveKeyboardNotification];
            [tfFirstName setTag:0];
            [tfFirstName setReturnKeyType:UIReturnKeyNext];
            [tfLastName setTag:1];
            [tfLastName setReturnKeyType:UIReturnKeyNext];
            [tfEmail setTag:2];
            [tfEmail setReturnKeyType:UIReturnKeyNext];
            [tfPassword setTag:3];
            [tfPassword setReturnKeyType:UIReturnKeyNext];
            [tfBirthdate setTag:4];
            [tfBirthdate setReturnKeyType:UIReturnKeyNext];
            [tfMobile setTag:5];
            [tfMobile setReturnKeyType:UIReturnKeyJoin];
        }
            break;
        case FORGOT_PASS_VIEW: {
            [self removeKeyboardNotificationObserver];
            [tfEmail setTag:0];
            [tfEmail setReturnKeyType:UIReturnKeyGo];
        }
            break;
        default:
            break;
    }
    [self setBlankStringToTextFields];
}
- (void)updateButtonLookFeel
{
    switch (_viewType) {
        case LOGIN_VIEW: {
            [btnForgotPass setTitle:@"Forgot password?" forState:UIControlStateNormal];
            [btnForgotPass setTitle:@"Forgot password?" forState:UIControlStateHighlighted];
            
            
            [Global applyPropertiesToButtons:@[btnLogin] likeFont:APP_FONT fontSize:22 fontNormalColor:WHITE_COLOR fontHighlightedColor:WHITE_COLOR borderColor:CLEAR_COLOR borderWidth:0 cornerRadius:0 normalBackgroundColor:APP_TINT_COLOR andHighlightedBackgroundColor:APP_TINT_COLOR];
            
            [Global applyPropertiesToButtons:@[btnSignup, btnForgotPass] likeFont:APP_FONT fontSize:17 fontNormalColor:APP_TINT_COLOR fontHighlightedColor:APP_TINT_COLOR borderColor:CLEAR_COLOR borderWidth:0 cornerRadius:0 normalBackgroundColor:CLEAR_COLOR andHighlightedBackgroundColor:CLEAR_COLOR];
            
            [btnLogin setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            
            [btnForgotPass setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [btnSignup setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            
            [lblFooterView setText:@""];
        }
            break;
        case SIGN_UP_VIEW: {
            [btnForgotPass setTitle:@"Forgot password?" forState:UIControlStateNormal];
            [btnForgotPass setTitle:@"Forgot password?" forState:UIControlStateHighlighted];
            
//            [Global applyPropertiesToButtons:@[btnSignup] likeFont:APP_FONT fontSize:22 fontNormalColor:WHITE_COLOR fontHighlightedColor:WHITE_COLOR borderColor:CLEAR_COLOR borderWidth:0 cornerRadius:0 normalBackgroundColor:APP_TINT_COLOR andHighlightedBackgroundColor:APP_TINT_COLOR];
            
            [btnSignup.titleLabel setFont:FONT_WITH_NAME_SIZE(APP_FONT, 24)];
            [btnSignup.titleLabel setTextColor:BLACK_COLOR];
            
            [Global applyPropertiesToButtons:@[btnLogin, btnForgotPass] likeFont:APP_FONT fontSize:17 fontNormalColor:APP_TINT_COLOR fontHighlightedColor:APP_TINT_COLOR borderColor:CLEAR_COLOR borderWidth:0 cornerRadius:0 normalBackgroundColor:CLEAR_COLOR andHighlightedBackgroundColor:CLEAR_COLOR];
            
            [lblFooterView setText:@""];
            
            [btnSignup setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            
            [btnLogin setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        }
            break;
        case FORGOT_PASS_VIEW: {
            [btnForgotPass setTitle:@"Reset" forState:UIControlStateNormal];
            [btnForgotPass setTitle:@"Reset" forState:UIControlStateHighlighted];
            [btnForgotPass setTitle:@"" forState:UIControlStateSelected];
            
            [Global applyPropertiesToButtons:@[btnForgotPass] likeFont:APP_FONT fontSize:22 fontNormalColor:WHITE_COLOR fontHighlightedColor:WHITE_COLOR borderColor:CLEAR_COLOR borderWidth:0 cornerRadius:0 normalBackgroundColor:APP_TINT_COLOR andHighlightedBackgroundColor:APP_TINT_COLOR];
            
            [Global applyPropertiesToButtons:@[btnLogin, btnSignup] likeFont:APP_FONT fontSize:17 fontNormalColor:APP_TINT_COLOR fontHighlightedColor:APP_TINT_COLOR borderColor:CLEAR_COLOR borderWidth:0 cornerRadius:0 normalBackgroundColor:CLEAR_COLOR andHighlightedBackgroundColor:CLEAR_COLOR];
            
            [lblFooterView setText:@"New password will be sent to your registered email."];
            
            [btnForgotPass setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            
            [btnLogin setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [btnSignup setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        }
            break;
        default:
            break;
    }
    
    [self textFieldValueChanged];
}

- (void)setBlankStringToTextFields
{
    [tfEmail setText:@""];
    [tfPassword setText:@""];
    [tfFirstName setText:@""];
    [tfLastName setText:@""];
    [tfMobile setText:@""];
    [tfBirthdate setText:@""];
    
    [imgViewProPic setImage:image_placeholder_80];
}

- (BOOL)validateTextFieldValues
{
    BOOL flag = YES;
    
    switch (_viewType) {
        case LOGIN_VIEW: {
            if (![Global validateEmail:tfEmail.text]) {
                flag = NO;
                [self shakeTextField:tfEmail];
            }
        }
            break;
        case SIGN_UP_VIEW: {
            if (![Global validateEmail:tfEmail.text]) {
                flag = NO;
                [self shakeTextField:tfEmail];
            }
            
//            if ([tfPassword.text length] < 8 || [tfPassword.text length] > 25) {
//                flag = NO;
//                [self shakeTextField:tfPassword];
//            }
            
            if ([tfFirstName.text length] > 15) {
                flag = NO;
                [self shakeTextField:tfFirstName];
            }
            
            if ([tfLastName.text length] > 15) {
                flag = NO;
                [self shakeTextField:tfLastName];
            }
        }
            break;
        case FORGOT_PASS_VIEW: {
            if (![Global validateEmail:tfEmail.text]) {
                flag = NO;
                [self shakeTextField:tfEmail];
            }
        }
            break;
        default: {
            if (flag) {
                VIBRATE_DEVICE;
            }
        }
            break;
    }
    
    return flag;
}

#pragma mark - Action Methods
#pragma mark -

- (IBAction)barBtnCloseTaped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imgViewTaped:(id)sender {
    [self.view endEditing:YES];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *deletePhotoAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Delete Photo", @"Delete action")
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       [imgViewProPic setImage:image_placeholder_80];
                                       isImageSet = NO;
                                   }];
    
    UIAlertAction *cameraAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Take Photo", @"Camera action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                   picker.delegate = self;
                                   picker.allowsEditing = YES;
                                   
                                   if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                       UI_ALERT(WARNING, @"Device has no camera!", nil);
                                   }
                                   else {
                                       picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                   }
                                   
                                   [self presentViewController:picker animated:YES completion:nil];
                               }];
    
    UIAlertAction *libraryAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Choose Photo", @"Library action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                       picker.delegate = self;
                                       picker.allowsEditing = YES;
                                       
                                       picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                       [self presentViewController:picker animated:YES completion:nil];
                                   }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction *action)
                                    {
                                        [alertController dismissViewControllerAnimated:YES completion:nil];
                                    }];
    
    if (isImageSet) {
        [alertController addAction:deletePhotoAction];
    }
    
    [alertController addAction:cameraAction];
    [alertController addAction:libraryAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:isImageSet ? @"Remove Picture" : nil otherButtonTitles:@"Take From Camera", @"Take From Library", nil];
//    
//    [actionSheet showInView:self.view];
}

- (IBAction)btnActionTaped:(id)sender {
    
    [activeTextField resignFirstResponder];
    
    [self textFieldValueChanged];
    
    switch ([sender tag]) {
        case 0: {
            if (_viewType == SIGN_UP_VIEW) {
                if ([self validateTextFieldValues]) {
                    
//                    [indicator startAnimating];
//                    [btnSignup setSelected:YES];
                    
                    [self makeSignupRequest];
//                    [self showVerificationAlert];
                }
            }
            else {
                [self setBlankStringToTextFields];
                
                NSArray *insertIndexPaths;
                switch (_viewType) {
                    case LOGIN_VIEW: {
                        insertIndexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0],
                                             [NSIndexPath indexPathForRow:3 inSection:0],
                                             [NSIndexPath indexPathForRow:4 inSection:0]
                                             ];
                        _viewType = SIGN_UP_VIEW;
                    }
                        break;
                    case FORGOT_PASS_VIEW: {
                        insertIndexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0],
                                             [NSIndexPath indexPathForRow:2 inSection:0],
                                             [NSIndexPath indexPathForRow:3 inSection:0],
                                             [NSIndexPath indexPathForRow:4 inSection:0]
                                             ];
                        _viewType = SIGN_UP_VIEW;
                    }
                        break;
                    default:
                        break;
                }
                
                [self updateButtonLookFeel];
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
                
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1],
                                                         [NSIndexPath indexPathForRow:1 inSection:1],
                                                         [NSIndexPath indexPathForRow:0 inSection:0],
                                                         [NSIndexPath indexPathForRow:1 inSection:0],
                                                         [NSIndexPath indexPathForRow:2 inSection:0]
                                                         ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                
                [self updateTextFieldTag];
                
                //                [tfEmail becomeFirstResponder];
            }
        }
            break;
        case 1: {
            if (_viewType == LOGIN_VIEW) {
                
                //                [self showAllowAPNSAccessView:YES];
                
                if ([self validateTextFieldValues]) {
                    
                    [APP_DELEGATE registerForUserNotifications:^(BOOL success) {
                       
                        if (success) {
                            [self makeLoginRequest];
                        }
                        else {
                            UI_ALERT(APP_NAME, @"You refused to allow \"Lawyer Diary App\" to send you notifications. You can change the preference by navigating to phone Settings > Find the Lawyer Diary App > Switch on Notification", self);
                        }
                    }];
                }
            }
            else {
                [self setBlankStringToTextFields];
                
                switch (_viewType) {
                    case SIGN_UP_VIEW: {
                        NSArray *deleteIndexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0],
                                                      [NSIndexPath indexPathForRow:3 inSection:0],
                                                      [NSIndexPath indexPathForRow:4 inSection:0]
                                                      ];
                        _viewType = LOGIN_VIEW;
                        
                        [self updateButtonLookFeel];
                        
                        [self.tableView beginUpdates];
                        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [self.tableView endUpdates];
                        
                        [self.tableView beginUpdates];
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1],
                                                                 [NSIndexPath indexPathForRow:1 inSection:1],
                                                                 [NSIndexPath indexPathForRow:0 inSection:0],
                                                                 [NSIndexPath indexPathForRow:1 inSection:0]
                                                                 ]
                                              withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView endUpdates];
                    }
                        break;
                    case FORGOT_PASS_VIEW: {
                        NSArray *insertIndexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0],
                                                      ];
                        _viewType = LOGIN_VIEW;
                        
                        [self updateButtonLookFeel];
                        
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
                        [self.tableView endUpdates];
                        
                        [self.tableView beginUpdates];
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],
                                                                 [NSIndexPath indexPathForRow:0 inSection:1],
                                                                 [NSIndexPath indexPathForRow:1 inSection:1]
                                                                 ]
                                              withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView endUpdates];
                    }
                        break;
                    default:
                        break;
                }
                [self updateTextFieldTag];
                
                //                [tfEmail becomeFirstResponder];
            }
        }
            break;
        case 2: {
            if (_viewType == FORGOT_PASS_VIEW) {
                
                if ([self validateTextFieldValues]) {
                    [self makeResetPassword];
                }
            }
            else {
                [self setBlankStringToTextFields];
                
                NSArray *deleteIndexPaths;
                switch (_viewType) {
                    case SIGN_UP_VIEW: {
                        deleteIndexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0],
                                             [NSIndexPath indexPathForRow:2 inSection:0],
                                             [NSIndexPath indexPathForRow:3 inSection:0],
                                             [NSIndexPath indexPathForRow:4 inSection:0]
                                             ];
                    }
                        break;
                    case LOGIN_VIEW: {
                        deleteIndexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0]
                                             ];
                    }
                        break;
                    default:
                        break;
                }
                _viewType = FORGOT_PASS_VIEW;
                
                [self updateButtonLookFeel];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],
                                                         [NSIndexPath indexPathForRow:0 inSection:1],
                                                         [NSIndexPath indexPathForRow:1 inSection:1]
                                                         ]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self updateTextFieldTag];
                
                //                [tfEmail becomeFirstResponder];
            }
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)showIndicator:(BOOL)flag forView:(VIEW_TYPE)viewType
{
    flag ? [indicator startAnimating] : [indicator stopAnimating];
    switch (viewType) {
        case LOGIN_VIEW: {
            [btnLogin setSelected:flag];
        }
            break;
        case SIGN_UP_VIEW: {
            [btnSignup setSelected:flag];
        }
            break;
        case FORGOT_PASS_VIEW: {
            [btnForgotPass setSelected:flag];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Make Login Request
#pragma mark -
- (void)makeLoginRequest
{
    if (IS_INTERNET_CONNECTED)
    {
        [self showIndicator:YES forView:LOGIN_VIEW];
        [btnLogin setSelected:YES];
        
        NSDictionary *params = @{
                                 kAPIMode: klogIn,
                                 kAPIemail: tfEmail.text,
                                 kAPIpassword: tfPassword.text,
                                 kAPIdeviceToken: ShareObj.deviceToken,
                                 kAPIdeviceType: @0
                                 };
        
        UserIntrectionEnable(NO);
        [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [indicator stopAnimating];
            UserIntrectionEnable(YES);
            [btnLogin setSelected:NO];
            
            if (responseObject == nil) {
                [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
            }
            else {
                if ([responseObject[kAPIstatus] isEqualToNumber:@0]) {
                    UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                }
                else {
                    [self saveUserInfo:responseObject];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [indicator stopAnimating];
            UserIntrectionEnable(YES);
            [btnLogin setSelected:NO];
            
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
    else {
        [Global showNotificationWithTitle:[self getAlertMessageType:InternetOffline] titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

#pragma mark - Make SignUp Request
#pragma mark -
- (void)makeSignupRequest
{
    if (IS_INTERNET_CONNECTED)
    {
        [indicator startAnimating];
        [btnSignup setSelected:YES];
        
        NSDictionary *params = @{
                                 kAPIMode: ksignUp,
                                 kAPIproPic: isImageSet ? [Global encodeToBase64String:imgViewProPic.image] : @"",
                                 kAPIemail: tfEmail.text,
                                 kAPIpassword: tfFirstName.text,
                                 kAPIfirstName: tfFirstName.text,
                                 kAPIlastName: tfLastName.text,
                                 kAPImobile: _userMobile,
                                 kAPIbirthdate: @"2000-01-01",
                                 kAPIaddress: @"",
                                 kAPIregistrationNo: @""
                                 };
        
        UserIntrectionEnable(NO);
        [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [indicator stopAnimating];
            UserIntrectionEnable(YES);
            [btnSignup setSelected:NO];
            
            if (responseObject == nil) {
                [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
            }
            else {
                if ([responseObject[kAPIstatus] isEqualToNumber:@0]) {
                    UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                }
                else {
//                    UI_ALERT(APP_NAME, [responseObject valueForKey:kAPImessage], nil);
                    
                    [self saveUserInfo:[responseObject valueForKey:kAPIuserDetail]];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [indicator stopAnimating];
            UserIntrectionEnable(YES);
            [btnSignup setSelected:NO];
            
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
    else {
        [Global showNotificationWithTitle:[self getAlertMessageType:InternetOffline] titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

#pragma mark - Show Verification Alert
#pragma mark -
- (void)showVerificationAlert
{
    NSString *alertTitle = NSLocalizedString(@"Enter Verification Code", @"Text Input Alert");
    NSString *alertMessage = NSLocalizedString(@"Please enter received verification code via text message", @"Plain and secure text input");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Code", @"Login");
         [textField setKeyboardType:UIKeyboardTypeNumberPad];
         //         [textField addTarget:self
         //                       action:@selector(alertTextFieldDidChange:)
         //             forControlEvents:UIControlEventEditingChanged];
     }];
    
    //    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
    //     {
    //         textField.placeholder = NSLocalizedString(@"PasswordPlaceholder", @"Password");
    //         textField.secureTextEntry = YES;
    //     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", @"OK action")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   UITextField *login = alertController.textFields.firstObject;
                                   //                                   UITextField *password = alertController.textFields.lastObject;
                                   
                                   if (![login.text isEqualToString:@""]) {
                                       
                                       if ([_verificationCode isEqualToNumber:@(login.text.integerValue)]) {
                                           [self makeSignupRequest];
                                       }
                                       else {
                                           [Global showNotificationWithTitle:@"Please enter valid verification code" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                                           
                                           [self presentViewController:alertController animated:YES completion:nil];
                                       }
                                   }
                                   else {
                                       [Global showNotificationWithTitle:@"Please enter verification code" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                                       
                                       [self presentViewController:alertController animated:YES completion:nil];
                                   }
                                   
                                   NSLog(@"OK action");
                                   NSLog(@"Login value: %@",login.text);
                                   //                                   NSLog(@"Password value: %@",password.text);
                               }];
    
    //    okAction.enabled = NO;
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Make Reset Password Request
#pragma mark -
- (void)makeResetPassword
{
    if (IS_INTERNET_CONNECTED) {
        [indicator startAnimating];
        [btnForgotPass setSelected:YES];
        
        NSDictionary *params = @{
                                 kAPIMode: kforgotPassword,
                                 kAPIemail: tfEmail.text,
                                 };
        
        UserIntrectionEnable(NO);
        [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [indicator stopAnimating];
            UserIntrectionEnable(YES);
            [btnForgotPass setSelected:NO];
            
            if (responseObject == nil) {
                [Global showNotificationWithTitle:kSOMETHING_WENT_WRONG titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
            }
            else {
                if ([responseObject[kAPIstatus] isEqualToNumber:@0]) {
                    UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                }
                else {
                    UI_ALERT(APP_NAME, [responseObject valueForKey:kAPImessage], nil);
                }
            }
            
            [btnLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [indicator stopAnimating];
            UserIntrectionEnable(YES);
            [btnForgotPass setSelected:NO];
            
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
    else {
        [Global showNotificationWithTitle:[self getAlertMessageType:InternetOffline] titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
    }
}

#pragma mark - UITableViewDelegate / UITableViewDatasource
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat footerHeight;
    
    footerHeight = 15;
    
    return footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return lblFooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger rowHeight;
    switch (_viewType) {
        case LOGIN_VIEW: {
            rowHeight = 44;
        }
            break;
        case SIGN_UP_VIEW: {
            if (indexPath.section == 0 && indexPath.row == 0) {
                rowHeight = 88;
            }
           else if (indexPath.section == 0 && indexPath.row == 2) {
                rowHeight = (isPickerShown)?206:44;
            }
            else {
                rowHeight = 44;
            }
        }
            break;
        case FORGOT_PASS_VIEW: {
            rowHeight = 44;
        }
            break;
        default:
            break;
    }
    
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger noOfRow;
    
    switch (_viewType) {
        case LOGIN_VIEW: {
            switch (section) {
                case 0: {
                    noOfRow = 2;
                }
                    break;
                case 1: {
                    noOfRow = 2;
                }
                default:
                    break;
            }
        }
            break;
        case SIGN_UP_VIEW: {
            switch (section) {
                case 0: {
                    noOfRow = 2;
                }
                    break;
                case 1: {
                    noOfRow = 1;
                }
                default:
                    break;
            }
        }
            break;
        case FORGOT_PASS_VIEW: {
            switch (section) {
                case 0: {
                    noOfRow = 1;
                }
                    break;
                case 1: {
                    noOfRow = 2;
                }
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return noOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    NSString *cellID = nil;
    
    switch (_viewType) {
        case LOGIN_VIEW: {
            switch (indexPath.section) {
                case 0:
                    switch (indexPath.row) {
                        case 0: {
                            cellID = kEmailCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [tfEmail setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
                            [cell.contentView addSubview:tfEmail];

                            [cell.contentView addSubview:[Global getImgViewOfRect:CGRectMake(0, cell.frame.size.height-1, tfEmail.frame.size.width, 1) withImage:IMAGE_WITH_NAME(@"seprator") andBackgroundColor:CLEARCOLOUR]];
                        }
                            break;
                        case 1: {
                            cellID = kPasswordCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [tfPassword setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
                            [cell.contentView addSubview:tfPassword];
                            
                            [cell.contentView addSubview:[Global getImgViewOfRect:CGRectMake(0, cell.frame.size.height-1, tfEmail.frame.size.width, 1) withImage:nil andBackgroundColor:WHITE_COLOR]];
                        }
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    switch (indexPath.row) {
                        case 0: {
                            cellID = kActionButtonCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [btnLogin setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
                            [cell.contentView sendSubviewToBack:btnLogin];
                            [cell.contentView addSubview:btnLogin];
                            
                            [indicator setFrame:CGRectMake(SCREEN_WIDTH(btnLogin)-30, (SCREEN_HEIGHT(btnLogin)/2)-10, 20, 20)];
                            [btnLogin addSubview:indicator];
                            [btnLogin bringSubviewToFront:indicator];
                        }
                            break;
                        case 1: {
                            cellID = kOtherButtonCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [btnForgotPass setFrame:CGRectMake(0, 0, 160, ViewHeight(cell))];
                            [btnSignup setFrame:CGRectMake(ViewWidth(cell)-80, 5, 80, ViewHeight(cell))];
                            [cell.contentView addSubview:btnForgotPass];
                            [cell.contentView addSubview:btnSignup];
                        }
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        case SIGN_UP_VIEW: {
            switch (indexPath.section) {
                case 0:
                    switch (indexPath.row) {
                        case 0: {
                            cellID = kFirstCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [imgViewProPic setFrame:CGRectMake(9, 9, imgViewProPic.frame.size.width, imgViewProPic.frame.size.height)];
                            
                            [imgViewProPic setImage:IMAGE_WITH_NAME(@"user-avatar-80")];
                            
                            [cell.contentView addSubview:imgViewProPic];
                            
                            [tfFirstName setFrame:CGRectMake(80, 0, ViewWidth(cell)-(ViewWidth(imgViewProPic)+18), ViewHeight(cell)/2)];
                            [cell.contentView addSubview:tfFirstName];
                            
                            [cell.contentView addSubview:[Global getImgViewOfRect:CGRectMake(88, 43, tfFirstName.frame.size.width+15, 1) withImage:IMAGE_WITH_NAME(@"seprator") andBackgroundColor:CLEARCOLOUR]];
                            
                            [tfLastName setFrame:CGRectMake(80, 44, ViewWidth(cell)-(ViewWidth(imgViewProPic)+18), ViewHeight(cell)/2)];
                            [cell.contentView addSubview:tfLastName];
                            
                            [cell.contentView addSubview:[Global getImgViewOfRect:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1) withImage:IMAGE_WITH_NAME(@"seprator") andBackgroundColor:CLEARCOLOUR]];
                        }
                            break;
                        case 1: {
                            cellID = kEmailCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [tfEmail setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
                            [cell.contentView addSubview:tfEmail];
                            
                            [cell.contentView addSubview:[Global getImgViewOfRect:CGRectMake(0, ViewHeight(cell)-1, ViewWidth(cell), 1) withImage:IMAGE_WITH_NAME(@"seprator") andBackgroundColor:CLEARCOLOUR]];
                        }
                            break;
//                        case 2: {
//                            cellID = kPasswordCellID;
//                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//                            if (cell == nil) {
//                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//                            }
//                            [tfPassword setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
//                            [cell.contentView addSubview:tfPassword];
//                            
//                            [cell.contentView addSubview:[Global getImgViewOfRect:CGRectMake(0, ViewHeight(cell)-1, ViewWidth(cell), 1) withImage:nil andBackgroundColor:TABLEVIEW_SEPRATOR_COLOR]];
//                        }
//                            break;
//                        case 2: {
//                            cellID = kMobileCellID;
//                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//                            if (cell == nil) {
//                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//                            }
//                            [tfMobile setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
//                            [cell.contentView addSubview:tfMobile];
//                            
//                            [cell.contentView addSubview:[Global getImgViewOfRect:CGRectMake(0, ViewHeight(cell)-1, ViewWidth(cell), 1) withImage:nil andBackgroundColor:TABLEVIEW_SEPRATOR_COLOR]];
//                        }
//                            break;
//                        case 2: {
//                            cellID = kBirthdateCellID;
//                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//                            if (cell == nil) {
//                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//                            }
//                            [tfBirthdate setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
//                            [datePicker setFrame:CGRectMake(0, tfBirthdate.frame.size.height, ViewWidth(cell), datePicker.frame.size.height)];
//                            [cell.contentView addSubview:datePicker];
//                            [cell.contentView addSubview:tfBirthdate];
//                            [cell setClipsToBounds:YES];
//                            
//                            [btnDone setFrame:CGRectMake(ViewWidth(cell) - (ViewWidth(btnDone)), 5, ViewWidth(btnDone), ViewHeight(btnDone))];
//                            [btnDone setHidden:YES];
//                            [cell.contentView addSubview:btnDone];
//                        }
//                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    switch (indexPath.row) {
                        case 0: {
                            cellID = kActionButtonCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [btnSignup setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
                            [cell.contentView sendSubviewToBack:btnSignup];
                            [cell.contentView addSubview:btnSignup];
                            
                            [indicator setFrame:CGRectMake(SCREEN_WIDTH(btnSignup)-30, (SCREEN_HEIGHT(btnSignup)/2)-10, 20, 20)];
                            [btnSignup addSubview:indicator];
                            [btnSignup bringSubviewToFront:indicator];
                        }
                            break;
                        case 1: {
                            cellID = kOtherButtonCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            //                            [btnForgotPass setFrame:CGRectMake(20, 0, 160, 30)];
                            [btnLogin setFrame:CGRectMake(ViewWidth(cell)-70, 0, 70, ViewHeight(cell))];
                            //                            [cell.contentView addSubview:btnForgotPass];
                            [cell.contentView addSubview:btnLogin];
                        }
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        case FORGOT_PASS_VIEW: {
            switch (indexPath.section) {
                case 0:
                    switch (indexPath.row) {
                        case 0: {
                            cellID = kEmailCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [tfEmail setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
                            [cell.contentView addSubview:tfEmail];
                            
                            [cell.contentView addSubview:[Global getImgViewOfRect:CGRectMake(0, ViewHeight(cell)-1, ViewWidth(cell), 1) withImage:nil andBackgroundColor:WHITE_COLOR]];
                        }
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    switch (indexPath.row) {
                        case 0: {
                            cellID = kActionButtonCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [btnForgotPass setFrame:CGRectMake(0, 0, ViewWidth(cell), ViewHeight(cell))];
                            [cell.contentView sendSubviewToBack:btnForgotPass];
                            [cell.contentView addSubview:btnForgotPass];
                            
                            [indicator setFrame:CGRectMake((SCREEN_WIDTH(btnForgotPass)/2)-10, (SCREEN_HEIGHT(btnForgotPass)/2)-10, 20, 20)];
                            [btnForgotPass addSubview:indicator];
                            [btnForgotPass bringSubviewToFront:indicator];
                        }
                            break;
                        case 1: {
                            cellID = kOtherButtonCellID;
                            cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                            }
                            [btnSignup setFrame:CGRectMake(0, 0, 80, ViewHeight(cell))];
                            [btnLogin setFrame:CGRectMake(ViewWidth(cell)-70, 5, 70, ViewHeight(cell))];
                            [cell.contentView addSubview:btnSignup];
                            [cell.contentView addSubview:btnLogin];
                        }
                            break;
                        default:
                            break;
                    }
                    break;
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UIActionSheetDelegate
#pragma mark -
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor greenColor];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (buttonIndex == 0 && isImageSet) {
        [imgViewProPic setImage:image_placeholder_80];
        isImageSet = NO;
    }
    else if ((buttonIndex == 0 && !isImageSet) ||
             (buttonIndex == 1 && isImageSet))
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UI_ALERT(WARNING, @"Device has no camera!", nil);
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

#pragma mark - UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self makeLoginRequest];
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

#pragma mark - UITextFieldDelegate
#pragma mark -
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==tfBirthdate) {
        
        if (tfBirthdate.text.length > 0) {
            [datePicker setDate:[Global getDatefromDateString:tfBirthdate.text ofFormat:DefaultBirthdateFormat]];
        }
        
        [btnDone setHidden:NO];
        
        [activeTextField resignFirstResponder];
        
        isPickerShown=TRUE;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    switch (_viewType) {
        case LOGIN_VIEW: {
            id firstResponder = [self getFirstResponder];
            if ([firstResponder isKindOfClass:[UITextField class]]) {
                NSUInteger tag = [firstResponder tag];
                NSUInteger nextTag = tag == LOGIN_FIELDS_COUNT ? LOGIN_FIELDS_COUNT : tag + 1;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: nextTag inSection: 0];
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                if (cell != nil) {
                    for (UIView *view in  cell.contentView.subviews){
                        
                        if ([view isKindOfClass:[UITextField class]]){
                            
                            UITextField* nextField = (UITextField *)view;
                            if(nextField.tag == nextTag) {
                                [nextField becomeFirstResponder];
                            }
                        }
                    }
                }
                else if ([tfEmail.text isEqualToString:@""] || [tfEmail.text isEqualToString:nil]) {
                    [tfEmail becomeFirstResponder];
                }
                else if ([tfPassword.text isEqualToString:@""] || [tfPassword.text isEqualToString:nil]) {
                    [tfPassword becomeFirstResponder];
                }
                else {
                    [activeTextField resignFirstResponder];
                    
                    [btnLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
            break;
        case SIGN_UP_VIEW: {
            
            id firstResponder = [self getFirstResponder];
            if ([firstResponder isKindOfClass:[UITextField class]]) {
                NSUInteger tag = [firstResponder tag];
                NSUInteger nextTag = tag == SIGNUP_FIELDS_COUNT ? SIGNUP_FIELDS_COUNT : tag + 1;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nextTag == 1 ? 0 : nextTag+1 inSection:0];
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                if (cell != nil) {
                    for (UIView *view in  cell.contentView.subviews){
                        
                        if ([view isKindOfClass:[UITextField class]]){
                            
                            UITextField* nextField = (UITextField *)view;
                            if(nextField.tag == nextTag) {
                                [nextField becomeFirstResponder];
                            }
                        }
                    }
                }
                else if ([tfFirstName.text isEqualToString:@""] || [tfFirstName.text isEqualToString:nil]){
                    [tfFirstName becomeFirstResponder];
                }
                else if ([tfLastName.text isEqualToString:@""] || [tfLastName.text isEqualToString:nil]) {
                    [tfLastName becomeFirstResponder];
                }
                else if ([tfEmail.text isEqualToString:@""] || [tfEmail.text isEqualToString:nil]) {
                    [tfEmail becomeFirstResponder];
                }
//                else if ([tfPassword.text isEqualToString:@""] || [tfPassword.text isEqualToString:nil]) {
//                    [tfPassword becomeFirstResponder];
//                }
//                else if ([tfMobile.text isEqualToString:@""] || [tfMobile.text isEqualToString:nil]) {
//                    [tfMobile becomeFirstResponder];
//                }
                else {
                    [activeTextField resignFirstResponder];
                    
                    [btnSignup sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
            break;
        case FORGOT_PASS_VIEW: {
            if (![tfEmail.text isEqualToString:@""]) {
                [activeTextField resignFirstResponder];
                
                [btnForgotPass sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == tfFirstName || textField == tfLastName)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if (textField == tfMobile) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else
        return YES;
}

#pragma mark - Keyboard Misc
#pragma mark -
- (void)resignKeyboard
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
    }
}

- (id)getFirstResponder
{
    NSUInteger index = 0;
    switch (_viewType) {
        case LOGIN_VIEW: {
            while (index < LOGIN_FIELDS_COUNT) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection: 0];
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                for (UIView *view in  cell.contentView.subviews){
                    
                    if ([view isKindOfClass:[UITextField class]]){
                        
                        UITextField* textField = (UITextField *)view;
                        if(textField.tag == index) {
                            if ([textField isFirstResponder]) {
                                return textField;
                            }
                        }
                    }
                }
                index++;
            }
        }
            break;
        case SIGN_UP_VIEW: {
            while (index <= SIGNUP_FIELDS_COUNT) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(index == 0 || index == 1) ? 0 : index inSection: 0];
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                for (UIView *view in  cell.contentView.subviews){
                    
                    if ([view isKindOfClass:[UITextField class]]){
                        
                        UITextField* textField = (UITextField *)view;
                        if(textField.tag == index) {
                            if ([textField isFirstResponder]) {
                                return textField;
                            }
                        }
                    }
                }
                index++;
            }
        }
            break;
        case FORGOT_PASS_VIEW: {
            while (index < FORGOTPASS_FIELDS_COUNT) {
                UITextField *textField = (UITextField *)[self.tableView viewWithTag:index];
                if ([textField isFirstResponder]) {
                    return textField;
                }
                index++;
            }
        }
            break;
        default:
            break;
    }
    
    
    return nil;
}

#pragma mark - Save User Info
#pragma mark -
- (void)saveUserInfo:(NSDictionary *)userDic
{
    @try {
        if (userDic) {
            NSString *userId = [userDic valueForKey:kAPIuserId];
            SetLoginUserId(userId);
            SetLoginUserPassword(tfPassword.text);
            
            ShareObj.loginuserId = GetLoginUserId;
            ShareObj.currentPassword = GetLoginUserPassword;
            
            ShareObj.userObj = [User saveUser:userDic];
            
            [APP_DELEGATE showHome];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

#pragma mark - Memory Management
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDoneTaped:(id)sender
{
    [tfBirthdate setText:[Global getDateStringFromDate:datePicker.date ofFormat:DefaultBirthdateFormat]];
    
    [btnDone setHidden:YES];
    
    isPickerShown = FALSE;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (IBAction)DatePickerValueChanged:(id)sender {
    [tfBirthdate setText:[Global getDateStringFromDate:datePicker.date ofFormat:DefaultBirthdateFormat]];
}
@end
