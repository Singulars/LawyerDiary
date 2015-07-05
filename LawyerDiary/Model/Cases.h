//
//  Cases.h
//  
//
//  Created by Verma Mukesh on 01/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client, Court;

@interface Cases : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * localCaseId;
@property (nonatomic, retain) NSNumber * caseId;
@property (nonatomic, retain) NSNumber * courtId;
@property (nonatomic, retain) NSNumber * clientId;
@property (nonatomic, retain) NSString * oppositionLawyerName;
@property (nonatomic, retain) NSString * oppositionFirstName;
@property (nonatomic, retain) NSString * oppositionLastName;
@property (nonatomic, retain) NSString * caseNo;
@property (nonatomic, retain) NSString * lastHeardDate;
@property (nonatomic, retain) NSString * nextHearingDate;
@property (nonatomic, retain) NSString * caseStatus;
@property (nonatomic, retain) NSNumber * isCaseDeleted;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSSet *clientDetails;
@property (nonatomic, retain) NSSet *courtDetails;
@end

@interface Cases (CoreDataGeneratedAccessors)

- (void)addClientDetailsObject:(Client *)value;
- (void)removeClientDetailsObject:(Client *)value;
- (void)addClientDetails:(NSSet *)values;
- (void)removeClientDetails:(NSSet *)values;

- (void)addCourtDetailsObject:(Court *)value;
- (void)removeCourtDetailsObject:(Court *)value;
- (void)addCourtDetails:(NSSet *)values;
- (void)removeCourtDetails:(NSSet *)values;

@end
