//
//  Global.m
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import "global.h"

#define ImageWidth 320
#define ImageHeight 320

@implementation Global

#pragma mark - Fade In/Out View
+ (void)fadeInView:(UIView *)view {
    [[view superview] bringSubviewToFront:view];
    view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    view.alpha = 0;
    [view setUserInteractionEnabled:YES];
    [UIView animateWithDuration:.35 animations:^{
        view.alpha = 1;
        view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

+ (void)fadeOutView:(UIView *)view {
    [UIView animateWithDuration:.35 animations:^{
        view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        view.alpha = 0.0;
        [view setUserInteractionEnabled:NO];
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

#pragma mark - Show Alert
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andCancelText:(NSString *)cancel andOther:(NSString *)other andDelegate:(id)delegate withTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:other, nil];
    [alert setTag:tag];
    [alert setDelegate:delegate];
    [alert show];
}

+ (UIImage *)imageWithName:(NSString *)imageName andType:(NSString *)type
{
    NSString *newImageName;
    if (IS_IPAD) {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            // Retina display
            newImageName = [NSString stringWithFormat:@"%@_iPad@2x",imageName];
        } else {
            // non-Retina display
            newImageName = [NSString stringWithFormat:@"%@_iPad",imageName];
        }
    }
    else
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            // Retina display
            newImageName = [NSString stringWithFormat:@"%@@2x",imageName];
        } else {
            // non-Retina display
            newImageName = [NSString stringWithFormat:@"%@",imageName];
        }
    }
    //    NSLog(@"%@",newImageName);
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:newImageName ofType:type]];
}

#pragma mark - Custom Font
+ (UIFont *)fontWithName:(NSString *)fontName andSize:(NSInteger)size
{
    return [UIFont fontWithName:fontName size:size];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    //Create a context of the appropriate size
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    //Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    //Snap the picture and close the context
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retval;
}

#pragma mark - Add Skip From Backup Attribute to File
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL skip:(BOOL)skip
{
    // Check Terminal command :::  for file in $(find *); do du -sk $file; xattr -l $file; echo ; done
    
    //    NSAssert(IsAtLeastiOSVersion(@"5.1"), @"Cannot mark files for NSURLIsExcludedFromBackupKey on iOS less than 5.1");
    
    NSError* error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:skip] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark - Delete All the Images
+ (void)deleteImages
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:IMG_DIR_PATH error:&error]) {
        BOOL success = [fm removeItemAtPath:[IMG_DIR_PATH stringByAppendingPathComponent:file] error:&error];
        if (!success || error)
            NSLog(@"Failed to Delete : %@",[error debugDescription]);
    }
}

#pragma mark - Internet Alert
+ (void)showInternetAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Internet Not Connected." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

+ (NSArray *)loadAllDownloadePDFFiles
{
    NSError *err = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:IMG_DIR_PATH error:&err];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.pdf'"];
    
    return [dirContents filteredArrayUsingPredicate:fltr];
}

+ (BOOL)isFileAvailable:(NSString *)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",IMG_DIR_PATH,fileName]];
}

#pragma mark- Validte textfield

+ (BOOL)validateTextField:(UITextField *)txtField
{
    if(txtField == nil) return YES;
    
    if([txtField.text length]<=0) return YES;
    
    return NO;
}
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void)applyLetterpressStyleTextEffectToLabels:(NSArray *)labelArr
{
    //    UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    //    UIColor* textColor = [UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:1.0f];
    //    UIColor* textColor = [UIColor colorWithRed:154.0f/255.0 green:24.0f/255.0 blue:27.0f/255.0 alpha:1.0f];
    
    NSDictionary *attrs = @{ //NSForegroundColorAttributeName : textColor,
                            //                             NSFontAttributeName : font,
                            NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
    
    for (UILabel *label in labelArr) {
        
        NSAttributedString* attrString = [[NSAttributedString alloc]
                                          initWithString:label.text
                                          attributes:attrs];
        label.attributedText = attrString;
    }
}

+ (void)applyUIViewCornerRadiusToView:(NSArray *)views withRadius:(CGFloat)radius andColor:(UIColor *)color andBorderWidth:(CGFloat)width
{
    for (UIView *view in views) {
        [view.layer setCornerRadius:radius];
        view.layer.masksToBounds=YES;
        //        [view.layer setBorderColor:[[UIColor colorWithRed:3/255.f green:35/255.f blue:62/255.f alpha:1] CGColor]];
        [view.layer setBorderColor:color.CGColor];
        [view.layer setBorderWidth:width];
    }
}

#pragma mark - Hide NavigationBar BackButton Title
#pragma mark -
+ (UIBarButtonItem *)hideBackBarButtonTitle
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    return barButton;
}


