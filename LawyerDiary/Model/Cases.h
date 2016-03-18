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

typedef NS_ENUM(NSUInteger, CaseProperty) {
    kCaseIsSynced = 0,
    kCaseIsDeleted
};

@interface Cases : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * localCaseId;
@property (nonatomic, retain) NSNumber * caseId;
@property (nonatomic, retain) NSNumber * localCourtId;
@property (nonatomic, retain) NSNumber * courtId;
@property (nonatomic, retain) NSString * courtName;
@property (nonatomic, retain) NSString * megistrateName;
@property (nonatomic, retain) NSString * courtCity;
@property (nonatomic, retain) NSNumber * localClientId;
@property (nonatomic, retain) NSNumber * clientId;
@property (nonatomic, retain) NSString * clientFirstName;
@property (nonatomic, retain) NSString * clientLastName;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * oppositionLawyerName;
@property (nonatomic, retain) NSString * oppositionFirstName;
@property (nonatomic, retain) NSString * oppositionLastName;
@property (nonatomic, retain) NSString * caseNo;
@property (nonatomic, retain) NSString * lastHeardDate;
@property (nonatomic, retain) NSString * nextHearingDate;
@property (nonatomic, retain) NSString * caseStatus;
@property (nonatomic, retain) NSNumber * isCaseDeleted;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSNumber * adminId;
@property (nonatomic, retain) NSString * adminName;
@property (nonatomic, retain) NSNumber * hasAccess;
@property (nonatomic, retain) NSNumber * isSubordinate;

+ (Cases *)saveCase:(NSDictionary *)dataDict forSubordiante:(BOOL)flag withAdminDetail:(NSDictionary *)adminDetail;
//+ (Cases *)saveCase:(NSDictionary *)dataDict forUser:(NSNumber *)userId;
+ (Cases *)updateCase:(NSDictionary *)dataDict forUser:(NSNumber *)userId;
+ (BOOL)updatedCasePropertyofCase:(Cases *)caseObj withProperty:(CaseProperty)property andValue:(NSNumber *)propertyValue;
+ (BOOL)deleteCase:(NSNumber *)caseId;
+ (BOOL)deleteCaseForAdmin;
+ (BOOL)deleteCaseForSubordinate;
+ (BOOL)deleteCaseForAdmin:(NSNumber *)adminId;
+ (void)saveCasesForSubordinate:(NSDictionary *)dataDict;
+ (Cases *)fetchCase:(NSNumber *)caseId;
+ (NSArray *)fetchCases:(NSNumber *)userId;
+ (NSArray *)fetchCasesForAdmin;
+ (NSArray *)fetchCasesForSubordinate;
+ (NSArray *)fetchCasesForAdmin:(NSNumber *)adminId;

+ (NSArray *)fetchDeletedNotSyncedCases;
+ (NSArray *)fetchNotSyncedCases;

+ (BOOL)isThisClientExist:(NSNumber *)localClientId;
+ (BOOL)isThisCourtExist:(NSNumber *)localCourtId;

+ (NSArray *)fetchCasesWhichBelongsToThisCourt:(NSNumber *)localCourtId;
+ (NSArray *)fetchCaseWhichBelongsToThisClient:(NSNumber *)localClientId;

+ (BOOL)isAnyCaseNotSynced;

@end