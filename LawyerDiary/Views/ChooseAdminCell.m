//
//  CourtSubordinateCell.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 09/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "ChooseAdminCell.h"

@implementation ChooseAdminCell

- (void)awakeFromNib {
    // Initialization code
    [_imgViewCheckmark setTintColor:BLACK_COLOR];
    [_imgViewCheckmark setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"icon-checkmark", kImageRenderModeTemplate)];
}
- (void)configureCellWithAdminObj:(SubordinateAdmin *)obj forIndexPath:(NSIndexPath *)indexPath
{
    _adminObj = obj;
    _indexPath = indexPath;
    
    [_lblClientName setText:[NSString stringWithFormat:@"%@", _adminObj.adminName]];
    
    if ([_adminObj.hasAccess isEqualToNumber:@0])
    {
        [_lblClientName setTextColor:[UIColor lightGrayColor]];
    }
    [_imgViewCheckmark setHidden:![_selectedClientId isEqualToNumber:_adminObj.adminId]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