#pragma mark
#pragma mark Save Image to Local

+(void)saveImage:(NSData *)ImageData :(NSString *)strPath Indirectory:(NSString *)directoryName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    
    NSString *Path =[dataPath stringByAppendingPathComponent:strPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:Path contents:ImageData attributes:nil];
}

+(NSString *)getImage:(NSString *)strId fromDirectory:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:directory];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *strPath;
    
    strPath =[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strId]];
    return strPath;
}

+(void)ResizeImage:(UIImage *)image SaveToDirectory:(NSString *)strDirectory FileName:(NSString *)strFileName
{
    UIImageView *imgViewPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    [imgViewPhoto setBackgroundColor:[UIColor clearColor]];
    [imgViewPhoto setImage:image];
    [imgViewPhoto setContentMode:UIViewContentModeScaleToFill];
    
    UIGraphicsBeginImageContextWithOptions(imgViewPhoto.bounds.size, NO, 1.0);
    [imgViewPhoto.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveImage:UIImagePNGRepresentation(croppedImage) :strFileName Indirectory:strDirectory];
}

+(void)ResizeImage:(UIImage *)image SaveToDirectory:(NSString *)strDirectory FileName:(NSString *)strFileName ForFrameSize:(CGRect)rect
{
    UIImageView *imgViewPhoto = [[UIImageView alloc] initWithFrame:rect];
    [imgViewPhoto setBackgroundColor:[UIColor clearColor]];
    [imgViewPhoto setImage:image];
    [imgViewPhoto setContentMode:UIViewContentModeScaleToFill];
    
    UIGraphicsBeginImageContextWithOptions(imgViewPhoto.bounds.size, NO, 1.0);
    [imgViewPhoto.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveImage:UIImagePNGRepresentation(croppedImage) :strFileName Indirectory:strDirectory];
}

+ (UIImage *)resizeImage:(UIImage *)image forFrameSize:(CGRect)rect
{
    UIImageView *imgViewPhoto = [[UIImageView alloc] initWithFrame:rect];
    [imgViewPhoto setBackgroundColor:[UIColor clearColor]];
    [imgViewPhoto setImage:image];
    [imgViewPhoto setContentMode:UIViewContentModeScaleToFill];
    
    UIGraphicsBeginImageContextWithOptions(imgViewPhoto.bounds.size, NO, 1.0);
    [imgViewPhoto.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

+ (UIImage *)resizeImage:(UIImage *)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio) {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)cropImage:(UIImage *)image WithSize:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    
    UIImage *croppedImg = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return croppedImg;
}

+(void)DeleteFile:(NSString *)strFileName FromDirectory:(NSString *)directoryName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:directoryName];
    
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        NSString *fullPath = [dataPath stringByAppendingPathComponent:strFileName];
        BOOL success = [fm removeItemAtPath:fullPath error:&error];
        if (!success || error) {
        }
    }
}

+(void)DeleteImagesFromDirectory:(NSString *)directory
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:directory];
    NSError *error;
    
    for (NSString *file in [fm contentsOfDirectoryAtPath:dataPath error:&error]) {
        NSString *fullPath = [dataPath stringByAppendingPathComponent:file];
        BOOL success = [fm removeItemAtPath:fullPath error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}

+(NSString*)getUniqName{
    
    NSDateFormatter *dateStartFormatter = [[NSDateFormatter alloc] init];
    [dateStartFormatter setDateFormat:@"ddMMyyHHMMSS"];
    return [NSString stringWithFormat:@"%@",[dateStartFormatter stringFromDate:[NSDate date]]];
}

+ (NSString *)getLongStringDateFromString:(NSString *)dateStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterLongStyle];
    NSDate *date = [df dateFromString:dateStr];
    
    NSString *retStr = [df stringFromDate:date];
    
    return retStr;
}

