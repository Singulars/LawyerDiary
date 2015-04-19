//
//  Client.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/19/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "Client.h"


@implementation Client

@dynamic userId;
@dynamic clientId;
@dynamic firstName;
@dynamic lastName;
@dynamic birthdate;
@dynamic address;
@dynamic mobile;
@dynamic email;
@dynamic isRegistered;

+ (NSMutableArray *)fetchContatctsOfNotRegisteredUsersForUser:(NSNumber *)userId {
    
    @try {
        NSMutableArray *arrContacts=[[NSMutableArray alloc] init];
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isRegistered = 0 && userId = %@)", userId];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        // *** Sort Records ***
        [request setEntity:entity];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        [objects enumerateObjectsUsingBlock:^(Client *obj, NSUInteger idx, BOOL *stop) {
            [arrContacts addObject:obj.mobile];
        }];
        return arrContacts;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
        
    }
}

+ (NSArray *)fetchClientsWhoAreNotFriendOfUser:(NSNumber *)userId {
    
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isRegistered = 0 && userId = %@)", userId];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        // *** Sort Records ***
        [request setEntity:entity];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        return objects;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
        
    }
}

+ (NSArray *)fetchNotRegisteredClientsForUser:(NSNumber *)userId {
    
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isRegistered = 1 && userId = %@)", userId];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        // *** Sort Records ***
        [request setEntity:entity];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        return objects;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
        
    }
}

+ (Client *)fetchClientByMobileNo:(NSString *)mobileNo forUser:(NSNumber *)userId {
    
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId = %@ && mobile = %@)", userId, mobileNo];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if([objects count] > 0)
            return [objects objectAtIndex:0];
        else
            return nil;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)addUserRecordsDuringSyncContacts:(NSArray *)arrRecords
{
    __block BOOL isInserted = FALSE;
    
    if ([arrRecords count] > 0) {
        
        [arrRecords enumerateObjectsUsingBlock:^(NSDictionary *dataDict, NSUInteger idx, BOOL *stop) {
            
            NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
            
            Client *obj = [NSEntityDescription insertNewObjectForEntityForName:kClient inManagedObjectContext:context];
            if(obj != nil)
            {
                @try {
                    [obj setUserId:USER_ID];
                    [obj setClientId:nil];
                    [obj setFirstName:dataDict[kMECfirstName]];
                    [obj setLastName:dataDict[kMEClastName]];
                    [obj setBirthdate:nil];
                    [obj setAddress:nil];
                    [obj setEmail:nil];
                    [obj setMobile:dataDict[kMECmobile]];
                    [obj setIsRegistered:@0];
                    
                    NSError *error = nil;
                    if ([context save:&error]) {
                        NSLog(@"Client saved successfully");
                        isInserted=TRUE;
                        
                    } else {
                        NSLog(@"Failed to save Client : %@", [error userInfo]);
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%@",[exception debugDescription]);
                }
                @finally {
                }
            }
        }];
    }
    return isInserted;
}

@end
