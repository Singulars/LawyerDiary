//
//  Subordinates.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 05/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Subordinates : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *lblErrorMsg;
    
    UIBarButtonItem *barBtnAdd;
    UIBarButtonItem *barBtnReload;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