+ (UIActivityIndicatorView *)showActiVityIndicatorView
{
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [actView startAnimating];
    [actView setHidesWhenStopped:YES];
    
    return actView;
}

#pragma mark Show/Hide Network Indicatior

+(void)ShowNetworkIndicator:(BOOL)Istrue
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:Istrue];
}

+ (void)setBorderColorAndWidthToView:(UIView *)view flag:(BOOL)flag
{
    if (flag) {
        [view.layer setBorderWidth:1.0f];
        [view.layer setBorderColor:[UIColor redColor].CGColor];
    }
    else
    {
        [view.layer setBorderWidth:0.0f];
        [view.layer setBorderColor:CLEARCOLOUR.CGColor];
    }
}

+ (NSString *)formatBirthdateToCore:(NSString *)dateStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
    [df setDateFormat:DefaultBirthdateFormat];
    
    NSDate *date = [df dateFromString:dateStr];
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setTimeZone:timeZone];
    [df1 setDateFormat:ServerBirthdateFormat];
    
    NSString *retDate = [df1 stringFromDate:date];
    
    return retDate;
}


+ (NSDate *)getCoreDateFromString:(NSString *)dateStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
    [df setDateFormat:ServerBirthdateFormat];
    
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

+ (NSString *)getFullDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:kServerDateTimeFormat];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSInteger)getUserAgeFromBirthdate:(NSString *)dateStr
{
    NSDateComponents* agecalcul = [[NSCalendar currentCalendar]
                                   components:NSYearCalendarUnit
                                   fromDate:[self getCoreDateFromString:dateStr]
                                   toDate:[NSDate date]
                                   options:0];
    
    NSInteger age = [agecalcul year];
    return age;
}

+ (void)applyAppleBlueBorderAndHighlightImageToButton:(NSArray *)buttons withRadius:(CGFloat)radius andFontSize:(CGFloat)fontSize
{
    for (UIButton *button in buttons) {
        
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
        [button.layer setCornerRadius:radius];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        
        [button setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        [button setTitleColor:WHITE_COLOR forState:UIControlStateHighlighted];
        
        [button.layer setBorderColor:BLUE_COLOR.CGColor];
        
        [button setBackgroundImage:[UIImage imageWithColor:CLEAR_COLOR] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:BLUE_COLOR] forState:UIControlStateHighlighted];
    }
}

+ (void)applyAppleRedBorderAndHighlightImageToButton:(NSArray *)buttons withRadius:(CGFloat)radius andFontSize:(CGFloat)fontSize
{
    for (UIButton *button in buttons) {
        
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
        [button.layer setCornerRadius:radius];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        
        [button setTitleColor:LIGHT_GRAY_COLOR forState:UIControlStateNormal];
        [button setTitleColor:WHITE_COLOR forState:UIControlStateHighlighted];
        [button setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        
        [button.layer setBorderColor:LIGHT_GRAY_COLOR.CGColor];
        
        [button setBackgroundImage:[UIImage imageWithColor:CLEAR_COLOR] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:RED_COLOR] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:RED_COLOR] forState:UIControlStateSelected];
    }
}

+ (void)applyAppleGreenBorderAndHighlightImageToButton:(NSArray *)buttons withRadius:(CGFloat)radius andFontSize:(CGFloat)fontSize
{
    for (UIButton *button in buttons) {
        
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
        [button.layer setCornerRadius:radius];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        
        [button setTitleColor:LIGHT_GRAY_COLOR forState:UIControlStateNormal];
        [button setTitleColor:WHITE_COLOR forState:UIControlStateHighlighted];
        [button setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        
        [button.layer setBorderColor:LIGHT_GRAY_COLOR.CGColor];
        
        [button setBackgroundImage:[UIImage imageWithColor:CLEAR_COLOR] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:GREEN_COLOR] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:GREEN_COLOR] forState:UIControlStateSelected];
    }
}

