//
//  ClientDetail.h
//  
//
//  Created by Verma Mukesh on 10/06/15.
//
//

#import <UIKit/UIKit.h>
@class FFTextField;

@interface ClientDetail : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    //UITableView Cell
    IBOutlet UITableViewCell *cellFirstName;
    IBOutlet UITableViewCell *cellLatsName;
    IBOutlet UITableViewCell *cellMobile;
    IBOutlet UITableViewCell *cellEmail;
    IBOutlet UITableViewCell *cellAddress;
    
    IBOutlet FFTextField *tfFirstName;
    IBOutlet FFTextField *tfLastName;
    IBOutlet FFTextField *tfMobile;
    IBOutlet FFTextField *tfEmail;
    
    IBOutlet UITextView *tvAddress;
    
    IBOutlet UIBarButtonItem *barBtnDone;
    IBOutlet UIToolbar *toolbar;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
