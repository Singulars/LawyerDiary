//
//  Register.h
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/19/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFTextField.h"

typedef NS_ENUM(NSUInteger, VIEW_TYPE) {
    LOGIN_VIEW = 0,
    SIGN_UP_VIEW,
    FORGOT_PASS_VIEW
};

@interface Register : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UINavigationBar *navBar;
    IBOutlet UINavigationItem *navItem;
    IBOutlet UIBarButtonItem *barBtnClose;
    
    IBOutlet UIImageView *imgViewBackground;
    IBOutlet UIImageView *imgViewVisualEffect;
    
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
    
    BOOL keyboardShown;
    BOOL isImageSet;
}
@property (nonatomic, strong) UIImage *imageFromPreviousScreen;
@property (nonatomic, assign) VIEW_TYPE viewType;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
