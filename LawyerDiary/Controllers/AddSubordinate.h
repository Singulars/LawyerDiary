//
//  AddSubordinate.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 05/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFTextField.h"

@interface AddSubordinate : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITableViewCell *cellFirstName;
    IBOutlet UITableViewCell *cellLastName;
    IBOutlet UITableViewCell *cellMobile;
    IBOutlet UITableViewCell *cellAccess;
    IBOutlet UITableViewCell *cellBtn;
    IBOutlet UITableViewCell *cellMsg;
    
    IBOutlet FFTextField *tfFirstName;
    IBOutlet FFTextField *tfLastName;
    IBOutlet FFTextField *tfMobile;
    
    IBOutlet UISwitch *switchAccess;
    
    IBOutlet UIButton *btnSave;
    
    IBOutlet UIActivityIndicatorView *indicator;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
