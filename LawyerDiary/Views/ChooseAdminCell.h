//
//  CourtSubordinateCell.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 09/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubordinateAdmin;
@interface ChooseAdminCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblClientName;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewCheckmark;

@property (nonatomic, strong) NSNumber *selectedClientId;

@property (nonatomic, strong) SubordinateAdmin *adminObj;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configureCellWithAdminObj:(SubordinateAdmin *)obj forIndexPath:(NSIndexPath *)indexPath;
@end
