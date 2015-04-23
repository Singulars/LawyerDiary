//
//  NetworkManager.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 23/04/15.
//  Copyright (c) 2015 Singularsllp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^sucessCompletionHandler)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^failureCompletionHandler)(AFHTTPRequestOperation *operation, NSError *error);

@interface NetworkManager : NSObject

+ (void)startPostOperationWithParams:(NSDictionary *)param success:(sucessCompletionHandler)successHandler failure:(failureCompletionHandler)failureHandler;

@end
