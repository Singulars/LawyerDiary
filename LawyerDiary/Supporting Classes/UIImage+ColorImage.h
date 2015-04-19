//
//  UIImage+ColorImage.h
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorImage)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)fixOrientation;
- (UIImage *)squareImageAndscaledToSize:(CGSize)newSize;
@end
