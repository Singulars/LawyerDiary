//
//  SubordinateAdmin.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 08/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import "SubordinateAdmin.h"

@implementation SubordinateAdmin

@dynamic adminId;
@dynamic adminName;
@dynamic hasAccess;

+ (SubordinateAdmin *)saveSubordinateAdmin:(NSDictionary *)dataDict
{
    @try {
        
        for (NSString *key in dataDict) {
            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        SubordinateAdmin *obj = [self fetchSubordinateAdmin:[dataDict objectForKey:kAPIadminId]];
        
        if (obj != nil) {
            @try {
                [obj setAdminId:[dataDict objectForKey:kAPIadminId] ? @([[dataDict objectForKey:kAPIadminId] integerValue]) : @0];
                [obj setAdminName:dataDict[kAPIadminName] ? dataDict[kAPIadminName] : @""];
                [obj setHasAccess:dataDict[kAPIhasAccess] ? @([[dataDict objectForKey:kAPIhasAccess] boolValue]) : @0];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception debugDescription]);
            }
            @finally {
                
            }
        }
        else {
            obj = [NSEntityDescription insertNewObjectForEntityForName:kSubordinateAdmin inManagedObjectContext:context];
            @try {
                [obj setAdminId:[dataDict objectForKey:kAPIadminId] ? @([[dataDict objectForKey:kAPIadminId] integerValue]) : @0];
                [obj setAdminName:dataDict[kAPIadminName] ? dataDict[kAPIadminName] : @""];
                [obj setHasAccess:dataDict[kAPIhasAccess] ? @([[dataDict objectForKey:kAPIhasAccess] boolValue]) : @0];
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

+ (BOOL)updateAccessForAdmin:(NSNumber *)adminId withValue:(NSNumber *)value
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        SubordinateAdmin *obj = [self fetchSubordinateAdmin:adminId];
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

+ (BOOL)deleteSubordinate:(NSNumber *)adminId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        SubordinateAdmin *obj = [self fetchSubordinateAdmin:adminId];
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

+ (BOOL)deleteSubordinateAdmins {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kSubordinateAdmin inManagedObjectContext:context];
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

+ (SubordinateAdmin *)fetchSubordinateAdmin:(NSNumber *)adminId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kSubordinateAdmin inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"adminId = %@", adminId];
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

+ (NSArray *)fetchSubordinateAdmins
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kSubordinateAdmin inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIadminId ascending:NO];
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

+ (SubordinateAdmin *)fetchAdminWhoHasGivenAccess
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kSubordinateAdmin inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hasAccess = %@", @1];
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

@end
