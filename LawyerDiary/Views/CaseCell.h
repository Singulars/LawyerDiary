//
//  CaseCell.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 22/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cases;

@interface CaseCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblClientName;
@property (nonatomic, strong) IBOutlet UILabel *lblOppositionName;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfile;

@property (nonatomic, strong) Cases *caseObj;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configureCellWithCaseObj:(Cases *)obj forIndexPath:(NSIndexPath *)indexPath;

@end
