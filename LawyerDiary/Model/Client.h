//
//  Client.h
//  
//
//  Created by Verma Mukesh on 01/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cases;

typedef NS_ENUM(NSUInteger, ClientProperty) {
    kClientIsSynced = 0,
    kClientIsDeleted
};

@interface Client : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * localClientId;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * clientFirstName;
@property (nonatomic, retain) NSNumber * clientId;
@property (nonatomic, retain) NSString * clientLastName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSNumber * isClientDeleted;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSNumber * taskPlannerId;
@property (nonatomic, retain) NSNumber * isTaskPlanner;

@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSString * adminName;
@property (nonatomic, retain) NSNumber * hasAccess;
@property (nonatomic, retain) NSNumber * isSubordinate;

//+ (Client *)saveClient:(NSDictionary *)dataDict forUser:(NSNumber *)userId;
+ (Client *)saveClients:(NSDictionary *)dataDict forSubordiante:(BOOL)flag withAdminDetail:(NSDictionary *)adminDetail;
+ (BOOL)saveClientsForSubordinate:(NSDictionary *)dataDict;

+ (BOOL)updatedClientPropertyofClient:(Client *)clientObj withProperty:(ClientProperty)property andValue:(NSNumber *)propertyValue;
+ (BOOL)deleteClient:(NSNumber *)clientId;
+ (BOOL)deleteCientsForAdmin;
+ (BOOL)deleteCientsForSubordinate;
+ (BOOL)deleteCientsForAdmin:(NSNumber*)adminId;
+ (Client *)fetchClient:(NSNumber *)clientId;
+ (NSArray *)fetchClients:(NSNumber *)userId;
+ (NSArray *)fetchClientsForSubordinate;
+ (NSArray *)fetchClientsForAdmin:(NSNumber *)adminId;
+ (NSArray *)fetchClientsForAdmin;

+ (NSArray *)fetchNotSyncedClients;
+ (NSArray *)fetchDeletedNotSyncedClients;
@end