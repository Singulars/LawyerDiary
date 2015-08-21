//
//  Court.m
//  
//
//  Created by Verma Mukesh on 01/07/15.
//
//

#import "Court.h"
#import "Cases.h"


@implementation Court

@dynamic courtCity;
@dynamic courtId;
@dynamic courtName;
@dynamic dateTime;
@dynamic isCourtDeleted;
@dynamic isSynced;
@dynamic localCourtId;
@dynamic megistrateName;
@dynamic userId;
@dynamic adminId;
@dynamic adminName;
@dynamic hasAccess;
@dynamic isSubordinate;

+ (NSNumber *)generateID {
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger:timeStamp];
    return timeStampObj;
}

+ (Court *)saveCourt:(NSDictionary *)dataDict forSubordiante:(BOOL)flag withAdminDetail:(NSDictionary *)adminDetail
{
    @try {
        
        for (NSString *key in dataDict) {
            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Court *obj = [self fetchCourtLocally:@([[dataDict objectForKey:kAPIlocalCourtId] integerValue])];
       
//        if ([dataDict objectForKey:kAPIcourtId]) {
//             obj = [self fetchCourt:[dataDict objectForKey:kAPIcourtId]];
//        }
//        else if ([dataDict objectForKey:kAPIrandom]) {
//            obj = [self fetchCourtLocally:[dataDict objectForKey:kAPIrandom]];
//        }
        
        if (obj != nil) {
            @try {
                [obj setUserId:USER_ID];
                [obj setLocalCourtId:[dataDict objectForKey:kAPIlocalCourtId] ? @([[dataDict objectForKey:kAPIlocalCourtId] integerValue]) : [Court generateID]];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @-1];
                [obj setCourtName:dataDict[kAPIcourtName] ? dataDict[kAPIcourtName] : @""];
                [obj setCourtCity:dataDict[kAPIcourtCity] ? dataDict[kAPIcourtCity] : @""];
                [obj setMegistrateName:dataDict[kAPImegistrateName] ? dataDict[kAPImegistrateName] : @""];
                [obj setDateTime:dataDict[kAPIdateTime] ? dataDict[kAPIdateTime] : @""];
                [obj setIsSynced:[dataDict objectForKey:kIsSynced] ? @0 : @1];
                if (flag) {
                    [obj setAdminId:@([[adminDetail objectForKey:kAPIadminId] integerValue])];
                    [obj setAdminName:[adminDetail objectForKey:kAPIadminName]];
                    [obj setHasAccess:@([[adminDetail objectForKey:kAPIhasAccess] integerValue])];
                    [obj setIsSubordinate:@1];
                }
                else {
                    [obj setAdminId:@-1];
                    [obj setAdminName:@""];
                    [obj setHasAccess:@0];
                    [obj setIsSubordinate:@0];
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
                [obj setUserId:USER_ID];
                [obj setLocalCourtId:[dataDict objectForKey:kAPIlocalCourtId] ? @([[dataDict objectForKey:kAPIlocalCourtId] integerValue]) : [self generateID]];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @-1];
                [obj setCourtName:dataDict[kAPIcourtName] ? dataDict[kAPIcourtName] : @""];
                [obj setCourtCity:dataDict[kAPIcourtCity] ? dataDict[kAPIcourtCity] : @""];
                [obj setMegistrateName:dataDict[kAPImegistrateName] ? dataDict[kAPImegistrateName] : @""];
                [obj setDateTime:dataDict[kAPIdateTime] ? dataDict[kAPIdateTime] : @""];
                [obj setIsSynced:[dataDict objectForKey:kIsSynced] ? @0 : @1];
                if (flag) {
                    [obj setAdminId:@([[adminDetail objectForKey:kAPIadminId] integerValue])];
                    [obj setAdminName:[adminDetail objectForKey:kAPIadminName]];
                    [obj setHasAccess:@([[adminDetail objectForKey:kAPIhasAccess] integerValue])];
                    [obj setIsSubordinate:@1];
                }
                else {
                    [obj setAdminId:@-1];
                    [obj setAdminName:@""];
                    [obj setHasAccess:@0];
                    [obj setIsSubordinate:@0];
                }
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

+ (BOOL)saveCourtsForSubordinate:(NSDictionary *)dataDict
{
    BOOL result = NO;
    
    NSArray *arrCourts = [[NSArray alloc] initWithArray:[dataDict objectForKey:kAPIdata]];
    
    for (NSDictionary *courtObj in arrCourts) {
        if ([Court saveCourt:courtObj forSubordiante:YES withAdminDetail:dataDict]) {
            result = YES;
        }
        else {
            return result;
        }
    }
    
    return result;
}

+ (BOOL)updatedCourtPropertyofCourt:(Court *)courtObj withProperty:(CourtProperty)property andValue:(NSNumber *)propertyValue
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        switch (property) {
            case kCourtIsDeleted: {
                [courtObj setIsCourtDeleted:propertyValue];
                [courtObj setIsSynced:@0];
            }
                break;
            case kCourtIsSynced: {
                [courtObj setIsSynced:propertyValue];
            }
                break;
            default:
                break;
        }
        
        NSError *error = nil;
        // Save the context.
        if ([context save:&error]) {
            NSLog(@"Court updated succesfully");
            return YES;
        }
        else {
            NSLog(@"Court update failed! %@, %@", error, [error userInfo]);
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

+ (Court *)fetchCourtLocally:(NSNumber *)localCourtId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCourt inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSString *predicateString = [NSString stringWithFormat:@"localCourtId==\"%@\"", localCourtId];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
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

+ (NSArray *)fetchCourtsForAdmin
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCourt inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSubordinate = %@ && isCourtDeleted = %@", @0, @0];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIcourtId ascending:NO];
        [request setSortDescriptors:@[sortDescriptor]];
        
        NSError *error;
        NSArray *objArr = [context executeFetchRequest:request error:&error];
        
        if ([objArr count] > 0) {
            return objArr;
        }
        else
            return nil;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}


+ (NSArray *)fetchCourtsForAdmin:(NSNumber *)adminId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCourt inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"adminId = %@ && isCourtDeleted = %@", adminId, @0];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIcourtId ascending:NO];
        [request setSortDescriptors:@[sortDescriptor]];
        
        NSError *error;
        NSArray *objArr = [context executeFetchRequest:request error:&error];
        
        if ([objArr count] > 0) {
            return objArr;
        }
        else
            return @[];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (NSArray *)fetchCourtsForSubordinate
{
    @try {
        NSMutableArray *arrResult = [[NSMutableArray alloc] init];
        
        NSArray *admins = [SubordinateAdmin fetchSubordinateAdmins];
        
        for (SubordinateAdmin *adminObj in admins) {
            
            NSMutableDictionary *recordDict = [[NSMutableDictionary alloc] init];
            
            recordDict[kAPIadminData] = adminObj;
            recordDict[kAPIdata] = [Court fetchCourtsForAdmin:adminObj.adminId];
            
            [arrResult addObject:recordDict];
        }
        
        return [[NSArray alloc] initWithArray:arrResult];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

@end
