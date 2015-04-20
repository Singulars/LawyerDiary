//
//  FFTextField.m
//  LetMeRemind
//
//  Created by Naresh Kharecha on 7/10/14.
//  Copyright (c) 2014 Founders Found. All rights reserved.
//

#import "FFTextField.h"

@implementation FFTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
    return inset;
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
    return inset;
}

//- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
//    CGRect inset = CGRectMake(bounds.origin.x + 140, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
//    return inset;
//}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
    return inset;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
