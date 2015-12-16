//
//  ChooseSubordinates.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 09/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

extern SubordinateAdmin *selectedAdminObj;

typedef NS_ENUM(NSUInteger, DetailViewToChooseAdmin) {
    kDetailViewCases = 0,
    kDetailViewClients,
    kDetailViewCourts
};

@protocol ChooseAdminDelegate <NSObject>
@optional
- (void)subordinateSelected:(SubordinateAdmin *)subordinateObj;

@end

@interface ChooseAdmin : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *lblErrorMsg;
    IBOutlet UILabel *headerLable;
}
@property (nonatomic, strong) id<ChooseAdminDelegate> delegate;

@property (nonatomic, readwrite) DetailViewToChooseAdmin detailViewToChooseAdmin;

@property (nonatomic, strong) SubordinateAdmin *existingAdminObj;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
