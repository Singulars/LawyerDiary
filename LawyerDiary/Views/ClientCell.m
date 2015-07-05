//
//  ClientCell.m
//  
//
//  Created by Verma Mukesh on 10/06/15.
//
//

#import "ClientCell.h"
#import "Client.h"

@implementation ClientCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCellWithClientObj:(Client *)obj forIndexPath:(NSIndexPath *)indexPath
{
    _clientObj = obj;
    _indexPath = indexPath;
    
    [_lblClientName setText:[NSString stringWithFormat:@"%@ %@", _clientObj.clientFirstName, _clientObj.clientLastName]];
    [_lblMobile setText:_clientObj.mobile];
    
    [Global applyCornerRadiusToViews:@[_imgViewProfile] withRadius:ViewHeight(_imgViewProfile)/2 borderColor:WHITE_COLOR andBorderWidth:1];
    
    if ([_clientObj.isTaskPlanner isEqualToNumber:@1]) {
        [_imgViewProfile setImageWithURL:[NSURL URLWithString:GetProPicURLForUser(_clientObj.clientId)] placeholderImage:image_placeholder_80];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