+ (void)applyAppleBorderAndHighlightImageToButtons:(NSArray *)buttons withRadius:(CGFloat)radius font:(NSString *)fontName fontSize:(CGFloat)fontSize fontNormalColor:(UIColor *)nFcolor fontHighlightedColor:(UIColor *)hFcolor btnNormalColor:(UIColor *)nColor btnHighlightedColor:(UIColor *)hColor andBorderWidth:(CGFloat)borderWidth
{
    for (UIButton *button in buttons) {
        
        button.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
        [button.layer setCornerRadius:radius];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:borderWidth];
        
        [button setTitleColor:nFcolor forState:UIControlStateNormal];
        [button setTitleColor:hFcolor forState:UIControlStateHighlighted];
        [button setTitleColor:hFcolor forState:UIControlStateSelected];
        
        [button.layer setBorderColor:hColor.CGColor];
        
        [button setBackgroundImage:[UIImage imageWithColor:nColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:hColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:hColor] forState:UIControlStateSelected];
    }
}

#pragma mark - Apply Corener Radius To View
+ (void)applyCornerRadiusToViews:(NSArray *)views withRadius:(CGFloat)radius borderColor:(UIColor *)color andBorderWidth:(CGFloat)width {
    
    for (UIView *view in views) {
        [view.layer setCornerRadius:radius];
        [view.layer setBorderColor:color.CGColor];
        [view.layer setBorderWidth:width];
        [view.layer setMasksToBounds:YES];
    }
}

#pragma mark - Apply custom property to UIButton
+ (void)applyPropertiesToButtons:(NSArray *)buttons likeFont:(NSString *)btnFont fontSize:(CGFloat)btnFontSize fontNormalColor:(UIColor *)btnFontNormalColor fontHighlightedColor:(UIColor *)btnFontHighlightedColor borderColor:(UIColor *)btnBorderColor borderWidth:(CGFloat)btnBorderWidth cornerRadius:(CGFloat)btnCorenerRadius normalBackgroundColor:(UIColor *)btnNormalBackgroundColor andHighlightedBackgroundColor:(UIColor *)btnHighlightedBackgroundColor {
    
    for (UIButton *button in buttons) {
        [button.layer setCornerRadius:btnCorenerRadius];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderColor:btnBorderColor.CGColor];
        [button.layer setBorderWidth:btnBorderWidth];
        
        [button.titleLabel setFont:[UIFont fontWithName:btnFont size:btnFontSize]];
        
        [button setTitleColor:btnFontNormalColor forState:UIControlStateNormal];
        [button setTitleColor:btnFontHighlightedColor forState:UIControlStateHighlighted];
        [button setTitleColor:btnFontHighlightedColor forState:UIControlStateSelected];
        
        [button setBackgroundImage:[UIImage imageWithColor:btnNormalBackgroundColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:btnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:btnHighlightedBackgroundColor] forState:UIControlStateSelected];
    }
}

#pragma mark - Set UINavigationBar Background Image With Color
+ (void)setNavigationBarBackGroundImageWithColor:(UIColor *)color ofNaigationBar:(UINavigationBar *)navBar
{
    
    [navBar setBackgroundImage:[UIImage imageWithColor:color] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.translucent = NO;
}

#pragma mark - Set UITabbar Background Image With Color
+ (void)setBackGroundImageToTabBar:(UITabBar *)tabBar withImageColor:(UIColor *)color
{
    UIImage *tabBarImage;
    tabBarImage = [[UIImage imageWithColor:color] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    [tabBar setBackgroundImage:tabBarImage];
    [tabBar setShadowImage:[UIImage new]];
}

#pragma mark - Set LeftView To UITextField
+ (void)setLefViewOfFrame:(CGRect)frame toTextFields:(NSArray *)textFields
{
    for (UITextField *textField in textFields) {
        UIView *leftView = [[UIView alloc] initWithFrame:frame];
        [leftView setBackgroundColor:CLEAR_COLOR];
        
        [textField setLeftView:leftView];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
    }
}

#pragma mark - Set RightView To UITextField
+ (void)setRightViewOfFrame:(CGRect)frame toTextFields:(NSArray *)textFields
{
    for (UITextField *textField in textFields) {
        UIView *rightView = [[UIView alloc] initWithFrame:frame];
        [rightView setBackgroundColor:BLACK_COLOR];
        
        [textField setRightView:rightView];
        [textField setRightViewMode:UITextFieldViewModeAlways];
    }
}

#pragma mark - Set Font To UiviewObject Array
+ (void)setFont:(NSString *)fontName withSize:(CGFloat)size color:(UIColor *)fontColor toUIViewType:(ViewObjectType)objType objectArr:(NSArray *)tfArr
{
    switch (objType) {
        case TextField:
            for (UITextField *tf in tfArr) {
                [tf setFont:FONT_WITH_NAME_SIZE(fontName, size)];
                [tf setTextColor:fontColor];
            }
            break;
        case Label:
            for (UILabel *lbl in tfArr) {
                [lbl setFont:FONT_WITH_NAME_SIZE(fontName, size)];
                [lbl setTextColor:fontColor];
            }
            break;
        case TextView:
            for (UITextView *tv in tfArr) {
                [tv setFont:FONT_WITH_NAME_SIZE(fontName, size)];
                [tv setTextColor:fontColor];
            }
            break;
        default:
            break;
    }
}

+ (NSAttributedString *)getAttributedString:(NSString *)str withFont:(NSString *)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor strokeColor:(UIColor *)strokeColor
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONT_WITH_NAME_SIZE(fontName, fontSize),
                                                                                                       NSForegroundColorAttributeName: fontColor,
                                                                                                       NSStrokeWidthAttributeName: @-4.f,
                                                                                                       NSStrokeColorAttributeName: strokeColor
                                                                                                       }];
    return attributedString;
}

