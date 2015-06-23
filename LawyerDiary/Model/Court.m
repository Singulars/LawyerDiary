//
//  Court.m
//  
//
//  Created by Verma Mukesh on 02/05/15.
//
//

#import "Court.h"


@implementation Court

@dynamic courtId;
@dynamic userId;
@dynamic courtName;
@dynamic courtCity;
@dynamic megistrateName;
@dynamic dateTime;

+ (NSNumber *)generateID {
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger:timeStamp];
    return timeStampObj;
}

+ (Court *)saveCourt:(NSDictionary *)dataDict forUser:(NSNumber *)userId
{
    @try {
        
        for (NSString *key in dataDict) {
            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Court *obj;
        
        if ([dataDict objectForKey:kAPIcourtId]) {
             obj = [self fetchCourt:[dataDict objectForKey:kAPIcourtId]];
        }
        else if ([dataDict objectForKey:kAPIcourtId]) {
            obj = [self fetchCourt:[dataDict objectForKey:kLocalCourtId]];
        }
        
        if (obj != nil) {
            @try {
                [obj setUserId:userId];
                [obj setLocalCourtId:@([[dataDict objectForKey:kLocalCourtId] integerValue])];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @-1];
                [obj setCourtName:dataDict[kAPIcourtName] ? dataDict[kAPIcourtName] : @""];
                [obj setCourtCity:dataDict[kAPIcourtCity] ? dataDict[kAPIcourtCity] : @""];
                [obj setMegistrateName:dataDict[kAPImegistrateName] ? dataDict[kAPImegistrateName] : @""];
                [obj setDateTime:dataDict[kAPIdateTime] ? dataDict[kAPIdateTime] : @""];
                
                if ([obj.isDeleted isEqualToNumber:@0]) {
                    
                    if ([dataDict objectForKey:kIsSynced]) {
                        [obj setIsSynced:@([[dataDict objectForKey:kIsSynced] integerValue])];
                    }
                }
                else {
                    [obj setIsSynced:@1];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception debugDescription]);
            }
            @finally {
                
            }
        }
        else {
            obj = [NSEntityDescription insertNewObjectForEntityForName:kCourt inManagedObjectContext:context];
            @try {
                [obj setUserId:userId];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @-1];
                [obj setCourtName:dataDict[kAPIcourtName] ? dataDict[kAPIcourtName] : @""];
                [obj setCourtCity:dataDict[kAPIcourtCity] ? dataDict[kAPIcourtCity] : @""];
                [obj setMegistrateName:dataDict[kAPImegistrateName] ? dataDict[kAPImegistrateName] : @""];
                [obj setDateTime:dataDict[kAPIdateTime] ? dataDict[kAPIdateTime] : @""];
                [obj setIsDeleted:@0];
                [obj setIsSynced:@1];
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
            NSLog(@"Court saved succesfully");
            return obj;
        }
        else {
            NSLog(@"Court save failed! %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)updatedCourtPropertyofCourt:(Court *)courtObj withProperty:(CourtProperty)property andValue:(NSNumber *)propertyValue
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        
        
        NSError *error = nil;
        // Save the context.
        if ([context save:&error]) {
            NSLog(@"Court deleted succesfully");
            return YES;
        }
        else {
            NSLog(@"Court deletion failed! %@, %@", error, [error userInfo]);
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)deleteCourt:(NSNumber *)courtId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        Court *obj = [self fetchCourt:courtId];
        [context deleteObject:obj];
        
        NSError *error = nil;
        // Save the context.
        if ([context save:&error]) {
            NSLog(@"Court deleted succesfully");
            return YES;
        }
        else {
            NSLog(@"Court deletion failed! %@, %@", error, [error userInfo]);
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)deleteCourtsForUser:(NSNumber *)userId {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kCourt inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId = %@)", userId];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        for (Court *courtObj in objects) {
            [context deleteObject:courtObj];
        }
        
        if ([context save:&error]) {
            NSLog(@"Court Deleted Succesfully!");
            return YES;
        } else {
            NSLog(@"Court Deletion Failed : %@", [error userInfo]);
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
    }
}

+ (Court *)fetchCourt:(NSNumber *)courtId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCourt inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"courtId = %@", courtId];
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

+ (NSArray *)fetchCourts:(NSNumber *)userId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCourt inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIdateTime ascending:NO];
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
