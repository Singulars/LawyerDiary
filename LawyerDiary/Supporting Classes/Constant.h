//
//  Constant.h
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#ifndef AnyWordz_Constant_h
#define AnyWordz_Constant_h

#import <CoreData/CoreData.h>
#import <Social/Social.h>
#import <AudioToolbox/AudioToolbox.h>

#import "AppDelegate.h"
#import "Home.h"
#import "Register.h"

#import "User.h"
#import "Client.h"

#import "NetworkManager.h"
#import "Reachability.h"
#import "SharedManager.h"
#import "Global.h"
#import "UIImage+ColorImage.h"
#import "NSDate+Extra.h"
#import "UIImage+ImageEffects.h"
#import "UITextField+Shake.h"
#import "ManagedObjectCloner.h"
#import "NSDictionary+SJSONString.h"

#import "NetworkManager.h"

typedef enum : NSInteger {
    signUp = 0,
    logIn,
    forgotPassword,
    syncContacts,
} APIAction;

typedef enum : NSInteger {
    SaveBarButton = 0,
    IndicatorBarButton,
    EditButton,
    NilBarButton,
    CloseBarButton,
    SyncBarButton,
    SendBarButton,
    SignUpBarButton
} UIBarButton;

typedef enum : NSInteger {
    kImageRenderModeOriginal = 0,
    kImageRenderModeTemplate,
    kImageRenderModeAutomatic
} ImageRenderMode;


//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - Check System Version
#pragma mark -

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - Check Device Type
#pragma mark -

#define IS_IPHONE_5             (fabs((double)[[ UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

#define IsBiggerThaniPhone      [Global isThis:CGSizeMake([[ UIScreen mainScreen] bounds].size.width, [[ UIScreen mainScreen] bounds].size.height) biggerThanThis:CGSizeMake(320, 480)]

#define IS_IPHONE                           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?YES:NO
#define IS_IPAD                             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?YES:NO

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - Library / Directory Paths
#pragma mark -

#define LIB_PATH                            [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DOC_DIR_PATH                        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define IMG_DIR_PATH                        [DOC_DIR_PATH stringByAppendingPathComponent:@"/ProfilePicture"]

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - UserDefaults
#pragma mark -

#define SetLastSyncServerTime(time)         [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"LastSyncServerTime"], [[NSUserDefaults standardUserDefaults] synchronize]
#define GetLastSyncServerTime               [[NSUserDefaults standardUserDefaults] valueForKey:@"LastSyncServerTime"];
#define RemoveLastSyncServerTime            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LastSyncServerTime"], [[NSUserDefaults standardUserDefaults] synchronize]

#define SetSyncContactsServerTime(time)     [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"SyncContactsServerTime"], [[NSUserDefaults standardUserDefaults] synchronize]
#define GetSyncContactsServerTime           [[NSUserDefaults standardUserDefaults] valueForKey:@"SyncContactsServerTime"];
#define RemoveSyncContactsServerTime        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SyncContactsServerTime"], [[NSUserDefaults standardUserDefaults] synchronize]

#define SetIsContactsSynced(value)          [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"IsContactsSynced"], [[NSUserDefaults standardUserDefaults] synchronize]
#define GetIsContactsSynced                 [[NSUserDefaults standardUserDefaults] boolForKey:@"IsContactsSynced"]
#define RemoveIsContactsSynced              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsContactsSynced"], [[NSUserDefaults standardUserDefaults] synchronize]

#define SetLoginUserId(value)               [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"LoginUserId"], [[NSUserDefaults standardUserDefaults] synchronize]
#define GetLoginUserId                      [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserId"]
#define RemoveLoginUserId                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginUserId"], [[NSUserDefaults standardUserDefaults] synchronize]

#define SetLoginUserPassword(value)         [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"LoginUserPassword"], [[NSUserDefaults standardUserDefaults] synchronize]
#define GetLoginUserPassword                [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserPassword"]
#define RemoveLoginUserPassword             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginUserPassword"], [[NSUserDefaults standardUserDefaults] synchronize]

#define SetLastActiveTime(time)             [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"ActiveTime"], [[NSUserDefaults standardUserDefaults] synchronize]
#define GetLastActiveTime                   [[NSUserDefaults standardUserDefaults] valueForKey:@"ActiveTime"];
#define RemoveLastActiveTime                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ActiveTime"], [[NSUserDefaults standardUserDefaults] synchronize]

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - Misc
#pragma mark -

#define VIBRATE_DEVICE                      AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate), AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

#define kLastSyncContactDateOfUser          ShareObj.loginuserId
#define kModifyDate                         @"ContactModifyDate"

#define kDefaultDateFormat                  @"yyyy-MM-dd HH:mm:ss"
#define kServerDateTimeFormat               @"yyyy-MM-dd HH:mm:ss"
#define kDefaultShortDateFormat             @"yyyy-MM-dd"

