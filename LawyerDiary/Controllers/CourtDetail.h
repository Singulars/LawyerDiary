//
//  CourtDetail.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 03/05/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubordinateAdmin.h"

@interface CourtDetail : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableViewCell *cellCourt;
    IBOutlet UITableViewCell *cellMegistrate;
    IBOutlet UITableViewCell *cellCity;
    IBOutlet UITableViewCell *cellBtn;
    
    IBOutlet FFTextField *tfCourt;
    IBOutlet FFTextField *tfMegistrate;
    IBOutlet FFTextField *tfCity;
    IBOutlet UIButton *btnSave;
    
    IBOutlet UIActivityIndicatorView *indicator;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Court *courtObj;

@property (nonatomic, readwrite) BOOL isForSubordinate;
@property (nonatomic, strong) SubordinateAdmin *existingAdminObj;

@end
