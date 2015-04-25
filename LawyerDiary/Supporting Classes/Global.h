//
//  Global.h
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import <AddressBook/AddressBook.h>

typedef NS_ENUM(NSUInteger, ViewObjectType) {
    TextField = 0,
    Label,
    TextView
} ;

typedef NS_ENUM(NSUInteger, ImageType) {
    JPG = 0,
    PNG,
    GIF,
    TIFF
} ;

@interface Global : NSObject

#pragma mark - Fade In/Out View
+ (void)fadeInView:(UIView *)view;

+ (void)fadeOutView:(UIView *)view;

#pragma mark - Show Alert
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andCancelText:(NSString *)cancel andOther:(NSString *)other andDelegate:(id)delegate withTag:(NSInteger)tag;

#pragma mark - Get image
+ (UIImage *)imageWithName:(NSString *)imageName andType:(NSString *)type;

#pragma mark - Custom Font
+ (UIFont *)fontWithName:(NSString *)fontName andSize:(NSInteger)size;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

#pragma mark - Add Skip From Backup Attribute to File
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL skip:(BOOL)skip;

#pragma mark - Delete All the Images
+ (void)deleteImages;

#pragma mark - Internet Alert
+ (void)showInternetAlert;

+ (NSArray *)loadAllDownloadePDFFiles;

+ (BOOL)isFileAvailable:(NSString *)fileName;

#pragma mark- Validte textfield
+(BOOL)validateTextField:(UITextField *)txtField;
+ (BOOL)validateEmail:(NSString *)email;

#pragma mark- Apply letterpress effect to labels
+ (void)applyLetterpressStyleTextEffectToLabels:(NSArray *)labelArr;

#pragma mark- Hide Navigation BsckBarButton Title
+ (UIBarButtonItem *)hideBackBarButtonTitle;

#pragma mark- Apply corner radius to views with color
+ (void)applyUIViewCornerRadiusToView:(NSArray *)views withRadius:(CGFloat)radius andColor:(UIColor *)color andBorderWidth:(CGFloat)width;

#pragma mark - Apply Corener Radius To View
+ (void)applyCornerRadiusToViews:(NSArray *)views withRadius:(CGFloat)radius borderColor:(UIColor *)color andBorderWidth:(CGFloat)width;

#pragma mark-
#pragma mark Save Image To Local

+(void)saveImage:(NSData *)ImageData :(NSString *)strPath Indirectory:(NSString *)directoryName;
+(NSString *)getImage:(NSString *)strId fromDirectory:(NSString *)directory;
+(void)ResizeImage:(UIImage *)image SaveToDirectory:(NSString *)strDirectory FileName:(NSString *)strFileName;
+(void)DeleteFile:(NSString *)strFileName FromDirectory:(NSString *)directoryName;
+(void)DeleteImagesFromDirectory:(NSString *)directory;

+ (UIImage *)cropImage:(UIImage *)image WithSize:(CGRect)rect;

+ (NSString *)getFullDate;

+ (NSString*)getUniqName;

+ (NSString *)getLongStringDateFromString:(NSString *)dateStr;

+ (UIActivityIndicatorView *)showActiVityIndicatorView;
#pragma mark Show/Hide Network Indicatior

+ (void)setBorderColorAndWidthToView:(UIView *)view flag:(BOOL)flag;

+ (NSString *)formatBirthdateToCore:(NSString *)dateStr;

+ (UIImage *)resizeImage:(UIImage *)image forFrameSize:(CGRect)rect;

+ (UIImage *)resizeImage:(UIImage *)image withWidth:(CGFloat)width withHeight:(CGFloat)height;

+ (NSInteger)getUserAgeFromBirthdate:(NSString *)dateStr;

#pragma mark - Buttons
+ (void)applyAppleBlueBorderAndHighlightImageToButton:(NSArray *)buttons withRadius:(CGFloat)radius andFontSize:(CGFloat)fontSize;
+ (void)applyAppleRedBorderAndHighlightImageToButton:(NSArray *)buttons withRadius:(CGFloat)radius andFontSize:(CGFloat)fontSize;
+ (void)applyAppleGreenBorderAndHighlightImageToButton:(NSArray *)buttons withRadius:(CGFloat)radius andFontSize:(CGFloat)fontSize;

