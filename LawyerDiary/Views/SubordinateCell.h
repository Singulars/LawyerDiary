//
//  SubordinateCell.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 04/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subordinate.h"

@interface SubordinateCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblSubordinateName;
@property (nonatomic, strong) IBOutlet UILabel *lblMobile;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfile;

@property (nonatomic, strong) Subordinate *subordinateObj;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configureCellWithSubordinateObj:(Subordinate *)obj forIndexPath:(NSIndexPath *)indexPath;

@end
