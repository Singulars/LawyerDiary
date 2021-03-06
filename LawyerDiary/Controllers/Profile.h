//
//  Profile.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 07/05/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFTextField.h"
#import "UIPlaceHolderTextView.h"

@interface Profile : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UITableViewCell *cellFirst;
    IBOutlet UITableViewCell *cellEmail;
    IBOutlet UITableViewCell *cellMobile;
    IBOutlet UITableViewCell *cellBirthdate;
    IBOutlet UITableViewCell *cellChangePass;
    IBOutlet UITableViewCell *cellCurrentPass;
    IBOutlet UITableViewCell *cellNewPass;
    IBOutlet UITableViewCell *cellRegNo;
    IBOutlet UITableViewCell *cellAdress;
    IBOutlet UITableViewCell *cellPicker;
    
    IBOutlet UIImageView *imgViewProPic;
    
    IBOutlet FFTextField *tfFirstName;
    IBOutlet FFTextField *tfLastName;
    IBOutlet FFTextField *tfEmail;
    IBOutlet FFTextField *tfMobile;
    IBOutlet FFTextField *tfBirthdate;
    IBOutlet FFTextField *tfRegNo;
    IBOutlet FFTextField *tfCurrentPass;
    IBOutlet FFTextField *tfNewPass;
    IBOutlet UILabel *lblChnagePass;
    IBOutlet UIPlaceHolderTextView *tvAddress;
    IBOutlet UIImageView *imgViewRowDisclosure;
    
    IBOutlet UIButton *btnDone;
    IBOutlet UIDatePicker *pickerBirthdate;
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *barBtnSave;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
