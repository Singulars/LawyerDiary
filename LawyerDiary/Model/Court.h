//
//  Court.h
//  
//
//  Created by Verma Mukesh on 02/05/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Court : NSManagedObject

@property (nonatomic, retain) NSNumber * courtId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * courtName;
@property (nonatomic, retain) NSString * courtCity;
@property (nonatomic, retain) NSString * megistrateName;
@property (nonatomic, retain) NSString * dateTime;

+ (Court *)saveCourt:(NSDictionary *)dataDict forUser:(NSNumber *)userId;
+ (BOOL)deleteCourt:(NSNumber *)courtId;
+ (BOOL)deleteCourtsForUser:(NSNumber *)userId;
+ (Court *)fetchCourt:(NSNumber *)courtId;
+ (NSArray *)fetchCourts:(NSNumber *)userId;

@end
