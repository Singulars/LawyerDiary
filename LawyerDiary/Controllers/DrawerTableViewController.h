//
//  DrawerTableViewController.h
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerTableViewController : UITableViewController
{
    IBOutlet UIView *tableHeaderView;
    IBOutlet UIImageView *imgViewHeader;
    
    IBOutlet UITableViewCell *cellProfile;
    IBOutlet UIImageView *imgViewProPic;
    IBOutlet UILabel *lblUsername;
}
@end
