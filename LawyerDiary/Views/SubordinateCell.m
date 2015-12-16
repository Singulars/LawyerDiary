//
//  SubordinateCell.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 04/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "SubordinateCell.h"

@implementation SubordinateCell

- (void)awakeFromNib {
    // Initialization code
    [Global applyCornerRadiusToViews:@[_imgViewProfile] withRadius:ViewHeight(_imgViewProfile)/2 borderColor:CLEARCOLOUR andBorderWidth:1];
}

- (void)configureCellWithSubordinateObj:(Subordinate *)obj forIndexPath:(NSIndexPath *)indexPath
{
    _subordinateObj = obj;
    _indexPath = indexPath;
    
    [_lblSubordinateName setText:[NSString stringWithFormat:@"%@ %@", _subordinateObj.firstName, _subordinateObj.lastName]];
    [_lblMobile setText:_subordinateObj.mobile];
    
    if ([_subordinateObj.isProfile isEqualToNumber:@1]) {
        [_imgViewProfile setImageWithURL:[NSURL URLWithString:GetProPicURLForUser(_subordinateObj.userId)] placeholderImage:image_placeholder_80];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
