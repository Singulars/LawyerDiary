//
//  CourtCell.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 02/05/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class Court;

@interface CourtCell : SWTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblCourtName;
@property (nonatomic, strong) IBOutlet UILabel *lblCourtCity;
@property (nonatomic, strong) IBOutlet UILabel *lblCourtMegistrate;

@property (nonatomic, strong) Court *courtObj;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configureCellWithCourtObj:(Court *)obj forIndexPath:(NSIndexPath *)indexPath;

@end
