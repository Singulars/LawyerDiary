//
//  User.m
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/19/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic mobile;
@dynamic userId;
@dynamic birthdate;
@dynamic address;
@dynamic registrationNo;

+ (User *)saveUser:(NSDictionary *)dataDict {
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    
    User *obj = [self fetchUser:[dataDict objectForKey:kAPIuserId]];
    
    if (obj != nil) {
        @try {
            [obj setUserId:dataDict[kAPIuserId] ? dataDict[kAPIuserId] : @""];
            [obj setFirstName:dataDict[kAPIfirstName] ? dataDict[kAPIfirstName] : @""];
            [obj setLastName:dataDict[kAPIlastName] ? dataDict[kAPIlastName] : @""];
            [obj setEmail:dataDict[kAPIemail] ? dataDict[kAPIemail] : @""];
            [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
            [obj setBirthdate:dataDict[kAPIbirthdate] ? dataDict[kAPIbirthdate]: @""];
            [obj setAddress:dataDict[kAPIaddress] ? dataDict[kAPIaddress]: @""];
            [obj setRegistrationNo:dataDict[kAPIregistrationNo] ? dataDict[kAPIregistrationNo] : @""];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        obj = [NSEntityDescription insertNewObjectForEntityForName:kUser inManagedObjectContext:context];
        @try {
            [obj setUserId:dataDict[kAPIuserId] ? dataDict[kAPIuserId] : @""];
            [obj setFirstName:dataDict[kAPIfirstName] ? dataDict[kAPIfirstName] : @""];
            [obj setLastName:dataDict[kAPIlastName] ? dataDict[kAPIlastName] : @""];
            [obj setEmail:dataDict[kAPIemail] ? dataDict[kAPIemail] : @""];
            [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
            [obj setBirthdate:dataDict[kAPIbirthdate] ? dataDict[kAPIbirthdate]: @""];
            [obj setAddress:dataDict[kAPIaddress] ? dataDict[kAPIaddress]: @""];
            [obj setRegistrationNo:dataDict[kAPIregistrationNo] ? dataDict[kAPIregistrationNo] : @""];
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
        NSLog(@"User saved succesfully");
        return obj;
    }
    else {
        NSLog(@"User save failed! %@, %@", error, [error userInfo]);
        return nil;
    }
}

+ (BOOL)deleteUser:(NSString *)userId {
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    User *obj = [self fetchUser:userId];
    [context deleteObject:obj];
    
    NSError *error = nil;
    // Save the context.
    if ([context save:&error]) {
        NSLog(@"User deleted succesfully");
        return YES;
    }
    else {
        NSLog(@"User deletion failed! %@, %@", error, [error userInfo]);
        return YES;
    }
}

+ (User *)fetchUser:(NSString *)userId {
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kUser inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
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

@end
