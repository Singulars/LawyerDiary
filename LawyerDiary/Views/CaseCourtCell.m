//
//  CaseCourtCell.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 23/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "CaseCourtCell.h"
#import "Court.h"

@implementation CaseCourtCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCellWithCourtObj:(Court *)obj forIndexPath:(NSIndexPath *)indexPath
{
    _courtObj = obj;
    _indexPath = indexPath;
    
    [_lblCourtName setText:_courtObj.courtName];
    [_lblCourtCity setText:_courtObj.courtCity];
    [_lblCourtMegistrate setText:_courtObj.megistrateName];
    
    [_imgViewCheckmark setHidden:![_selectedCourtId isEqualToNumber:_courtObj.courtId]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
