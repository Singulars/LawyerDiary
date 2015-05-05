//
//  lazyImageView.m
//
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import "LazyImageView.h"

@implementation LazyImageView

@synthesize imageData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Initially set Placeholder Image
//        [self setImage:[UIImage imageNamed:IMG_placeholder]];
        [self setContentMode:UIViewContentModeScaleAspectFit];
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setHidesWhenStopped:YES];
        [indicator setCenter:self.center];
        [self addSubview:indicator];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        // Initially set Placeholder Image
//        [self setImage:[UIImage imageNamed:IMG_placeholder]];
        [self setContentMode:UIViewContentModeScaleAspectFit];
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setHidesWhenStopped:YES];
        [indicator setCenter:self.center];
        [self addSubview:indicator];
    }
    return self;
}

- (void)setDefaultImage
{
    [self.connection cancel];
    [self setImage:[UIImage imageNamed:IMG_placeholder]];
}

- (void)setImageWithURL:(NSString *)urlString withName:(NSString *)fileName andSize:(CGSize)size withPlaceholderImageName:(NSString *)placeholder
{
    if ([fileName isEqualToString:@""]) {
        
        UIImage *placeHolderImg = IMAGE_WITH_NAME(IMG_user_avatar_80);
        
        UIImage *resizedImage = [Global resizeImage:placeHolderImg withWidth:size.width withHeight:size.height];
        
        [self setImage:resizedImage];
    }
    else {
        self.fileName = [fileName stringByDeletingPathExtension];
        imgSize = size;
        
        NSString *originaljpegFileName = [IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [self.fileName lastPathComponent]]];
        NSString *originalpngFileName = [IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.fileName lastPathComponent]]];
        
        NSString *requiredjpegFileName = [IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%.0f.jpg", [self.fileName lastPathComponent], size.width]];
        NSString *requiredpngFileName = [IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%.0f.png", [self.fileName lastPathComponent], size.width]];
        
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:IMG_DIR_PATH])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:IMG_DIR_PATH withIntermediateDirectories:NO attributes:nil error:&error];
            [Global addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:IMG_DIR_PATH] skip:YES];
        }
        
        if([[NSFileManager defaultManager] fileExistsAtPath:originaljpegFileName]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:requiredjpegFileName]) {
                [self setImage:[UIImage imageWithContentsOfFile:requiredjpegFileName]];
            }
            else {
                UIImage *image = [UIImage imageWithContentsOfFile:originaljpegFileName];
                CGRect imgRect = CGRectMake(0, 0, image.size.width*2, image.size.width*2);
                UIImage *croppedImage = [Global cropImage:image WithSize:imgRect];
                UIImage *resizedImage = [Global resizeImage:croppedImage withWidth:imgSize.width*2 withHeight:imgSize.width*2];
                
                [UIImageJPEGRepresentation(resizedImage, 1.0f) writeToFile:[IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%0.f.jpg", [self.fileName lastPathComponent], imgSize.width]] atomically:YES];
                
                [self setImage:resizedImage];
            }
            
            if (ShareObj.shouldDownloadImages) {
                NSURL *url = [NSURL URLWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
                
                self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
                [self.connection start];
            }
        }
        else if ([[NSFileManager defaultManager] fileExistsAtPath:originalpngFileName]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:requiredpngFileName]) {
                [self setImage:[UIImage imageWithContentsOfFile:requiredpngFileName]];
            }
            else {
                UIImage *image = [UIImage imageWithContentsOfFile:originalpngFileName];
                CGRect imgRect = CGRectMake(0, 0, image.size.width*2, image.size.width*2);
                UIImage *croppedImage = [Global cropImage:image WithSize:imgRect];
                UIImage *resizedImage = [Global resizeImage:croppedImage withWidth:imgSize.width*2 withHeight:imgSize.width*2];
                
                [UIImagePNGRepresentation(resizedImage) writeToFile:[IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_.png", [self.fileName lastPathComponent]]] atomically:YES];
                
                [self setImage:resizedImage];
            }
            
            if (ShareObj.shouldDownloadImages) {
                NSURL *url = [NSURL URLWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
                
                self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
                [self.connection start];
            }
        }
        else {
            [self setImage:[UIImage imageNamed:placeholder]];
            NSURL *url = [NSURL URLWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
            
            self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [self.connection start];
            //        [indicator startAnimating];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"%@",[error debugDescription]);
    [indicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.imageData = [[NSMutableData alloc] initWithCapacity:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [indicator stopAnimating];
    
//        NSLog(@"imageType => %@", [Global convertToString:[Global contentTypeForImageData:self.imageData]]);
    
    if([self.imageData length] > 0)
    {
        imageType = [Global contentTypeForImageData:self.imageData];
        NSString *fileName;
        switch (imageType) {
            case JPG:
                fileName = [self.fileName stringByAppendingString:[NSString stringWithFormat:@"_%.0f.jpg", imgSize.width]];
                break;
            case PNG:
                fileName = [self.fileName stringByAppendingString:[NSString stringWithFormat:@"_%.0f.png", imgSize.width]];
                break;
            default:
                break;
        }
//        NSString *fileExistPath = [IMG_DIR_PATH stringByAppendingPathComponent:fileName];
        
        // Set New Image
        UIImage *image = [UIImage imageWithData:self.imageData];
        
        NSError *error;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:IMG_DIR_PATH])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:IMG_DIR_PATH withIntermediateDirectories:NO attributes:nil error:&error];
            [Global addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:IMG_DIR_PATH] skip:YES];
        }
        
        CGRect imgRect = CGRectMake(0, 0, image.size.width*2, image.size.width*2);
        
        UIImage *croppedImage = [Global cropImage:image WithSize:imgRect];
        
        UIImage *resizedImage = [Global resizeImage:croppedImage withWidth:imgSize.width*2 withHeight:imgSize.height*2];
        
        
        switch (imageType) {
            case JPG: {
                [UIImageJPEGRepresentation(resizedImage, 1.0f) writeToFile:[IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%0.f.jpg", [self.fileName lastPathComponent], imgSize.width]] atomically:YES];
                
                [UIImageJPEGRepresentation(image, 1.0f) writeToFile:[IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [self.fileName lastPathComponent]]] atomically:YES];
            }
                break;
            case PNG: {
                [UIImagePNGRepresentation(resizedImage) writeToFile:[IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%0.f.png", [self.fileName lastPathComponent], imgSize.width]] atomically:YES];
                
                [UIImagePNGRepresentation(image) writeToFile:[IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.fileName lastPathComponent]]] atomically:YES];
            }
                break;
            default:
                NSLog(@"Invalid file to save!");
                break;
        }
        
        [self setImage:resizedImage];
    }
}

@end
