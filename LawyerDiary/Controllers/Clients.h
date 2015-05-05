//
//  Clients.h
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFTextField;

@interface Clients : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    //UITableView Cell
    IBOutlet UITableViewCell *cellClientName;
    IBOutlet UITableViewCell *cellOppositionName;
    IBOutlet UITableViewCell *cellOppositionLawyerName;
    IBOutlet UITableViewCell *cellMobile;
    IBOutlet UITableViewCell *cellEmail;
    IBOutlet UITableViewCell *cellCaseNo;
    IBOutlet UITableViewCell *cellAddress;
    IBOutlet UITableViewCell *cellCourtName;
    IBOutlet UITableViewCell *cellLastHeardDate;
    IBOutlet UITableViewCell *cellNextHearingDate;
    
    IBOutlet FFTextField *tfClientName;
    IBOutlet FFTextField *tfOppositionName;
    IBOutlet FFTextField *tfOppositionLawyerName;
    IBOutlet FFTextField *tfMobile;
    IBOutlet FFTextField *tfEmail;
    IBOutlet FFTextField *tfCaseNo;
    IBOutlet FFTextField *tfCourtName;
    IBOutlet FFTextField *tfLastHeardDate;
    IBOutlet FFTextField *tfNextHearingDate;
    
    IBOutlet UITextView *tvAddress;

    //DatePicker
    IBOutlet UIButton *btnDone;
    IBOutlet UIDatePicker *pickerBirthdate;
    
    IBOutlet UIToolbar *toolbar;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
