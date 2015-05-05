//
//  ViewController.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 06/05/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
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
    
    IBOutlet LazyImageView *imgViewProPic;
    IBOutlet FFTextField *tfFirstName;
    IBOutlet FFTextField *tfLastName;
    IBOutlet FFTextField *tfEmail;
    IBOutlet FFTextField *tfMobile;
    IBOutlet FFTextField *tfBirthdate;
    IBOutlet FFTextField *tfRegNo;
    IBOutlet FFTextField *tfCurrentPass;
    IBOutlet FFTextField *tfNewPass;
    IBOutlet UILabel *lblChnagePass;
    IBOutlet UITextView *tvAddress;
    IBOutlet UIImageView *imgViewRowDisclosure;
    
    IBOutlet UIButton *btnDone;
    IBOutlet UIDatePicker *pickerBirthdate;
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *barBtnSave;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, readwrite) BOOL loadView;

@end
