//
//  SharedManager.h
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedManager : NSObject
{
    BOOL isInternetConnected;
}

@property (nonatomic, readwrite) BOOL shouldDownloadImages;

@property (nonatomic, readwrite) BOOL isInternetConnected;
@property (nonatomic, readwrite) BOOL isSyncingContacts;
@property (nonatomic, readwrite) BOOL isSyncingFriends;
@property (nonatomic, readwrite) BOOL isLoadingFriendRequests;
@property (nonatomic, readwrite) BOOL isSearchingFriend;

@property (nonatomic, strong) NSNumber *loginuserId;
@property (nonatomic, strong) NSString *loginUserName;
@property (nonatomic, strong) NSString *serverDateTime;
@property (nonatomic, strong) NSString *syncContactsDateTime;
@property (nonatomic, strong) NSString *currentPassword;
@property (nonatomic, strong) NSString *updatedPassword;
@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic, assign) UIUserNotificationType currentNotificationType;

@property (nonatomic, strong) NSString *searchStr;
@property (nonatomic, strong) NSMutableArray *arrSearchedFriends;
@property (nonatomic, strong) NSMutableArray *arrContacts;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) User *userObj;

+ (SharedManager *)sharedManger;
- (void)getCurrentServerDateTime;

- (void)resetNotificationBadgeCount;
@end
