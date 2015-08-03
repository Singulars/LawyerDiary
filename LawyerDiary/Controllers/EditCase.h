//
//  EditCase.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 24/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFTextField.h"
#import "Cases.h"
#import "Court.h"
#import "Client.h"

@protocol EditCaseDelegate <NSObject>

- (void)caseSaved;

@end

@interface EditCase : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableViewCell *cellCaseNo;
    IBOutlet UITableViewCell *cellNHearingDate;
    IBOutlet UITableViewCell *cellPHeardDate;
    IBOutlet UITableViewCell *cellCaseStatus;
    
    IBOutlet UITableViewCell *cellCaseDatePicker;
    
    IBOutlet UITableViewCell *cellCourtDetail;
    
    IBOutlet UITableViewCell *cellClientDetail;
    
    IBOutlet UITableViewCell *cellOFirstName;
    IBOutlet UITableViewCell *cellOLastName;
    IBOutlet UITableViewCell *cellOLawyerName;
    
    IBOutlet FFTextField *tfCaseNo;
    IBOutlet FFTextField *tfNHearingDate;
    IBOutlet FFTextField *tfPHeardDate;
    IBOutlet FFTextField *tfCaseStatus;
    
    IBOutlet UILabel *lblCourtName;
    IBOutlet UILabel *lblMegistrateName;
    IBOutlet UILabel *lblCourtCity;
    
    IBOutlet UILabel *lblClientName;
    IBOutlet UILabel *lblClientMobile;
    
    IBOutlet FFTextField *tfOFirstName;
    IBOutlet FFTextField *tfOLastName;
    IBOutlet FFTextField *tfOLawyerName;
    
    IBOutlet UIDatePicker *datePicker;
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *barBtnNext;
    IBOutlet UIBarButtonItem *barBtnPrev;
    
    IBOutlet UIBarButtonItem *barBtnSave;
}

@property (nonatomic, strong) id <EditCaseDelegate> delegate;

@property (nonatomic, strong) Cases *existingCaseObj;
@property (nonatomic, strong) Court *existingCourtObj;
@property (nonatomic, strong) Client *existingClientObj;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
