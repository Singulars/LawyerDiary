//
//  Court.h
//  
//
//  Created by Verma Mukesh on 01/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

typedef NS_ENUM(NSUInteger, CourtProperty) {
    kCourtIsSynced = 0,
    kCourtIsDeleted
};

@interface Court : NSManagedObject

@property (nonatomic, retain) NSString * courtCity;
@property (nonatomic, retain) NSNumber * courtId;
@property (nonatomic, retain) NSString * courtName;
@property (nonatomic, retain) NSString * dateTime;
@property (nonatomic, retain) NSNumber * isCourtDeleted;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSNumber * localCourtId;
@property (nonatomic, retain) NSString * megistrateName;
@property (nonatomic, retain) NSNumber * userId;

+ (Court *)saveCourt:(NSDictionary *)dataDict forUser:(NSNumber *)userId;
+ (BOOL)updatedCourtPropertyofCourt:(Court *)courtObj withProperty:(CourtProperty)property andValue:(NSNumber *)propertyValue;
+ (BOOL)deleteCourt:(NSNumber *)courtId;
+ (BOOL)deleteCourtsForUser:(NSNumber *)userId;
+ (Court *)fetchCourt:(NSNumber *)courtId;
+ (NSArray *)fetchCourts:(NSNumber *)userId;

@end