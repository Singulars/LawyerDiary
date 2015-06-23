//
//  Court.h
//  
//
//  Created by Verma Mukesh on 02/05/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, CourtProperty) {
    kCourtIsSynced = 0,
    kCourtIsDeleted
};

@interface Court : NSManagedObject

@property (nonatomic, retain) NSNumber * localCourtId;
@property (nonatomic, retain) NSNumber * courtId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * courtName;
@property (nonatomic, retain) NSString * courtCity;
@property (nonatomic, retain) NSString * megistrateName;
@property (nonatomic, retain) NSString * dateTime;
@property (nonatomic, readwrite) NSNumber * isSynced;
@property (nonatomic, readwrite) NSNumber * isDeleted;

+ (Court *)saveCourt:(NSDictionary *)dataDict forUser:(NSNumber *)userId;
+ (BOOL)updatedCourtProperty:(CourtProperty)property withValue:(NSNumber *)propertyValue;
+ (BOOL)deleteCourt:(NSNumber *)courtId;
+ (BOOL)deleteCourtsForUser:(NSNumber *)userId;
+ (Court *)fetchCourt:(NSNumber *)courtId;
+ (NSArray *)fetchCourts:(NSNumber *)userId;

@end
