//
//  CaseCourtCell.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 23/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Court;

@interface CaseCourtCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblCourtName;
@property (nonatomic, strong) IBOutlet UILabel *lblCourtCity;
@property (nonatomic, strong) IBOutlet UILabel *lblCourtMegistrate;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewCheckmark;

@property (nonatomic, strong) NSNumber *selectedCourtId;

@property (nonatomic, strong) Court *courtObj;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configureCellWithCourtObj:(Court *)obj forIndexPath:(NSIndexPath *)indexPath;

@end
