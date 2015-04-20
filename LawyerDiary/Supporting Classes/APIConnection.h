//
//  APIConnection.h
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol APIConnectionDelegate <NSObject>

@optional

- (void)connectionFailedForAction:(NSNumber *)action andWithResponse:(NSDictionary *)result;
- (void)connectionDidFinishedForAction:(NSNumber *)action andWithResponse:(NSDictionary *)result;
- (void)connectionDidFinishWithNullValue:(NSNumber *)action;
@end

@interface APIConnection : NSURLConnection

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, readwrite) NSInteger action;
@property (nonatomic, strong) id<APIConnectionDelegate>delegate;

#pragma mark - Initiate the request
- (id)initWithAction:(NSInteger)apiAction andData:(NSDictionary *)dataDict;
#pragma mark - POST Data
- (void)postRequestJSONData:(NSDictionary *)postVars;
- (void)postRequestJSONDataWithImage:(NSDictionary *)postVars;
- (void)postAsyncRequestJSONData:(NSDictionary *)postVars;
@end
