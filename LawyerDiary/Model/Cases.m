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
@dynamic courtId;
@dynamic courtName;
@dynamic megistrateName;
@dynamic courtCity;
@dynamic clientId;
@dynamic clientFirstName;
@dynamic clientLastName;
@dynamic oppositionLawyerName;
@dynamic oppositionFirstName;
@dynamic oppositionLastName;
@dynamic caseNo;
@dynamic lastHeardDate;
@dynamic nextHearingDate;
@dynamic caseStatus;
@dynamic isCaseDeleted;
@dynamic isSynced;

+ (NSNumber *)generateID {
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithInteger:timeStamp];
    return timeStampObj;
}

+ (Cases *)saveCase:(NSDictionary *)dataDict forUser:(NSNumber *)userId
{
    @try {
        
        for (NSString *key in dataDict) {
//            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Cases *obj = [self fetchCaseLocally:@([[dataDict objectForKey:kAPIrandom] integerValue])];
        
        //        if ([dataDict objectForKey:kAPIclientId]) {
        //            obj = [self fetchClient:[dataDict objectForKey:kAPIcourtId]];
        //        }
        //        else if ([dataDict objectForKey:kAPIclientId]) {
        //            obj = [self fetchClient:[dataDict objectForKey:kAPIrandom]];
        //        }
        
        if (obj != nil) {
            @try {
                [obj setUserId:userId];
                [obj setLocalCaseId:[dataDict objectForKey:kAPIrandom] ? @([[dataDict objectForKey:kAPIrandom] integerValue]) : [Cases generateID]];
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
                [obj setLocalCaseId:[dataDict objectForKey:kAPIrandom] ? @([[dataDict objectForKey:kAPIrandom] integerValue]) : [Cases generateID]];
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
}

+ (Cases *)updateCase:(NSDictionary *)dataDict forUser:(NSNumber *)userId
{
    @try {
        
        for (NSString *key in dataDict) {
            //            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Cases *obj = [self fetchCaseLocally:@([[dataDict objectForKey:kAPIrandom] integerValue])];
        
        //        if ([dataDict objectForKey:kAPIclientId]) {
        //            obj = [self fetchClient:[dataDict objectForKey:kAPIcourtId]];
        //        }
        //        else if ([dataDict objectForKey:kAPIclientId]) {
        //            obj = [self fetchClient:[dataDict objectForKey:kAPIrandom]];
        //        }
        if (!obj) {
            @try {
                [obj setCaseId:dataDict[kAPIcaseId] ? @([[dataDict objectForKey:kAPIcaseId] integerValue]) : @-1];
                [obj setCourtId:dataDict[kAPIcourtId] ? @([[dataDict objectForKey:kAPIcourtId] integerValue]) : @-1];
                [obj setClientId:dataDict[kAPIclientId] ? @([[dataDict objectForKey:kAPIclientId] integerValue]) : @-1];
                
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

+ (BOOL)updatedCasePropertyofClient:(Cases *)caseObj withProperty:(CaseProperty)property andValue:(NSNumber *)propertyValue
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

+ (BOOL)deleteCaseForUser:(NSNumber *)userId {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kCases inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId = %@)", userId];
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

@end
