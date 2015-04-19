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
{
    NSMutableData *responseData;
    
    id <APIConnectionDelegate> delegate;
    NSInteger curAction;
}
@property (nonatomic, retain) NSMutableData *responseData;

@property (nonatomic, strong) id <APIConnectionDelegate> delegate;
@property (nonatomic, readwrite) NSInteger curAction;

#pragma mark - Initiate the request
- (id)initWithAction:(NSMutableDictionary *)params;
- (id)initWithAction:(NSInteger)action withParmas:(NSDictionary *)params andMessage:(NSString *)message;
- (id)initWithAction:(NSInteger)action withParmas:(NSDictionary *)params andMessage:(NSString *)message AndDelegate:(id<APIConnectionDelegate>)objDelegate;

#pragma mark - POST Data
- (void)postRequestJSONData:(NSDictionary *)postVars;
- (void)postRequestJSONDataWithImage:(NSDictionary *)postVars;
- (void)postAsyncRequestJSONData:(NSDictionary *)postVars;
@end
