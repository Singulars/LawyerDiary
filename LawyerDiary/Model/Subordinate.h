//
//  Subordinate.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 05/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Subordinate : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSNumber *hasAccess;
@property (nullable, nonatomic, retain) NSNumber *isProfile;

+ (Subordinate *)saveSubordinate:(NSDictionary *)dataDict;
+ (BOOL)updateAccessForUser:(NSNumber *)userId withValue:(NSNumber *)value;
+ (BOOL)deleteSubordinate:(NSNumber *)userId;
+ (BOOL)deleteSubordinates;
+ (Subordinate *)fetchSubordinate:(NSNumber *)userId;
+ (NSArray *)fetchSubordinates;

@end

NS_ASSUME_NONNULL_END