+ (NSDictionary *)setNavigationBarTitleTextAttributesLikeFont:(NSString *)fontName fontColor:(UIColor *)color andFontSize:(CGFloat)fontSize andStrokeColor:(UIColor *)strokeColor;

+ (void)applyAppleBorderAndHighlightImageToButtons:(NSArray *)buttons withRadius:(CGFloat)radius font:(NSString *)fontName fontSize:(CGFloat)fontSize fontNormalColor:(UIColor *)nFcolor fontHighlightedColor:(UIColor *)hFcolor btnNormalColor:(UIColor *)nColor btnHighlightedColor:(UIColor *)hColor andBorderWidth:(CGFloat)borderWidth;

+ (void)applyPropertiesToButtons:(NSArray *)buttons likeFont:(NSString *)btnFont fontSize:(CGFloat)btnFontSize fontNormalColor:(UIColor *)btnFontNormalColor fontHighlightedColor:(UIColor *)btnFontHighlightedColor borderColor:(UIColor *)btnBorderColor borderWidth:(CGFloat)btnBorderWidth cornerRadius:(CGFloat)btnCorenerRadius normalBackgroundColor:(UIColor *)btnNormalBackgroundColor andHighlightedBackgroundColor:(UIColor *)btnHighlightedBackgroundColor;

+ (void)setBackGroundImageToNavigationBar:(UINavigationBar *)navBar withImageColor:(UIColor *)color;

#pragma mark - Set UINavigationBar Background Image With Color
+ (void)setNavigationBarBackGroundImageWithColor:(UIColor *)color ofNaigationBar:(UINavigationBar *)navBar;

#pragma mark - Set UITabbar Background Image With Color
+ (void)setBackGroundImageToTabBar:(UITabBar *)tabBar withImageColor:(UIColor *)color;

#pragma mark - Set LeftView To UITextField
+ (void)setLefViewOfFrame:(CGRect)frame toTextFields:(NSArray *)textFields;

#pragma mark - Set RightView To UITextField
+ (void)setRightViewOfFrame:(CGRect)frame toTextFields:(NSArray *)textFields;

#pragma mark - Set Font To UiviewObject Array
+ (void)setFont:(NSString *)fontName withSize:(CGFloat)size color:(UIColor *)fontColor toUIViewType:(ViewObjectType)objType objectArr:(NSArray *)tfArr;

#pragma mark - Encode UIImage to base64 string
+ (NSString *)encodeToBase64String:(UIImage *)image;

#pragma mark - Decode base64 string to UIImage
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

+ (NSMutableArray *)getAllNewContactsFromContactList;

+ (ImageType)contentTypeForImageData:(NSData *)data;
+ (NSString *)convertToString:(ImageType) enumType;
+ (BOOL)fileExistAtPath:(NSString *)filePath ofType:(ImageType)fileType fileName:(NSString *)fileName ofSize:(CGSize)size;

+ (NSAttributedString *)getAttributedString:(NSString *)str withFont:(NSString *)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor strokeColor:(UIColor *)strokeColor;
+ (NSAttributedString *)getAttributedString:(NSString *)str withFont:(NSString *)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor strokeColor:(UIColor *)strokeColor withLetterpressStyle:(BOOL)letterpressStyle;
+ (NSDictionary *)getTextAttributesForFont:(NSString *)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor strokeColor:(UIColor *)strokeColor;

+ (UIView *)getLeftView:(CGSize)size;

+ (void)setLeftViewOfSize:(CGSize)size toTextFields:(NSArray *)objects;

+ (void)setFont:(NSString *)font fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor toViewObjectType:(ViewObjectType)viewObjType toObjects:(NSArray *)objects;

+ (UIImageView *)getImgViewOfRect:(CGRect)rect withImage:(UIImage *)img andBackgroundColor:(UIColor *)color;

+ (void)applyLetterpressStyleTextEffectToLabel:(UILabel *)label;

NSString *NSStringf(NSString *format, ...);

+ (bool)isThisSize:(CGSize)aa biggerThanThis:(CGSize)bb;

+ (bool)isThis:(CGSize)aa biggerThanThis:(CGSize)bb;

void AddGlowArc(CGContextRef context, CGFloat x, CGFloat y, CGFloat radius, CGFloat peakAngle, CGFloat sideAngle, CGColorRef colorRef);

@end
