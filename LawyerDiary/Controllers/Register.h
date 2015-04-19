//
//  Register.h
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/19/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIConnection.h"
#import "FFTextField.h"

@interface Register : UIViewController <UITableViewDataSource, UITableViewDelegate, APIConnectionDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet FFTextField *tfFirstName;
    IBOutlet FFTextField *tfLastName;
    IBOutlet FFTextField *tfEmail;
    IBOutlet FFTextField *tfPassword;
    IBOutlet FFTextField *tfMobile;
    IBOutlet FFTextField *tfBirthdate;
    
    IBOutlet UIImageView *imgViewProPic;
    
    IBOutlet UIActivityIndicatorView *indicator;
    
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSignup;
    IBOutlet UIButton *btnForgotPass;
    
    IBOutlet UILabel *lblFooterView;
    UITextField *activeTextField;
    
    IBOutlet UIView *viewAllowAPNSAccess;
    IBOutlet UIButton *btnAllowAPNSAccess;
    IBOutlet UIButton *btnAPNSSkip;
    
    BOOL keyboardShown;
    BOOL isImageSet;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) APIConnection *conObj;

@end
