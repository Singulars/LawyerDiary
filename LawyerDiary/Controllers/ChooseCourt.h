//
//  ChooseCourt.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 23/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"
#import "Court.h"

@interface ChooseCourt : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *lblErrorMsg;
}

@property (nonatomic, strong) Client *existingClientObj;
@property (nonatomic, strong) Court *existingCourtObj;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
