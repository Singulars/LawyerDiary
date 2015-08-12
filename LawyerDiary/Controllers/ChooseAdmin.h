//
//  ChooseSubordinates.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 09/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseAdminDelegate <NSObject>
@optional
- (void)subordinateSelected:(SubordinateAdmin *)subordinateObj;

@end

@interface ChooseAdmin : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *lblErrorMsg;
}
@property (nonatomic, strong) id<ChooseAdminDelegate> delegate;

@property (nonatomic, strong) SubordinateAdmin *existingAdminObj;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
