//
//  Client.h
//  
//
//  Created by Verma Mukesh on 11/05/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Client : NSManagedObject

@property (nonatomic, retain) NSNumber * clientId;
@property (nonatomic, retain) NSString * clientFirstName;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * clientLastName;
@property (nonatomic, retain) NSString * oppositionFirstName;
@property (nonatomic, retain) NSString * oppositionLastName;
@property (nonatomic, retain) NSString * oppositionLawyerName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * courtId;
@property (nonatomic, retain) NSString * lastHeardDate;
@property (nonatomic, retain) NSString * nextHearingDate;
@property (nonatomic, retain) NSNumber * caseNo;
@property (nonatomic, retain) NSString * address;

@end
