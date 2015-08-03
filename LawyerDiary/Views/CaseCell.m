//
//  CaseCell.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 22/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "CaseCell.h"
#import "Client.h"

@implementation CaseCell

- (void)awakeFromNib {
    // Initialization code
    [Global applyCornerRadiusToViews:@[_imgViewProfile] withRadius:ViewHeight(_imgViewProfile)/2 borderColor:WHITE_COLOR andBorderWidth:1];
}

- (void)configureCellWithCaseObj:(Cases *)obj forIndexPath:(NSIndexPath *)indexPath
{
    _caseObj = obj;
    _indexPath = indexPath;
    
    [_lblClientName setText:[NSString stringWithFormat:@"%@ V/S %@", _caseObj.clientFirstName, _caseObj.oppositionFirstName]];
//    [_lblOppositionName setText:_caseObj.oppositionFirstName];
    
    Client *objClient = [Client fetchClient:_caseObj.clientId];
    
    if ([objClient.isTaskPlanner isEqualToNumber:@1]) {
        [_imgViewProfile setImageWithURL:[NSURL URLWithString:GetProPicURLForUser(objClient.clientId)] placeholderImage:image_placeholder_80];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
