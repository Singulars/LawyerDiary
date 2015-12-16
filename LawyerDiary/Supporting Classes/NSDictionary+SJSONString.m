//
//  NSDictionary+SJSONString.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 24/04/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "NSDictionary+SJSONString.h"

@implementation NSDictionary (SJSONString)

- (NSString*)jsonStringWithPrettyPrint:(BOOL)prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
