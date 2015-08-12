//
//  SubordinateAdmin.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 08/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubordinateAdmin : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *adminId;
@property (nullable, nonatomic, retain) NSString *adminName;
@property (nullable, nonatomic, retain) NSNumber *hasAccess;

+ (SubordinateAdmin *)saveSubordinateAdmin:(NSDictionary *)dataDict;
+ (BOOL)updateAccessForAdmin:(NSNumber *)adminId withValue:(NSNumber *)value;
+ (BOOL)deleteSubordinate:(NSNumber *)adminId;
+ (BOOL)deleteSubordinateAdmins;
+ (SubordinateAdmin *)fetchSubordinateAdmin:(NSNumber *)adminId;
+ (NSArray *)fetchSubordinateAdmins;

+ (SubordinateAdmin *)fetchAdminWhoHasGivenAccess;

@end

NS_ASSUME_NONNULL_END

