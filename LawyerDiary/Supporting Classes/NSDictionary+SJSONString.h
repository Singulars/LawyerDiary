//
//  NSDictionary+SJSONString.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 24/04/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SJSONString)
- (NSString*)jsonStringWithPrettyPrint:(BOOL)prettyPrint;
@end
