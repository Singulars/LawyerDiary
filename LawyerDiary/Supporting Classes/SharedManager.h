//
//  SharedManager.h
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FetchSubordinateStatus) {
    kStatusSuccess = 0,
    kStatusFailedBecauseInternet,
    kStatusFailed,
    kStatusUndetermined
};

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
@property (nonatomic, strong) NSString *subordinetId;

@property (nonatomic, assign) UIUserNotificationType currentNotificationType;

@property (nonatomic, strong) NSString *searchStr;
@property (nonatomic, strong) NSMutableArray *arrSearchedFriends;
@property (nonatomic, strong) NSMutableArray *arrContacts;

@property (nonatomic, strong) User *userObj;

@property (nonatomic, readwrite) BOOL hasAdminAccess;
@property (nonatomic, readwrite) FetchSubordinateStatus fetchSubordinateStatus;

+ (SharedManager *)sharedManger;
- (void)getCurrentServerDateTime;

- (void)resetNotificationBadgeCount;

- (void)saveProfileData:(NSDictionary *)params forAction:(NSInteger)action;

- (void)fetchSubordinatesWithCompletionHandler:(void (^)(BOOL finished))completionHandler;

- (void)updateAdminAccessVariablesValue;

- (void)syncUpdatedCourtRecords;
- (void)syncDeletedCourtRecords;
- (void)syncUpdatedClientRecords;
- (void)syncDeletedClientRecords;
- (void)syncUpdatedCaseRecords;
- (void)syncDeletedCaseRecords;

- (void)fetchCourts;
- (void)fetchCourtsForSubordinate;
- (void)fetchClients;
- (void)fetchClientsForSubordinates;

@end
