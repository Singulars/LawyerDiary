//
//  lazyImageView.h
//  
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
@interface LazyImageView : UIImageView
{
    NSMutableData *imageData;
    UIActivityIndicatorView *indicator;
    
    CGSize imgSize;
    ImageType imageType;
}

@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) NSString *fileName;

@property (nonatomic, strong) NSURLConnection *connection;

- (void)setDefaultImage;
- (void)setImageWithURL:(NSString *)urlString withName:(NSString *)fileName andSize:(CGSize)size withPlaceholderImageName:(NSString *)placeholder;

@end
