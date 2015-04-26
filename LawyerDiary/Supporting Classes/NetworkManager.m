//
//  NetworkManager.m
//  LawyerDiary
//
//  Created by Verma Mukesh on 23/04/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (void)startPostOperationWithParams:(NSDictionary *)param success:(sucessCompletionHandler)successHandler failure:(failureCompletionHandler)failureHandler
{
    @try {
        NSLog(@"Request - %@", [param jsonStringWithPrettyPrint:YES]);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:WEBSERVICE_CALL_URL
           parameters:param
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"JSON: %@", responseObject);
                  successHandler(operation, responseObject);
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  failureHandler(operation, error);
              }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception - %@", [exception debugDescription]);
    }
    @finally {
        
    }
}

@end
