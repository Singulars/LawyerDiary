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
#import "DrawerTableViewController.h"
#import "Cases.h"
#import "Clients.h"
#import "Courts.h"

#import "CourtCell.h"

#import "User.h"

#import "SVPullToRefresh.h"

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
#import "CRToast.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "UIKit+AFNetworking.h"

#import "ClusterPrePermissions.h"

#import "UIPlaceHolderTextView.h"

typedef NS_ENUM(NSUInteger, PagingPriority) {
    kPriorityInitial = 0,
    kPriorityOlder,
    kPriorityNewer
};

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
    SignUpBarButton,
    AddBarButton
} UIBarButton;

typedef enum : NSInteger {
    kImageRenderModeOriginal = 0,
    kImageRenderModeTemplate,
    kImageRenderModeAutomatic
} ImageRenderMode;

#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define BundlePath                          [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define NavBar                              self.navigationController.navigationBar
#define TabBar                              self.tabBarController.tabBar
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewWidth                       self.view.bounds.size.width
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c)                         [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];

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

#define DefaultBirthdateFormat              @"d MMM, yyyy"

#define ServerBirthdateFormat               @"yyyy-MM-dd"

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

#define IsRegisteredForRemoteNotifications  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications]

#define APP_DELEGATE                  (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define ShareObj                      [SharedManager sharedManger]

#define image_url_request(imageURL)         [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60]]

#define USER_ID                       ShareObj.userObj.userId
#define USER_OBJECT                   ShareObj.userObj

#define SCREEN_HEIGHT(view)           view.bounds.size.height
#define SCREEN_WIDTH(view)            view.bounds.size.width

#define VIEWSIZE(view)                     CGSizeMake(view.frame.size.width, view.frame.size.height)

#define kInviteFriendsAppURL                @"http://www.app.com"
#define kInviteFriendsInitialText           @"- I am using Lawyer Diary, download from bottom URL\n"

#define kSOMETHING_WENT_WRONG               @"Something went wrong! Please try again later."
#define kREQUEST_TIME_OUT                   @"Request time out! Please try agin later."
#define kCHECK_INTERNET                     @"You are not connected to the internet!"

#define SCREENWIDTH                         [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT                        [[UIScreen mainScreen] bounds].size.height
#define EDGEZEROINSET                       UIEdgeInsetsMake(0, 0, 0, 0)

#define IS_INTERNET_CONNECTED               ShareObj.isInternetConnected

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

#define APP_FONT                            @"HelveticaNeue"
#define APP_FONT_BOLD                       @"HelveticaNeue-Semibold"

//#define APP_FONT                            @"UnDotum"
//#define APP_FONT_BOLD                       @"UnDotum-Bold"

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
#define APP_RED_COLOR                 UICOLOR(220, 37, 47,1)
#define APP_GREEN_COLOR               [UIColor colorWithRed:81.0f/255.0f green:182.0f/255.0f blue:79.0f/255.0f alpha:1.0f]

#define Placeholder_Text_Color        UICOLOR(199, 199, 205,1)

#define APP_TINT_COLOR                UICOLOR(42, 50, 65, 1)
//#define APP_TINT_COLOR                UICOLOR(48, 56, 73, 1)
//#define APP_TINT_COLOR                UICOLOR(80, 93, 114, 1)

#define APP_TINT_COLOR_LIGHT                UICOLOR(108, 125, 155, 1)

#define TABLEVIEW_SEPRATOR_COLOR     [UIColor colorWithRed:200.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1.0f]

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - API Management
#pragma mark -

#define HOST_URL                            @"http://singulars.co.in/"
//#define HOST_URL                            @"http://www.webegins.com/"
#define API_PATH                            @"lawyer/webservice.php"
#define PRO_PIC_URL_PATH                    @"lawyer/profilePic/"
#define WEBSERVICE_CALL_URL                 [HOST_URL stringByAppendingString:API_PATH]
#define PRO_PIC_URL                         [HOST_URL stringByAppendingString:PRO_PIC_URL_PATH]

#define PLANNER_PRO_PIC_URL                 [@"http://www.webegins.com/" stringByAppendingString:PRO_PIC_URL_PATH]

#define GetProPicURLForUser(userId)   [NSString stringWithFormat:@"%@%@_big.png", PRO_PIC_URL, userId]
#define GetProPicURLForPlannerUser(userId)   [NSString stringWithFormat:@"%@%@_big.png", PLANNER_PRO_PIC_URL, userId]

#define kRequestTimeOut                     60.0f

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - API Request / Response Keys
#pragma mark -

