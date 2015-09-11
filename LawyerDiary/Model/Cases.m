//
//  Cases.m
//  
//
//  Created by Verma Mukesh on 01/07/15.
//
//

#import "Cases.h"
#import "Client.h"
#import "Court.h"


@implementation Cases

@dynamic userId;
@dynamic localCaseId;
@dynamic caseId;
@dynamic localCourtId;
@dynamic courtId;
@dynamic courtName;
@dynamic megistrateName;
@dynamic courtCity;
@dynamic localClientId;
@dynamic clientId;
@dynamic clientFirstName;
@dynamic clientLastName;
@dynamic mobile;
@dynamic oppositionLawyerName;
@dynamic oppositionFirstName;
@dynamic oppositionLastName;
@dynamic caseNo;
@dynamic lastHeardDate;
@dynamic nextHearingDate;
@dynamic caseStatus;
@dynamic isCaseDeleted;
@dynamic isSynced;
@dynamic adminId;
@dynamic adminName;
@dynamic hasAccess;
@dynamic isSubordinate;

+ (NSNumber *)generateID {
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger:timeStamp];
    return timeStampObj;
}
+ (Cases *)saveCase:(NSDictionary *)dataDict forSubordiante:(BOOL)flag withAdminDetail:(NSDictionary *)adminDetail
{
    @try {
        
        for (NSString *key in dataDict) {
            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Cases *obj;

        if ([dataDict objectForKey:kAPIlocalCaseId]) {
            obj = [self fetchCaseLocally:@([[dataDict objectForKey:kAPIlocalCaseId] integerValue])];
        }
        
        //        if ([dataDict objectForKey:kAPIcourtId]) {
        //             obj = [self fetchCourt:[dataDict objectForKey:kAPIcourtId]];
        //        }
        //        else if ([dataDict objectForKey:kAPIrandom]) {
        //            obj = [self fetchCourtLocally:[dataDict objectForKey:kAPIrandom]];
        //        }
        
        if (obj != nil) {
            @try {
                [obj setUserId:USER_ID];
                [obj setLocalCaseId:[dataDict objectForKey:kAPIlocalCaseId] ? @([[dataDict objectForKey:kAPIlocalCaseId] integerValue]) : [Cases generateID]];
                [obj setCaseId:dataDict[kAPIcaseId] ? @([[dataDict objectForKey:kAPIcaseId] integerValue]) : @0];
                [obj setLocalCourtId:dataDict[kAPIlocalCourtId] ? @([[dataDict objectForKey:kAPIlocalCourtId] integerValue]) : @0];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @0];
                [obj setCourtName:dataDict[kAPIcourtName] ? dataDict[kAPIcourtName] : @""];
                [obj setMegistrateName:dataDict[kAPImegistrateName] ? dataDict[kAPImegistrateName] : @""];
                [obj setCourtCity:dataDict[kAPIcourtCity] ? dataDict[kAPIcourtCity] : @""];
                [obj setLocalClientId:dataDict[kAPIlocalClientId] ? @([[dataDict objectForKey:kAPIlocalClientId] integerValue]) : @0];
                [obj setClientId:dataDict[kAPIclientId] ? @([[dataDict objectForKey:kAPIclientId] integerValue]) : @0];
                [obj setClientFirstName:dataDict[kAPIclientFirstName] ? dataDict[kAPIclientFirstName] : @""];
                [obj setClientLastName:dataDict[kAPIclientLastName] ? dataDict[kAPIclientLastName] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setOppositionFirstName:dataDict[kAPIoppositionFirstName] ? dataDict[kAPIoppositionFirstName] : @""];
                [obj setOppositionLastName:dataDict[kAPIoppositionLastName] ? dataDict[kAPIoppositionLastName] : @""];
                [obj setOppositionLawyerName:dataDict[kAPIoppositionLawyerName] ? dataDict[kAPIoppositionLawyerName] : @""];
                [obj setCaseNo:dataDict[kAPIcaseNo] ? dataDict[kAPIcaseNo] : @""];
                [obj setCaseId:dataDict[kAPIcaseId] ? @([[dataDict objectForKey:kAPIcaseId] integerValue]) : @0];
                [obj setLastHeardDate:dataDict[kAPIlastHeardDate] ? dataDict[kAPIlastHeardDate] : @""];
                [obj setNextHearingDate:dataDict[kAPInextHearingDate] ? dataDict[kAPInextHearingDate] : @""];
                [obj setCaseStatus:dataDict[kAPIcaseStatus] ? dataDict[kAPIcaseStatus] : @""];
                
                [obj setIsSynced:[dataDict objectForKey:kIsSynced] ? @0 : @1];

                if (flag) {
                    [obj setAdminId:@([[adminDetail objectForKey:kAPIadminId] integerValue])];
                    [obj setAdminName:[adminDetail objectForKey:kAPIadminName]];
                    [obj setHasAccess:@([[adminDetail objectForKey:kAPIhasAccess] integerValue])];
                    [obj setIsSubordinate:@1];
                }
                else {
                    [obj setAdminId:@0];
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
            obj = [NSEntityDescription insertNewObjectForEntityForName:kCases inManagedObjectContext:context];
            @try {
                [obj setUserId:USER_ID];
                [obj setLocalCaseId:[dataDict objectForKey:kAPIlocalCaseId] ? @([[dataDict objectForKey:kAPIlocalCaseId] integerValue]) : [Cases generateID]];
                [obj setCaseId:dataDict[kAPIcaseId] ? @([[dataDict objectForKey:kAPIcaseId] integerValue]) : @0];
                [obj setLocalCourtId:dataDict[kAPIlocalCourtId] ? @([[dataDict objectForKey:kAPIlocalCourtId] integerValue]) : @0];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @0];
                [obj setCourtName:dataDict[kAPIcourtName] ? dataDict[kAPIcourtName] : @""];
                [obj setMegistrateName:dataDict[kAPImegistrateName] ? dataDict[kAPImegistrateName] : @""];
                [obj setCourtCity:dataDict[kAPIcourtCity] ? dataDict[kAPIcourtCity] : @""];
                [obj setLocalClientId:dataDict[kAPIlocalClientId] ? @([[dataDict objectForKey:kAPIlocalClientId] integerValue]) : @0];
                [obj setClientId:dataDict[kAPIclientId] ? @([[dataDict objectForKey:kAPIclientId] integerValue]) : @0];
                [obj setClientFirstName:dataDict[kAPIclientFirstName] ? dataDict[kAPIclientFirstName] : @""];
                [obj setClientLastName:dataDict[kAPIclientLastName] ? dataDict[kAPIclientLastName] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setOppositionFirstName:dataDict[kAPIoppositionFirstName] ? dataDict[kAPIoppositionFirstName] : @""];
                [obj setOppositionLastName:dataDict[kAPIoppositionLastName] ? dataDict[kAPIoppositionLastName] : @""];
                [obj setOppositionLawyerName:dataDict[kAPIoppositionLawyerName] ? dataDict[kAPIoppositionLawyerName] : @""];
                [obj setCaseNo:dataDict[kAPIcaseNo] ? dataDict[kAPIcaseNo] : @""];
                [obj setLastHeardDate:dataDict[kAPIlastHeardDate] ? dataDict[kAPIlastHeardDate] : @""];
                [obj setNextHearingDate:dataDict[kAPInextHearingDate] ? dataDict[kAPInextHearingDate] : @""];
                [obj setCaseStatus:dataDict[kAPIcaseStatus] ? dataDict[kAPIcaseStatus] : @""];
                
                [obj setIsSynced:[dataDict objectForKey:kIsSynced] ? @0 : @1];
                if (flag) {
                    [obj setAdminId:@([[adminDetail objectForKey:kAPIadminId] integerValue])];
                    [obj setAdminName:[adminDetail objectForKey:kAPIadminName]];
                    [obj setHasAccess:@([[adminDetail objectForKey:kAPIhasAccess] integerValue])];
                    [obj setIsSubordinate:@1];
                }
                else {
                    [obj setAdminId:@0];
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
            NSLog(@"Case saved succesfully");
            return obj;
        }
        else {
            NSLog(@"Case save failed! %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}
/*
+ (Cases *)saveCase:(NSDictionary *)dataDict forUser:(NSNumber *)userId
{
    @try {
        
        for (NSString *key in dataDict) {
//            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Cases *obj = [self fetchCaseLocally:@([[dataDict objectForKey:kAPIlocalCaseId] integerValue])];
        
        //        if ([dataDict objectForKey:kAPIclientId]) {
        //            obj = [self fetchClient:[dataDict objectForKey:kAPIcourtId]];
        //        }
        //        else if ([dataDict objectForKey:kAPIclientId]) {
        //            obj = [self fetchClient:[dataDict objectForKey:kAPIrandom]];
        //        }
        
        if (obj != nil) {
            @try {
                [obj setUserId:userId];
                [obj setLocalCaseId:[dataDict objectForKey:kAPIlocalCaseId] ? @([[dataDict objectForKey:kAPIlocalCaseId] integerValue]) : [Cases generateID]];
                [obj setCaseId:dataDict[kAPIcaseId] ? @([[dataDict objectForKey:kAPIcaseId] integerValue]) : @-1];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @-1];
                [obj setCourtName:dataDict[kAPIcourtName] ? dataDict[kAPIcourtName] : @""];
                [obj setMegistrateName:dataDict[kAPImegistrateName] ? dataDict[kAPImegistrateName] : @""];
                [obj setCourtCity:dataDict[kAPIcourtCity] ? dataDict[kAPIcourtCity] : @""];
                [obj setClientId:dataDict[kAPIclientId] ? @([[dataDict objectForKey:kAPIclientId] integerValue]) : @-1];
                [obj setClientFirstName:dataDict[kAPIclientFirstName] ? dataDict[kAPIclientFirstName] : @""];
                [obj setClientLastName:dataDict[kAPIclientLastName] ? dataDict[kAPIclientLastName] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setOppositionFirstName:dataDict[kAPIoppositionFirstName] ? dataDict[kAPIoppositionFirstName] : @""];
                [obj setOppositionLastName:dataDict[kAPIoppositionLastName] ? dataDict[kAPIoppositionLastName] : @""];
                [obj setOppositionLawyerName:dataDict[kAPIoppositionLawyerName] ? dataDict[kAPIoppositionLawyerName] : @""];
                [obj setCaseNo:dataDict[kAPIcaseNo] ? dataDict[kAPIcaseNo] : @""];
                [obj setCaseId:dataDict[kAPIcaseId] ? @([[dataDict objectForKey:kAPIcaseId] integerValue]) : @-1];
                [obj setLastHeardDate:dataDict[kAPIlastHeardDate] ? dataDict[kAPIlastHeardDate] : @""];
                [obj setNextHearingDate:dataDict[kAPInextHearingDate] ? dataDict[kAPInextHearingDate] : @""];
                [obj setCaseStatus:dataDict[kAPIcaseStatus] ? dataDict[kAPIcaseStatus] : @""];
                
                [obj setIsSynced:[dataDict objectForKey:kIsSynced] ? @0 : @1];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception debugDescription]);
            }
            @finally {
                
            }
        }
        else {
            obj = [NSEntityDescription insertNewObjectForEntityForName:kCases inManagedObjectContext:context];
            @try {
                [obj setUserId:userId];
                [obj setLocalCaseId:[dataDict objectForKey:kAPIlocalCaseId] ? @([[dataDict objectForKey:kAPIlocalCaseId] integerValue]) : [Cases generateID]];
                [obj setCaseId:dataDict[kAPIcaseId] ? @([[dataDict objectForKey:kAPIcaseId] integerValue]) : @-1];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @-1];
                [obj setCourtName:dataDict[kAPIcourtName] ? dataDict[kAPIcourtName] : @""];
                [obj setMegistrateName:dataDict[kAPImegistrateName] ? dataDict[kAPImegistrateName] : @""];
                [obj setCourtCity:dataDict[kAPIcourtCity] ? dataDict[kAPIcourtCity] : @""];
                [obj setClientId:dataDict[kAPIclientId] ? @([[dataDict objectForKey:kAPIclientId] integerValue]) : @-1];
                [obj setClientFirstName:dataDict[kAPIclientFirstName] ? dataDict[kAPIclientFirstName] : @""];
                [obj setClientLastName:dataDict[kAPIclientLastName] ? dataDict[kAPIclientLastName] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setOppositionFirstName:dataDict[kAPIoppositionFirstName] ? dataDict[kAPIoppositionFirstName] : @""];
                [obj setOppositionLastName:dataDict[kAPIoppositionLastName] ? dataDict[kAPIoppositionLastName] : @""];
                [obj setOppositionLawyerName:dataDict[kAPIoppositionLawyerName] ? dataDict[kAPIoppositionLawyerName] : @""];
                [obj setCaseNo:dataDict[kAPIcaseNo] ? dataDict[kAPIcaseNo] : @""];
                [obj setLastHeardDate:dataDict[kAPIlastHeardDate] ? dataDict[kAPIlastHeardDate] : @""];
                [obj setNextHearingDate:dataDict[kAPInextHearingDate] ? dataDict[kAPInextHearingDate] : @""];
                [obj setCaseStatus:dataDict[kAPIcaseStatus] ? dataDict[kAPIcaseStatus] : @""];
                
                [obj setIsSynced:[dataDict objectForKey:kIsSynced] ? @0 : @1];
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
            NSLog(@"Case saved succesfully");
            return obj;
        }
        else {
            NSLog(@"Case save failed! %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}*/

+ (Cases *)updateCase:(NSDictionary *)dataDict forUser:(NSNumber *)userId
{
    @try {
        
        for (NSString *key in dataDict) {
            //            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Cases *obj = [self fetchCaseLocally:@([[dataDict objectForKey:kAPIlocalCaseId] integerValue])];
        
        //        if ([dataDict objectForKey:kAPIclientId]) {
        //            obj = [self fetchClient:[dataDict objectForKey:kAPIcourtId]];
        //        }
        //        else if ([dataDict objectForKey:kAPIclientId]) {
        //            obj = [self fetchClient:[dataDict objectForKey:kAPIrandom]];
        //        }
        if (obj != nil) {
            @try {
                [obj setCaseId:dataDict[kAPIcaseId] ? @([[dataDict objectForKey:kAPIcaseId] integerValue]) : @0];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @0];
                [obj setClientId:dataDict[kAPIclientId] ? @([[dataDict objectForKey:kAPIclientId] integerValue]) : @0];
                
                [obj setIsSynced:[dataDict objectForKey:kIsSynced] ? @0 : @1];
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
            NSLog(@"Case saved succesfully");
            return obj;
        }
        else {
            NSLog(@"Case save failed! %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)updatedCasePropertyofCase:(Cases *)caseObj withProperty:(CaseProperty)property andValue:(NSNumber *)propertyValue
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        switch (property) {
            case kClientIsDeleted: {
                [caseObj setIsCaseDeleted:propertyValue];
            }
                break;
            case kClientIsSynced: {
                [caseObj setIsSynced:propertyValue];
            }
                break;
            default:
                break;
        }
        
        NSError *error = nil;
        // Save the context.
        if ([context save:&error]) {
            NSLog(@"Client deleted succesfully");
            return YES;
        }
        else {
            NSLog(@"Client deletion failed! %@, %@", error, [error userInfo]);
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)deleteCase:(NSNumber *)caseId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        Cases *obj = [self fetchCase:caseId];
        [context deleteObject:obj];
        
        NSError *error = nil;
        // Save the context.
        if ([context save:&error]) {
            NSLog(@"Client deleted succesfully");
            return YES;
        }
        else {
            NSLog(@"Client deletion failed! %@, %@", error, [error userInfo]);
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)deleteCaseForAdmin {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isSubordinate = %@)", @0];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        for (Client *clientObj in objects) {
            [context deleteObject:clientObj];
        }
        
        if ([context save:&error]) {
            NSLog(@"Case Deleted Succesfully!");
            return YES;
        } else {
            NSLog(@"Case Deletion Failed : %@", [error userInfo]);
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
    }
}

+ (BOOL)deleteCaseForSubordinate {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isSubordinate = %@)", @1];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        for (Client *clientObj in objects) {
            [context deleteObject:clientObj];
        }
        
        if ([context save:&error]) {
            NSLog(@"Case Deleted Succesfully!");
            return YES;
        } else {
            NSLog(@"Case Deletion Failed : %@", [error userInfo]);
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
    }
}

+ (BOOL)deleteCaseForAdmin:(NSNumber *)adminId {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isSubordinate = %@ && adminId = %@)", @0, adminId];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        for (Client *clientObj in objects) {
            [context deleteObject:clientObj];
        }
        
        if ([context save:&error]) {
            NSLog(@"Case Deleted Succesfully!");
            return YES;
        } else {
            NSLog(@"Case Deletion Failed : %@", [error userInfo]);
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
    }
}

+ (BOOL)isThisClientExist:(NSNumber *)localClientId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localClientId = %@", localClientId];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *objArr = [context executeFetchRequest:request error:&error];
        
        if ([objArr count] > 0)
            return YES;
        else
            return NO;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)isThisCourtExist:(NSNumber *)localCourtId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localCourtId = %@", localCourtId];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *objArr = [context executeFetchRequest:request error:&error];
        
        if ([objArr count] > 0)
            return YES;
        else
            return NO;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (Cases *)fetchCase:(NSNumber *)caseId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"caseId = %@", caseId];
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
+ (NSArray *)fetchCasesForAdmin
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSubordinate = %@ && isCaseDeleted = %@", @0, @0];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIcaseId ascending:NO];
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

+ (NSArray *)fetchNotSyncedCases
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSynced = %@ && isCaseDeleted = %@", @0, @0];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIcaseId ascending:NO];
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

+ (NSArray *)fetchDeletedNotSyncedClients
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSynced = %@ && isCaseDeleted = %@", @0, @1];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIcaseId ascending:NO];
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

+ (Cases *)fetchCaseLocally:(NSNumber *)localCaseId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSString *predicateString = [NSString stringWithFormat:@"localCaseId==\"%@\"", localCaseId];
        
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

+ (NSArray *)fetchCases:(NSNumber *)userId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
        [request setPredicate:predicate];
        
        //        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIdateTime ascending:NO];
        //        [request setSortDescriptors:@[sortDescriptor]];
        
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
+ (NSArray *)fetchCasesForAdmin:(NSNumber *)adminId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"adminId = %@ && isCaseDeleted = %@", adminId, @0];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIcaseId ascending:NO];
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
+ (void)saveCasesForSubordinate:(NSDictionary *)dataDict
{
    NSArray *arrCases = [[NSArray alloc] initWithArray:[dataDict objectForKey:kAPIdata]];
    
    for (NSDictionary *caseObj in arrCases) {
        [Cases saveCase:caseObj forSubordiante:YES withAdminDetail:dataDict];
    }
}

+ (NSArray *)fetchCasesForSubordinate
{
    @try {
        NSMutableArray *arrResult = [[NSMutableArray alloc] init];
        
        NSArray *admins = [SubordinateAdmin fetchSubordinateAdmins];
        
        for (SubordinateAdmin *adminObj in admins) {
            
            NSMutableDictionary *recordDict = [[NSMutableDictionary alloc] init];
            
            recordDict[kAPIadminData] = adminObj;
            recordDict[kAPIdata] = [Cases fetchCasesForAdmin:adminObj.adminId];
            
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

+ (NSArray *)fetchCasesWhichBelongsToThisCourt:(NSNumber *)localCourtId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
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

+ (NSArray *)fetchCaseWhichBelongsToThisClient:(NSNumber *)localClientId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSString *predicateString = [NSString stringWithFormat:@"localClientId==\"%@\"", localClientId];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [request setPredicate:predicate];
        
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

+ (BOOL)isAnyCaseNotSynced
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSString *predicateString = [NSString stringWithFormat:@"isSynced==\"%@\"", @0];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *objArr = [context executeFetchRequest:request error:&error];
        
        if ([objArr count] > 0)
            return YES;
        else
            return NO;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}


@end
