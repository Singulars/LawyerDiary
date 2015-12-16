//
//  CaseClientCell.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 22/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "CaseClientCell.h"
#import "Client.h"

@implementation CaseClientCell

- (void)awakeFromNib {
    // Initialization code
    [Global applyCornerRadiusToViews:@[_imgViewProfile] withRadius:ViewHeight(_imgViewProfile)/2 borderColor:WHITE_COLOR andBorderWidth:1];
    [_imgViewCheckmark setTintColor:BLACK_COLOR];
    [_imgViewCheckmark setImage:IMAGE_WITH_NAME_AND_RENDER_MODE(@"icon-checkmark", kImageRenderModeTemplate)];
}

- (void)configureCellWithClientObj:(Client *)obj forIndexPath:(NSIndexPath *)indexPath
{
    _clientObj = obj;
    _indexPath = indexPath;
    
    [_lblClientName setText:[NSString stringWithFormat:@"%@ %@", _clientObj.clientFirstName, _clientObj.clientLastName]];
    
    if ([_clientObj.isTaskPlanner isEqualToNumber:@1]) {
        [_imgViewProfile setImageWithURL:[NSURL URLWithString:GetProPicURLForUser(_clientObj.clientId)] placeholderImage:image_placeholder_80];
    }

    [_imgViewCheckmark setHidden:![_selectedClientId isEqualToNumber:_clientObj.clientId]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
