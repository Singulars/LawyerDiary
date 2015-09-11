//
//  Courts.h
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

extern BOOL isForSubordinate;

@interface Courts : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *lblErrorMsg;
    IBOutlet UIBarButtonItem *barBtnAdd;
    
    IBOutlet UIView *viewAddCourt;
    IBOutlet UIButton *btnAddCourt;
    
    IBOutlet UIButton *btnReload;
    
    UIBarButtonItem *barBtnReload;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