#pragma mark - Encode UIImage to base64 string
+ (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark - Decode base64 string to UIImage
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+ (NSDictionary *)setNavigationBarTitleTextAttributesLikeFont:(NSString *)fontName fontColor:(UIColor *)color andFontSize:(CGFloat)fontSize andStrokeColor:(UIColor *)strokeColor
{
    @try {
        NSShadow *shadow = [NSShadow new];
        [shadow setShadowColor: [UIColor colorWithWhite:0.0f alpha:0.0f]];
        [shadow setShadowOffset: CGSizeMake(0.0f, 0.0f)];
        
        UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] init];
        fontDescriptor = [fontDescriptor fontDescriptorWithFamily:fontName];
        
        NSDictionary *attributeDic = @{
                                       NSForegroundColorAttributeName: color,
                                       NSShadowAttributeName: shadow,
                                       NSFontAttributeName: [UIFont fontWithDescriptor:fontDescriptor size:fontSize],
                                       NSStrokeColorAttributeName: strokeColor,
                                       NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-4.0f]
                                       };
        return attributeDic;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (void)setBackGroundImageToNavigationBar:(UINavigationBar *)navBar withImageColor:(UIColor *)color
{
    UIImage *navBarImage;
    navBarImage = [[UIImage imageWithColor:color] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    
    [navBar setBackgroundImage:navBarImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [navBar setShadowImage:[UIImage new]];
}

#pragma mark - Sync Contacts
#pragma mark -
+ (NSMutableDictionary *)getValueFromPlist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"PInfo.plist"]; //3
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        return [[NSMutableDictionary alloc] init];
    }
    
    return [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

+ (void)setValueToPlist:(NSMutableDictionary *)Info
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"PInfo.plist"]; //3
    
    [Info writeToFile: path atomically:YES];
}

+ (NSMutableArray *)getAllNewContactsFromContactList
{
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block NSMutableArray *arrContacts = [[NSMutableArray alloc] init];
    
    __block BOOL accessGranted = NO;
    
    switch (ABAddressBookGetAuthorizationStatus())
    {
        case  kABAuthorizationStatusAuthorized:
        {
            arrContacts=[self fetchContactsArray:addressBook];
        }
            break;
            
        case  kABAuthorizationStatusNotDetermined :
            
            if (ABAddressBookRequestAccessWithCompletion != NULL) {
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    accessGranted = granted;
                    dispatch_semaphore_signal(sema);
                });
                
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            }
            else {
                accessGranted = YES;
            }
            
            if (accessGranted) {
                arrContacts=[self fetchContactsArray:addressBook];
            }
            break;
            
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            MY_ALERT(APP_NAME, @"Permission was not granted for contacts. Please perform the following:\n1: Open “Settings”\n2: Select “Privacy”\n3: Select “Contacts”\n4: Turn “Client Diary” on.", nil);
        }
            break;
            
        default:
            break;
    }
    
    return arrContacts;
}

