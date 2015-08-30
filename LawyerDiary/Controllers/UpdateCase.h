//
//  UpdateCase.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 21/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFTextField.h"
#import "Cases.h"
#import "Court.h"
#import "Client.h"
#import "SubordinateAdmin.h"

@protocol UpdateCaseDelegate <NSObject>

- (void)caseSaved;

@end

@interface UpdateCase : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableViewCell *cellLastCaseStatus;
    IBOutlet UITableViewCell *cellPHeardDate;
    IBOutlet UITableViewCell *cellNHearingDate;
    IBOutlet UITableViewCell *cellCaseStatus;
    IBOutlet UITableViewCell *cellReminderDate;
    
    IBOutlet UITableViewCell *cellCaseDatePicker;
    
    IBOutlet UITableViewCell *cellCourtDetail;
    
    IBOutlet FFTextField *tfLastCaseStatus;
    IBOutlet FFTextField *tfPHeardDate;
    IBOutlet FFTextField *tfNHearingDate;
    IBOutlet FFTextField *tfCaseStatus;
    
    IBOutlet UILabel *lblCourtName;
    IBOutlet UILabel *lblMegistrateName;
    IBOutlet UILabel *lblCourtCity;
    IBOutlet UILabel *lblReminderDate;
    
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIDatePicker *reminderDatePicker;
    
    IBOutlet UIBarButtonItem *barBtnSave;
}

@property (nonatomic, strong) id <UpdateCaseDelegate> delegate;

@property (nonatomic, strong) Cases *existingCaseObj;
@property (nonatomic, strong) Court *existingCourtObj;
@property (nonatomic, strong) Client *existingClientObj;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

//@property (nonatomic, readwrite) BOOL isForSubordinate;
@property (nonatomic, strong) SubordinateAdmin *existingAdminObj;

@end