#define kAPIstatus                          @"status"
#define kAPImessage                         @"message"

#define kAPIuserDetail                      @"userDetail"

#define RESPONSE_STATUS_OK                  @"OK"
#define RESPONSE_STATUS_ERR                 @"ERROR"

#define kAPIMode                            @"mode"
#define kAPIuserId                          @"userId"
#define kAPIrandom                          @"random"
#define kAPIclientId                        @"clientId"
#define kAPIfirstName                       @"firstName"
#define kAPIlastName                        @"lastName"
#define kAPIlocalClientId                   @"localClientId"
#define kAPIclientFirstName                 @"clientFirstName"
#define kAPIclientLastName                  @"clientLastName"
#define kAPItaskPlannerId                   @"taskPlannerId"
#define kAPIisTaskPlanner                   @"isTaskPlanner"
#define kAPIemail                           @"email"
#define kAPIpassword                        @"password"
#define kAPImobile                          @"mobile"
#define kAPIcountryCode                     @"countryCode"
#define kAPIbirthdate                       @"birthdate"
#define kAPIaddress                         @"address"
#define kAPIregistrationNo                  @"registrationNo"
#define kAPIproPic                          @"proPic"
#define kAPIisVerified                      @"isVerified"
#define kAPIcourtId                         @"courtId"
#define kAPIlocalCourtId                    @"localCourtId"
#define kAPIcourtName                       @"courtName"
#define kAPIcourtCity                       @"courtCity"
#define kAPImegistrateName                  @"megistrateName"
#define kAPIdateTime                        @"dateTime"
#define kAPIhasAccess                       @"hasAccess"
#define kAPIisProfile                       @"isProfile"


#define kAPIlocalCaseId                     @"localCaseId"
#define kAPIcaseId                          @"caseId"
#define kAPIcaseNo                          @"caseNo"
#define kAPIlastHeardDate                   @"lastHeardDate"
#define kAPInextHearingDate                 @"nextHearingDate"
#define kAPIcaseStatus                      @"caseStatus"
#define kAPIisCaseDeleted                   @"isCaseDeleted"

#define kAPIoppositionLawyerName            @"oppositionLawyerName"
#define kAPIoppositionFirstName             @"oppositionFirstName"
#define kAPIoppositionLastName              @"oppositionLastName"

#define kAPItaskPlannerId                   @"taskPlannerId"
#define kAPIisTaskPlanner                   @"isTaskPlanner"

#define kLocalCourtId                       @"localCourtId"
#define kIsSynced                           @"isSynced"
#define kIsDeleted                          @"isDeleted"

#define kAPIdeviceToken                     @"deviceToken"
#define kAPIdeviceType                      @"deviceType"

#define kAPIcourData                        @"courtData"
#define kAPIclientData                      @"clientData"
#define kAPIcaseData                        @"caseData"
#define kAPIcaseList                        @"caseList"
#define kAPIsubordinateData                 @"subordinateData"

#define kAPIindex                           @"index"
#define kAPIoffset                          @"offset"
#define kAPIisBefore                        @"isBefore"

// mode keys
#define ksignUp                             @"signUp"
#define klogIn                              @"logIn"
#define kisRegistered                       @"isRegistered"
#define kforgotPassword                     @"forgotPassword"
#define ksyncContacts                       @"syncContacts"
#define kloadCourts                         @"loadCourts"
#define kloadCase                           @"loadCase"
#define ksaveCourt                          @"saveCourt"
#define kdeleteCourt                        @"deleteCourt"
#define kdeleteCase                         @"deleteCase"
#define kupdateProfile                      @"updateProfile"
#define kloadClients                        @"loadClients"
#define ksaveClient                         @"saveClient"
#define kdeleteClient                       @"deleteClient"
#define ksaveCase                           @"saveCase"
#define kloadSubordinate                    @"loadSubordinate"

#define kgetServerDateTime                  @"getServerDateTime"
#define kresetNotificationCount             @"resetNotificationCount"

//*//*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*/*//*//

#pragma mark - Images
#pragma mark -

#define image_placeholder_36                [UIImage imageNamed:@"user-avatar-80"]
#define image_placeholder_50                [UIImage imageNamed:@"user-avatar-80"]
#define image_placeholder_80                [UIImage imageNamed:@"user-avatar-80"]

#define IMG_right_chevron                   @"right-chevron"
#define IMG_row_disclosure                  @"row-disclosure"

#define IMG_btn_add                         @"btn-add"

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
#define kCourt                              @"Court"
#define kCases                              @"Cases"
#define kSubordinate                        @"Subordinate"

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