+ (NSMutableArray *)fetchContactsArray:(ABAddressBookRef)addressBook
{
    NSMutableArray *arrContacts = [[NSMutableArray alloc] initWithArray:[Client fetchContatctsOfNotRegisteredUsersForUser:USER_ID]];
    NSMutableArray *arrUsers = [[NSMutableArray alloc] init];
    
    NSMutableArray *thePeople = (__bridge  NSMutableArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSDate *lastSyncDate = [[self getValueFromPlist] objectForKey:kLastSyncContactDateOfUser];
    
    [thePeople enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ABRecordRef person = (__bridge ABRecordRef)obj;
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty));
        
        NSString *strPhone=@"";
        NSString *strFirstName=@"";
        NSString *strLastName=@"";
        
        if (ABMultiValueGetCount(phones)>0)
        {
            for (int k=0; k<ABMultiValueGetCount(phones); k++) {
                
                strPhone =(__bridge NSString *)ABMultiValueCopyValueAtIndex(phones,k);
                strFirstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                strLastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/:.()-*#+"];
                strPhone = [[strPhone componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
                NSArray *parts = [strPhone componentsSeparatedByCharactersInSet:whitespaces];
                NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
                strPhone = [filteredArray componentsJoinedByString:@""];
                
                if ([strPhone length]>0) {
                    
                    Client *userObject = [Client fetchClientByMobileNo:strPhone forUser:ShareObj.loginuserId];
                    
                    if (![strPhone isEqualToString:ShareObj.userObj.mobile] && userObject==nil) {
                        NSDate *modifyDate = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonModificationDateProperty);
                        if (modifyDate)
                        {
                            if(lastSyncDate != nil)
                            {
                                if([modifyDate isLaterThan:lastSyncDate])
                                {
                                    NSMutableDictionary *diccOfRecoed=[[NSMutableDictionary alloc] init];
                                    [diccOfRecoed setObject:(strPhone==nil) ? @"" : strPhone forKey:kMECmobile];
                                    
                                    [diccOfRecoed setObject:(strFirstName == nil) ? @"" : [NSString stringWithFormat:@"%@", strFirstName] forKey:kMECfirstName];
                                    [diccOfRecoed setObject:(strLastName == nil) ? @"" : [NSString stringWithFormat:@"%@", strLastName] forKey:kMEClastName];
                                    
                                    [arrContacts addObject:strPhone];
                                    [arrUsers addObject:diccOfRecoed];
                                }
                            }
                            else
                            {
                                NSMutableDictionary *diccOfRecoed=[[NSMutableDictionary alloc] init];
                                [diccOfRecoed setObject:(strPhone==nil) ? @"" : strPhone forKey:kMECmobile];
                                
                                [diccOfRecoed setObject:(strFirstName == nil) ? @"" : [NSString stringWithFormat:@"%@", strFirstName] forKey:kMECfirstName];
                                [diccOfRecoed setObject:(strLastName == nil) ? @"" : [NSString stringWithFormat:@"%@", strLastName] forKey:kMEClastName];
                                
                                [arrContacts addObject:strPhone];
                                [arrUsers addObject:diccOfRecoed];
                            }
                        }
                    }
                }
            }
        }
    }];
    
    lastSyncDate = [NSDate date];
    NSMutableDictionary *dic = [self getValueFromPlist];
    [dic setObject:lastSyncDate forKey:kLastSyncContactDateOfUser];
    [self setValueToPlist:dic];
    NSLog(@"contacts => %@", arrUsers);
    [Client addUserRecordsDuringSyncContacts:arrUsers];
    return arrContacts;
}

+ (ImageType)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return JPG;
        case 0x89:
            return PNG;
        case 0x47:
            return GIF;
        case 0x49:
        case 0x4D:
            return TIFF;
    }
    return -1;
}

+ (NSString *)convertToString:(ImageType) enumType {
    NSString *result = nil;
    
    switch(enumType) {
        case JPG:
            result = @"JPG";
            break;
        case PNG:
            result = @"PNG";
            break;
        case GIF:
            result = @"GIF";
            break;
        case TIFF:
            result = @"TIFF";
            break;
            
        default:
            result = @"unknown";
    }
    
    return result;
}

