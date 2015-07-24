//
//  CaseClientCell.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 22/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Client;

@interface CaseClientCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblClientName;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewCheckmark;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfile;

@property (nonatomic, strong) NSNumber *selectedClientId;

@property (nonatomic, strong) Client *clientObj;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configureCellWithClientObj:(Client *)obj forIndexPath:(NSIndexPath *)indexPath;

@end
