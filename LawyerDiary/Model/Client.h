//
//  Client.h
//  
//
//  Created by Verma Mukesh on 11/05/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Client : NSManagedObject

@property (nonatomic, retain) NSNumber * loacalClientID;
@property (nonatomic, retain) NSNumber * clientId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, readwrite) NSNumber * isPlannerAppUser;
@property (nonatomic, readwrite) NSNumber * isSynced;
@property (nonatomic, readwrite) NSNumber * isDeleted;

+ (Client *)saveClient:(NSDictionary *)dataDict forUser:(NSNumber *)userId;
+ (BOOL)deleteClient:(NSNumber *)courtId;
+ (BOOL)deleteCourtsForUser:(NSNumber *)userId;
+ (Client *)fetchCourt:(NSNumber *)courtId;
+ (NSArray *)fetchClients:(NSNumber *)userId;

@end
