//
//  ClientDetail.h
//  
//
//  Created by Verma Mukesh on 10/06/15.
//
//

#import <UIKit/UIKit.h>
@class Client;
@class FFTextField;

@interface ClientDetail : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    //UITableView Cell
    IBOutlet UITableViewCell *cellFirstName;
    IBOutlet UITableViewCell *cellLatsName;
    IBOutlet UITableViewCell *cellMobile;
    IBOutlet UITableViewCell *cellEmail;
    IBOutlet UITableViewCell *cellAddress;
    IBOutlet UITableViewCell *cellBtn;
    
    IBOutlet FFTextField *tfFirstName;
    IBOutlet FFTextField *tfLastName;
    IBOutlet FFTextField *tfMobile;
    IBOutlet FFTextField *tfEmail;
    
    IBOutlet UIPlaceHolderTextView *tvAddress;
    
    IBOutlet UIBarButtonItem *barBtnDone;
    IBOutlet UIToolbar *toolbar;
    
    IBOutlet UIButton *btnSave;
    
    IBOutlet UIActivityIndicatorView *indicator;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Client *clientObj;

@end