#define DefaultDateTime                     @"2000-01-01 12:00:00"

#define DefaultBirthdateFormat              @"MMMM dd, yyyy"

#define ServerBirthdateFormat               @"MM/dd/yyyy"

#define SetStatusBarLightContent(flag)       [[UIApplication sharedApplication] setStatusBarStyle:flag ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault]

#define SetStatusBarHidden(flag)             [[UIApplication sharedApplication] setStatusBarHidden:flag]

#define UserIntrectionEnable(value)         [APP_DELEGATE window].userInteractionEnabled = value
#define ShowNetworkIndicatorVisible(value)  [UIApplication sharedApplication].networkActivityIndicatorVisible=value
#define ShowStatusBar(flag)                 [[UIApplication sharedApplication] setStatusBarHidden:!flag withAnimation:UIStatusBarAnimationFade];
#define HideHomeNavigationBar(flag)         [[APP_DELEGATE homeNavController].navigationBar setHidden:flag]

#define EXCEPTION_DEBUG_DESCRIPTION(e)      NSLog(@"Exception => %@", [e debugDescription])
#define IMAGE_WITH_NAME(imgName)            [UIImage imageNamed:imgName]
#define IMAGE_WITH_NAME_AND_RENDER_MODE(imgName, ImageRenderMode) [[UIImage imageNamed:imgName] imageWithRenderingMode:ImageRenderMode == kImageRenderModeOriginal ? UIImageRenderingModeAlwaysOriginal : (ImageRenderMode == kImageRenderModeTemplate ? UIImageRenderingModeAlwaysTemplate : UIImageRenderingModeAutomatic)]

#define POST_NOTIFICATION(name, obj)        [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj]
#define UPPERCASE_STRING(string)            [string uppercaseString]
#define LOWERCASE_STRING(string)            [string lowercaseString]
#define CAPITALIZED_STRING(string)          [string capitalizedString]

#define VIBRATE_DEVICE                      AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate), AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

#define WARNING                 @"Warning!"
#define ERROR                   @"Error!"

#define APP_NAME                            @"Lawyer Diary"

#define KEYBOARD_HEIGHT         216
#define TOOLBAR_HEIGHT          44
#define NAVBAR_HEIGHT           44
#define TABBAR_HEIGHT           49

#define IsRegisteredForRemoteNotifications  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications]

#define APP_DELEGATE                  (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define ShareObj                      [SharedManager sharedManger]

#define USER_ID                       ShareObj.userObj.userId
#define USER_OBJECT                   ShareObj.userObj
#define USER_ID_OBJ                   ShareObj.userObj.userId

#define SCREEN_HEIGHT(view)           view.bounds.size.height
#define SCREEN_WIDTH(view)            view.bounds.size.width

#define kInviteFriendsAppURL                @"http://www.app.com"
#define kInviteFriendsInitialText           @"- I am using Lawyer Diary, download from bottom URL\n"

#define kSOMETHING_WENT_WRONG               @"Something went wrong!! Please try again later."
#define kREQUEST_TIME_OUT                   @"Request time out!\nPlease try agin later."
#define kCHECK_INTERNET                     @"You are not connected to the internet!"

#define SCREENWIDTH                         [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT                        [[UIScreen mainScreen] bounds].size.height
#define NAVHIEGHT                           44.0
#define KEYBOARDHEIGHT                      216.0
#define NAVBARHEIGHT                        64.0f
#define EDGEZEROINSET                       UIEdgeInsetsMake(0, 0, 0, 0)
#define TOOLBARHEIGHT                       44.0
#define TABBARHEIGHT                        49.0

#define WORD_CELL_SIZE     35.0

#define MY_ALERT(Title,Msg,Delegate)        [[[UIAlertView alloc] initWithTitle:Title \
message:Msg \
delegate:Delegate \
cancelButtonTitle:nil \
otherButtonTitles:@"OK", nil] show];

#define FONT_WITH_NAME_SIZE(n,s)            [UIFont fontWithName:n size:s]
#define IMAGE_WITH_NAME(imgName)            [UIImage imageNamed:imgName]

#define MP3                                 @"mp3"
#define AAC                                 @"aac"
#define WAV                                 @"wav"

#define kDescribe_Your_Word                 @"Describe your word in 20 characters."

#define kScoreboardCellID                   @"ScoreboardID"
#define kTop10CellID                        @"Top10ID"
#define kFriendsCellID                      @"FriendsID"
#define kInviteCellID                       @"InviteID"
#define kSearchFriendCellID                 @"SearchID"
#define kHowToPlayCellID                    @"HowToPlayID"
#define kSoundsCellID                       @"SoundsID"
#define kVibrateCellID                      @"VibrateID"
#define kLogoutCellID                       @"LogoutID"

#define APP_FONT                            @"UnDotum"

#define kCellIndex                          @"CellIndex"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - UIStoryboard Identifiers
#pragma mark -

