//
//  Client.h
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/19/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Client : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * clientId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * birthdate;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * isRegistered;

+ (NSMutableArray *)fetchContatctsOfNotRegisteredUsersForUser:(NSNumber *)userId;

+ (NSArray *)fetchClientsWhoAreNotFriendOfUser:(NSNumber *)userId;
+ (NSArray *)fetchNotRegisteredClientsForUser:(NSNumber *)userId;

+ (Client *)fetchClientByMobileNo:(NSString *)mobileNo forUser:(NSNumber *)userId;
+ (BOOL)addUserRecordsDuringSyncContacts:(NSArray *)arrRecords;

@end
