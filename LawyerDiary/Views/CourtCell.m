//
//  CourtCell.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 02/05/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "CourtCell.h"

@implementation CourtCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
