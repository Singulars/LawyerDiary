//
//  Client.m
//  
//
//  Created by Verma Mukesh on 01/07/15.
//
//

#import "Client.h"
#import "Cases.h"


@implementation Client

@dynamic userId;
@dynamic localClientId;
@dynamic address;
@dynamic clientFirstName;
@dynamic clientId;
@dynamic clientLastName;
@dynamic email;
@dynamic mobile;
@dynamic taskPlannerId;
@dynamic isTaskPlanner;
@dynamic isClientDeleted;
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

+ (Client *)saveClients:(NSDictionary *)dataDict forSubordiante:(BOOL)flag withAdminDetail:(NSDictionary *)adminDetail;
{
    @try {
        
        for (NSString *key in dataDict) {
            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        Client *obj = [self fetchClientLocally:@([[dataDict objectForKey:kAPIlocalClientId] integerValue])];
        
//        if ([dataDict objectForKey:kAPIclientId]) {
//            obj = [self fetchClient:[dataDict objectForKey:kAPIcourtId]];
//        }
//        else if ([dataDict objectForKey:kAPIclientId]) {
//            obj = [self fetchClient:[dataDict objectForKey:kAPIrandom]];
//        }
        
        if (obj != nil) {
            @try {
                [obj setUserId:USER_ID];
                [obj setLocalClientId:[dataDict objectForKey:kAPIlocalClientId] ? @([[dataDict objectForKey:kAPIlocalClientId] integerValue]) : [Client generateID]];
                [obj setClientId:dataDict[kAPIclientId] ? @([[dataDict objectForKey:kAPIclientId] integerValue]) : @-1];
                [obj setClientFirstName:dataDict[kAPIclientFirstName] ? dataDict[kAPIclientFirstName] : @""];
                [obj setClientLastName:dataDict[kAPIclientLastName] ? dataDict[kAPIclientLastName] : @""];
                [obj setEmail:dataDict[kAPIemail] ? dataDict[kAPIemail] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setAddress:dataDict[kAPIaddress] ? dataDict[kAPIaddress] : @""];
                [obj setTaskPlannerId:dataDict[kAPItaskPlannerId] ? @([[dataDict objectForKey:kAPItaskPlannerId] integerValue]) : @-1];
                [obj setIsTaskPlanner:dataDict[kAPIisTaskPlanner] ? @([[dataDict objectForKey:kAPIisTaskPlanner] integerValue]) : @-1];
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
            obj = [NSEntityDescription insertNewObjectForEntityForName:kClient inManagedObjectContext:context];
            @try {
                [obj setUserId:USER_ID];
                [obj setLocalClientId:[dataDict objectForKey:kAPIlocalClientId] ? @([[dataDict objectForKey:kAPIlocalClientId] integerValue]) : [self generateID]];
                [obj setClientId:dataDict[kAPIclientId] ? @([[dataDict objectForKey:kAPIclientId] integerValue]) : @-1];
                [obj setClientFirstName:dataDict[kAPIclientFirstName] ? dataDict[kAPIclientFirstName] : @""];
                [obj setClientLastName:dataDict[kAPIclientLastName] ? dataDict[kAPIclientLastName] : @""];
                [obj setEmail:dataDict[kAPIemail] ? dataDict[kAPIemail] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setAddress:dataDict[kAPIaddress] ? dataDict[kAPIaddress] : @""];
                [obj setTaskPlannerId:dataDict[kAPItaskPlannerId] ? @([[dataDict objectForKey:kAPItaskPlannerId] integerValue]) : @-1];
                [obj setIsTaskPlanner:dataDict[kAPIisTaskPlanner] ? @([[dataDict objectForKey:kAPIisTaskPlanner] integerValue]) : @-1];
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
            NSLog(@"Client saved succesfully");
            return obj;
        }
        else {
            NSLog(@"Client save failed! %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)updatedClientPropertyofClient:(Client *)clientObj withProperty:(ClientProperty)property andValue:(NSNumber *)propertyValue
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        switch (property) {
            case kClientIsDeleted: {
                [clientObj setIsClientDeleted:propertyValue];
            }
                break;
            case kClientIsSynced: {
                [clientObj setIsSynced:propertyValue];
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
+ (BOOL)saveClientsForSubordinate:(NSDictionary *)dataDict
{
    BOOL result = NO;
    
    NSArray *arrClients = [[NSArray alloc] initWithArray:[dataDict objectForKey:kAPIdata]];
    
    for (NSDictionary *courtObj in arrClients) {
        if ([Client saveClients:courtObj forSubordiante:YES withAdminDetail:dataDict]) {
            result = YES;
        }
        else {
            return result;
        }
    }
    
    return result;
}

+ (BOOL)deleteClient:(NSNumber *)clientId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        Client *obj = [self fetchClient:clientId];
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

+ (BOOL)deleteCientsForUser:(NSNumber *)userId {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
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
            NSLog(@"Client Deleted Succesfully!");
            return YES;
        } else {
            NSLog(@"Client Deletion Failed : %@", [error userInfo]);
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
    }
}

+ (Client *)fetchClient:(NSNumber *)clientId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clientId = %@", clientId];
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
+ (NSArray *)fetchClientsForAdmin
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSubordinate = %@ && isClientDeleted = %@", @0, @0];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIclientId ascending:NO];
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

+ (NSArray *)fetchClientsForAdmin:(NSNumber *)adminId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"adminId = %@ && isClientDeleted = %@", adminId, @0];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kAPIclientId ascending:NO];
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

+ (Client *)fetchClientLocally:(NSNumber *)localClientId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        
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

+ (NSArray *)fetchClients:(NSNumber *)userId
{
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kClient inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setReturnsObjectsAsFaults:NO];
        
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ && isClientDeleted = %@", userId, @0];
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
+ (NSArray *)fetchClientsForSubordinate
{
    @try {
        NSMutableArray *arrResult = [[NSMutableArray alloc] init];
        
        NSArray *admins = [SubordinateAdmin fetchSubordinateAdmins];
        
        for (SubordinateAdmin *adminObj in admins) {
            
            NSMutableDictionary *recordDict = [[NSMutableDictionary alloc] init];
            
            recordDict[kAPIadminData] = adminObj;
            recordDict[kAPIdata] = [Client fetchClientsForAdmin:adminObj.adminId];
            
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
