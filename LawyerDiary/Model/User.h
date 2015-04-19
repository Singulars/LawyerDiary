//
//  User.h
//  LawyerDiary
//
//  Created by Naresh Kharecha on 4/19/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * birthdate;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * registrationNo;

+ (User *)saveUser:(NSDictionary *)dataDict;
+ (BOOL)deleteUser:(NSString *)userId;
+ (User *)fetchUser:(NSString *)userId;

@end