+ (BOOL)fileExistAtPath:(NSString *)filePath ofType:(ImageType)fileType fileName:(NSString *)fileName ofSize:(CGSize)size {
    
    switch (fileType) {
        case JPG: {
            fileName = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@_%.0f.jpeg", fileName, size.width]];
        }
            break;
        case PNG: {
            fileName = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@_%.0f.png", fileName, size.width]];
        }
            break;
        default:
            break;
    }
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:fileName])
        return YES;
    else
        return NO;
}

+ (void)removerDirectory:(NSString *)directory
{
    NSError *error;
    // *** Remove currupted File if Exist ***
    if ([[NSFileManager defaultManager]fileExistsAtPath:directory]) {
        [[NSFileManager defaultManager]removeItemAtPath:directory error:&error];
    }
}

+ (NSAttributedString *)getAttributedString:(NSString *)str withFont:(NSString *)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor strokeColor:(UIColor *)strokeColor withLetterpressStyle:(BOOL)letterpressStyle
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONT_WITH_NAME_SIZE(fontName, fontSize),
                                                                                                       NSForegroundColorAttributeName: fontColor,
                                                                                                       NSTextEffectAttributeName : NSTextEffectLetterpressStyle
                                                                                                       }];
    return attributedString;
}

+ (NSDictionary *)getTextAttributesForFont:(NSString *)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor strokeColor:(UIColor *)strokeColor
{
    NSDictionary *attributedTextDict =  @{NSFontAttributeName: FONT_WITH_NAME_SIZE(fontName, fontSize),
                                          NSForegroundColorAttributeName: fontColor,
                                          NSStrokeWidthAttributeName: @-4.f,
                                          NSStrokeColorAttributeName: strokeColor
                                          };
    return attributedTextDict;
}

+ (UIView *)getLeftView:(CGSize)size
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [leftView setBackgroundColor:CLEAR_COLOR];
    return leftView;
}

+ (void)setLeftViewOfSize:(CGSize)size toTextFields:(NSArray *)objects
{
    for (UITextField *textField in objects) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [leftView setBackgroundColor:CLEAR_COLOR];
        [textField setLeftView:leftView];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
    }
}

+ (void)setFont:(NSString *)font fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor toViewObjectType:(ViewObjectType)viewObjType toObjects:(NSArray *)objects
{
    switch (viewObjType) {
        case TextField: {
            for (UITextField *textField in objects) {
                [textField setFont:FONT_WITH_NAME_SIZE(font, fontSize)];
                [textField setTextColor:fontColor];
            }
        }
            break;
        case Label: {
            for (UILabel *lbl in objects) {
                [lbl setFont:FONT_WITH_NAME_SIZE(font, fontSize)];
                [lbl setTextColor:fontColor];
            }
        }
            break;
        case TextView: {
            for (UITextView *textView in objects) {
                [textView setFont:FONT_WITH_NAME_SIZE(font, fontSize)];
                [textView setTextColor:fontColor];
            }
        }
            break;
        default:
            break;
    }
}

+ (UIImageView *)getImgViewOfRect:(CGRect)rect withImage:(UIImage *)img andBackgroundColor:(UIColor *)color
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    [imgView setBackgroundColor:color];
    [imgView setImage:img];
    
    return imgView;
}

#pragma mark - NSTextEffectLetterpressStyle
#pragma mark -
+ (void)applyLetterpressStyleTextEffectToLabel:(UILabel *)label
{
    NSDictionary *attrs = @{NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
    
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:label.text attributes:attrs];
    
    [label setAttributedText:attrString];
}


