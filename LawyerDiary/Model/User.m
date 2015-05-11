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
@dynamic isVerified;
@synthesize proPic;

+ (User *)saveUser:(NSDictionary *)dataDict {
    @try {
        
        for (NSString *key in dataDict) {
            NSLog(@"%@ - %@", key, [[dataDict objectForKey:key] class]);
        }
        
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        
        User *obj = [self fetchUser:[dataDict objectForKey:kAPIuserId]];
        
        if (obj != nil) {
            @try {
                [obj setUserId:dataDict[kAPIuserId] ? dataDict[kAPIuserId] : !USER_ID ? @0 : USER_ID];
                [obj setFirstName:dataDict[kAPIfirstName] ? dataDict[kAPIfirstName] : @""];
                [obj setLastName:dataDict[kAPIlastName] ? dataDict[kAPIlastName] : @""];
                [obj setEmail:dataDict[kAPIemail] ? dataDict[kAPIemail] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setBirthdate:dataDict[kAPIbirthdate] ? [Global getDateStringOfFormat:DefaultBirthdateFormat fromDateString:dataDict[kAPIbirthdate] ofFormat:ServerBirthdateFormat] : @""];
                [obj setAddress:dataDict[kAPIaddress] ? dataDict[kAPIaddress]: @""];
                [obj setRegistrationNo:dataDict[kAPIregistrationNo] ? dataDict[kAPIregistrationNo] : @""];
                [obj setIsVerified:[obj.isVerified isEqualToNumber:@0] || [obj.isVerified isEqualToNumber:@1] ? obj.isVerified : dataDict[kAPIisVerified] ? dataDict[kAPIisVerified] : @3];
                [obj setProPic:NSStringf(@"%@_%@", obj.userId, obj.firstName)];
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
                [obj setUserId:dataDict[kAPIuserId] ? dataDict[kAPIuserId] : @0];
                [obj setFirstName:dataDict[kAPIfirstName] ? dataDict[kAPIfirstName] : @""];
                [obj setLastName:dataDict[kAPIlastName] ? dataDict[kAPIlastName] : @""];
                [obj setEmail:dataDict[kAPIemail] ? dataDict[kAPIemail] : @""];
                [obj setMobile:dataDict[kAPImobile] ? dataDict[kAPImobile] : @""];
                [obj setBirthdate:dataDict[kAPIbirthdate] ? [Global getDateStringOfFormat:DefaultBirthdateFormat fromDateString:dataDict[kAPIbirthdate] ofFormat:ServerBirthdateFormat]: @""];
                [obj setAddress:dataDict[kAPIaddress] ? dataDict[kAPIaddress]: @""];
                [obj setRegistrationNo:dataDict[kAPIregistrationNo] ? dataDict[kAPIregistrationNo] : @""];
                [obj setIsVerified:dataDict[kAPIisVerified] ? dataDict[kAPIisVerified] : @3];
                [obj setProPic:NSStringf(@"%@_%@", obj.userId, obj.firstName)];
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
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (BOOL)deleteUser:(NSNumber *)userId {
    @try {
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
    @catch (NSException *exception) {
        NSLog(@"Exception => %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

+ (User *)fetchUser:(NSNumber *)userId {
    @try {
        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kUser inManagedObjectContext:context];
        
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

@end
