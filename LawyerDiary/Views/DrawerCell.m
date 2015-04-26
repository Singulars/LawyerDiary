//
//  DrawerCell.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/26/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "DrawerCell.h"

@interface DrawerCell ()
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DrawerCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self highlightCell:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self highlightCell:highlighted];
}

- (void)highlightCell:(BOOL)highlight {
    UIColor *tintColor = APP_TINT_COLOR;
    if(highlight) {
//        tintColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }
    
    self.titleLabel.textColor = tintColor;
    self.iconImageView.tintColor = tintColor;
}

#pragma mark - Accessors

#pragma Title

- (NSString *)titleText {
    return self.titleLabel.text;
}

- (void)setTitleText:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma Icon

- (UIImage *)iconImage {
    return self.iconImageView.image;
}

- (void)setIconImage:(UIImage *)icon {
    self.iconImageView.image = icon;//[icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