#define kRegisterNavController  @"RegisterNavController"
#define kHomeNavController      @"HomeNavController"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - UILocalNotification
#pragma mark -



//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - APNS - KEYS
#pragma mark -

#define APNS_APS                            @"aps"
#define APNS_ALERT                          @"alert"
#define APNS_TYPE                           @"type"
#define APNS_BADGE                          @"badge"
#define APNS_CONTENT_AVAILABLE              @"content-available"
#define APNS_USERID                         @"userId"


//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//

#pragma mark - Application Colors
#pragma mark -

#define UICOLOR(r,g,b,a)                    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define BLUE_COLOR                    [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define GREEN_COLOR                   [UIColor colorWithRed:0.0f/255.0f green:225.0f/255.0f blue:122.0f/255.0f alpha:1.0f]
#define RED_COLOR                     [UIColor redColor]
#define WHITE_COLOR                   [UIColor whiteColor]
#define BLACK_COLOR                   [UIColor blackColor]
#define LIGHT_GRAY_COLOR              [UIColor lightGrayColor]
#define DARK_GRAY_COLOR               [UIColor darkGrayColor]
#define CLEAR_COLOR                   [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.0f]
#define GROUP_TABLEVIEW_COLOR         [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:244.0f/255.0f alpha:1.0f]
#define CLEARCOLOUR                   [UIColor clearColor]

#define APP_TINT_COLOR                UICOLOR(43, 41, 42, 1)

#define TABLEVIEW_SEPRATOR_COLOR     [UIColor colorWithRed:200.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1.0f]

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - API Management
#pragma mark -

#define HOST_URL                            @"http://singulars.co.in/"
#define API_PATH                            @"lawyer/webservice.php"
#define PRO_PIC_URL_PATH                    @"lawyer/profilePic/"
#define WEBSERVICE_CALL_URL                 [HOST_URL stringByAppendingString:API_PATH]
#define PRO_PIC_URL                         [HOST_URL stringByAppendingString:PRO_PIC_URL_PATH]

#define GetProPicURLForUser(fileName, userId)   [NSString stringWithFormat:@"%@%@%@", PRO_PIC_URL, userId, fileName]

#define kRequestTimeOut                     60.0f

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - API Request / Response Keys
#pragma mark -

#define kAPIstatus                          @"status"
#define kAPImessage                         @"message"

#define kAPIuser                            @"user"

#define RESPONSE_STATUS_OK                  @"OK"
#define RESPONSE_STATUS_ERR                 @"ERROR"

#define kAPIMode                            @"mode"
#define kAPIuserId                          @"userId"
#define kAPIclientId                        @"clientId"
#define kAPIfirstName                       @"firstName"
#define kAPIlastName                        @"lastName"
#define kAPIemail                           @"email"
#define kAPIpassword                        @"password"
#define kAPImobile                          @"mobile"
#define kAPIbirthdate                       @"birthdate"
#define kAPIaddress                         @"address"
#define kAPIregistrationNo                  @"registrationNo"
#define kAPIproPic                          @"proPic"

#define kAPIdeviceToken                     @"deviceToken"
#define kAPIdeviceType                      @"deviceType"


// mode keys
#define ksignUp                             @"signUp"
#define klogIn                              @"logIn"
#define kforgotPassword                     @"forgotPassword"
#define ksyncContacts                       @"syncContacts"


#define kgetServerDateTime                  @"getServerDateTime"
#define kresetNotificationCount             @"resetNotificationCount"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - Images
#pragma mark -

#define IMG_placeholder                     @"placeholder"

#define IMG_user_placeholder_36             @"user-placeholder-36"
#define IMG_user_placeholder_50             @"user-placeholder-50"
#define IMG_user_placeholder_80             @"user-placeholder-80"

#define IMG_right_chevron                   @"right-chevron"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - Model
#pragma mark -

#define kDataModel                          @"LawyerDiary"

#define kDBName                             @"LawyerDiary.sqlite"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - Entities
#pragma mark -

#define kUser                               @"User"
#define kClient                             @"Client"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - User Entity Keys - Model
#pragma mark -

#define kMEUuserId                          @"userId"
#define kMEUfirstName                       @"firstName"
#define kMEUlastName                        @"lastName"
#define kMEUemail                           @"email"
#define kMEUmobile                          @"mobile"
#define kMEUbirthdate                       @"birthdate"
#define kMEUaddress                         @"address"
#define kMEUregistrationNo                  @"registrationNo"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - Friend Entity Keys
#pragma mark -

#define kMECuserId                          @"userId"
#define kMECclientId                        @"clientId"
#define kMECfirstName                       @"firstName"
#define kMEClastName                        @"lastName"
#define kMECbirthdate                       @"birthdate"
#define kMECaddress                         @"address"
#define kMECmobile                          @"mobile"
#define kMECemail                           @"email"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#endif