NSString *NSStringf(NSString *format, ...) {
    va_list ap;
    NSString *str;
    va_start(ap,format);
    str=[[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    
    return str;
}

+ (bool)isThisSize:(CGSize)aa biggerThanThis:(CGSize)bb
{
    if ( aa.width > bb.width ) return YES;
    if ( aa.height > bb.height ) return YES;
    if ( aa.width==bb.width && aa.height==bb.height ) return NO;
    return NO;
}

+ (bool)isThis:(CGSize)aa biggerThanThis:(CGSize)bb
{
    if ( aa.width < bb.width ) return NO;
    if ( aa.height < bb.height ) return NO;
    if ( aa.width==bb.width && aa.height==bb.height ) return NO;
    return YES;
}

void AddGlowArc(CGContextRef context, CGFloat x, CGFloat y, CGFloat radius, CGFloat peakAngle, CGFloat sideAngle, CGColorRef colorRef){
    CGFloat increment = .05;
    for (CGFloat angle = peakAngle - sideAngle; angle < peakAngle + sideAngle; angle+=increment){
        CGFloat alpha = (sideAngle - fabs(angle - peakAngle)) / sideAngle;
        CGColorRef newColor = CGColorCreateCopyWithAlpha(colorRef, alpha);
        CGContextSetStrokeColorWithColor(context, newColor);
        CGContextAddArc(context, x, y, radius, angle, angle + increment, 0);
        CGContextStrokePath(context);
    }
}

+ (void)showNotificationWithTitle:(NSString *)notificationTitle titleColor:(UIColor *)tColor backgroundColor:(UIColor *)bgColor forDuration:(float)duration
{
    NSMutableDictionary *options = [@{kCRToastNotificationTypeKey               : @(CRToastTypeStatusBar),
                                      kCRToastNotificationPresentationTypeKey   : @(CRToastPresentationTypeCover),
                                      kCRToastUnderStatusBarKey                 : @(NO),
                                      kCRToastTextKey                           : notificationTitle,
                                      kCRToastTextAlignmentKey                  : @(NSTextAlignmentCenter),
                                      kCRToastTimeIntervalKey                   : @(duration),
                                      kCRToastAnimationInTypeKey                : @(CRToastAnimationTypeSpring),
                                      kCRToastAnimationOutTypeKey               : @(CRToastAnimationTypeSpring),
                                      kCRToastAnimationInDirectionKey           : @(CRToastAnimationDirectionTop),
                                      kCRToastAnimationOutDirectionKey          : @(CRToastAnimationDirectionTop),
                                      kCRToastBackgroundColorKey                : bgColor,
                                      kCRToastTextColorKey                      : tColor
                                      } mutableCopy];
    
    [CRToastManager showNotificationWithOptions:options
                                 apperanceBlock:^(void) {
                                     NSLog(@"Appeared");
                                 }
                                completionBlock:^(void) {
                                    NSLog(@"Completed");
                                }];
}

+ (NSString *)currentDate
{
    NSString *myFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df2 setDateFormat:myFormat];
    NSString *retDateStr = [df2 stringFromDate:[NSDate date]];
    
    return retDateStr;
}

+ (NSString *)currentYear
{
    NSString *myFormat = @"yyyy";
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df2 setDateFormat:myFormat];
    NSString *retDateStr = [df2 stringFromDate:[NSDate date]];
    
    return retDateStr;
}

+ (NSString *)currentDateTime
{
    NSString *myFormat = @"yyyy-MM-dd hh:mm:ss";
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df2 setDateFormat:myFormat];
    NSString *retDateStr = [df2 stringFromDate:[NSDate date]];
    
    return retDateStr;
}

+ (NSString *)formatDateToCore:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *retDate = [df stringFromDate:date];
    
    return retDate;
}

+ (NSString *)getDateStringFromDate:(NSDate *)date ofFormat:(NSString *)dateFormat
{
    NSString *dateStr;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
    [df setDateFormat:dateFormat];
    
    dateStr = [df stringFromDate:date];
    return dateStr;
}

+ (NSString *)getDateStringOfFormat:(NSString *)dateFormat fromDateString:(NSString *)dateString ofFormat:(NSString *)datStringFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
    [df setDateFormat:datStringFormat];
    
    NSDate *date = [df dateFromString:dateString];
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setTimeZone:timeZone];
    [df1 setDateFormat:dateFormat];
    
    NSString *retDateStr = [df1 stringFromDate:date];
    
    return retDateStr;
}

+ (NSDate *)getDatefromDateString:(NSString *)dateString ofFormat:(NSString *)datStringFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
    [df setDateFormat:datStringFormat];
    
    NSDate *date = [df dateFromString:dateString];
    
    return date;
}

+ (BOOL)isImageExist:(NSString *)fn
{
    NSString *fileName = [fn stringByDeletingPathExtension];
    
    NSString *originaljpegFileName = [IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [fileName lastPathComponent]]];
    NSString *originalpngFileName = [IMG_DIR_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [fileName lastPathComponent]]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:originaljpegFileName]) {
        return YES;
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:originalpngFileName]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
