//
//  Subordinate.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 05/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "Subordinate.h"

@implementation Subordinate

@dynamic userId;
@dynamic firstName;
@dynamic lastName;
@dynamic mobile;
@dynamic hasAccess;
@dynamic isProfile;

+ (Subordinate *)saveSubordinate:(NSDictionary *)dataDict
{
    @try {
        
        for (NSString *key in dataDict) {
            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Subordinate *obj = [self fetchSubordinate:[dataDict objectForKey:kAPIuserId]];
        
        if (obj != nil) {
            @try {
                [obj setUserId:[dataDict objectForKey:kAPIuserId] ? @([[dataDict objectForKey:kAPIuserId] integerValue]) : @0];
                [obj setFirstName:dataDict[kAPIfirstName] ? dataDict[kAPIfirstName] : @""];
                [obj setLastName:dataDict[kAPIlastName] ? dataDict[kAPIlastName] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setHasAccess:dataDict[kAPIhasAccess] ? @([[dataDict objectForKey:kAPIhasAccess] boolValue]) : @0];
                [obj setIsProfile:dataDict[kAPIisProfile] ? @([[dataDict objectForKey:kAPIisProfile] boolValue]) : @0];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception debugDescription]);
            }
            @finally {
                
            }
        }
        else {
            obj = [NSEntityDescription insertNewObjectForEntityForName:kSubordinate inManagedObjectContext:context];
            @try {
                [obj setUserId:[dataDict objectForKey:kAPIuserId] ? @([[dataDict objectForKey:kAPIuserId] integerValue]) : @0];
                [obj setFirstName:dataDict[kAPIfirstName] ? dataDict[kAPIfirstName] : @""];
                [obj setLastName:dataDict[kAPIlastName] ? dataDict[kAPIlastName] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setHasAccess:dataDict[kAPIhasAccess] ? @([[dataDict objectForKey:kAPIhasAccess] boolValue]) : @0];
                [obj setIsProfile:dataDict[kAPIisProfile] ? @([[dataDict objectForKey:kAPIisProfile] boolValue]) : @0];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception debugDescription]);
            }
            @finally {
                
            }
        }
        
        // Save the context.
        NSError *error = nil;
        if ([context save:&error]) {
            NSLog(@"Subordinate saved succesfully");
            return obj;
        }
        else {
            NSLog(@"Subordinate save failed! %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)updateAccessForUser:(NSNumber *)userId withValue:(NSNumber *)value
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        Subordinate *obj = [self fetchSubordinate:userId];
        [obj setHasAccess:value];
        
        NSError *error = nil;
        // Save the context.
        if ([context save:&error]) {
            NSLog(@"Subordinate access updated succesfully");
            return YES;
        }
        else {
            NSLog(@"Subordinate access update failed! %@, %@", error, [error userInfo]);
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)deleteSubordinate:(NSNumber *)userId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        Subordinate *obj = [self fetchSubordinate:userId];
        [context deleteObject:obj];
        
        NSError *error = nil;
        // Save the context.
        if ([context save:&error]) {
            NSLog(@"Subordinate deleted succesfully");
            return YES;
        }
        else {
            NSLog(@"Subordinate deletion failed! %@, %@", error, [error userInfo]);
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)deleteSubordinates {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kSubordinate inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        for (Subordinate *subordinateObj in objects) {
            [context deleteObject:subordinateObj];
        }
        
        if ([context save:&error]) {
            NSLog(@"Subordinates Deleted Succesfully!");
            return YES;
        } else {
            NSLog(@"Subordinates Deletion Failed : %@", [error userInfo]);
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
    }
}

+ (Subordinate *)fetchSubordinate:(NSNumber *)userId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kSubordinate inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *objArr = [context executeFetchRequest:request error:&error];
        
        if ([objArr count] > 0)
            return objArr[0];
        else
            return nil;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (NSArray *)fetchSubordinates
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kSubordinate inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIuserId ascending:NO];
        [request setSortDescriptors:@[sortDescriptor]];
        
        NSError *error;
        NSArray *objArr = [context executeFetchRequest:request error:&error];
        
        if ([objArr count] > 0)
            return objArr;
        else
            return nil;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

@end
