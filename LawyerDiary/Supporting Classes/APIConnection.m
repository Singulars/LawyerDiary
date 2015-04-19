//
//  APIConnection.m
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import "APIConnection.h"

@implementation APIConnection

@synthesize responseData;
@synthesize delegate;
@synthesize curAction;

#pragma mark - Initiate the request
- (id)initWithAction:(NSMutableDictionary *)params
{
    self = [super init];
    [self postRequestJSONData:params];
    
    return self;
}

- (id)initWithAction:(NSInteger)action withParmas:(NSDictionary *)params andMessage:(NSString *)message AndDelegate:(id<APIConnectionDelegate>)objDelegate
{
    self = [super init];
    self.curAction = action;
    self.delegate = objDelegate;
    
    
    return self;
}
- (id)initWithAction:(NSInteger)action withParmas:(NSDictionary *)params andMessage:(NSString *)message
{
    self = [super init];

    if(action == signUp)
    {
        [self postRequestJSONDataWithImage:params];
    }
    else
    {
        [self postRequestJSONData:params];
    }
    
    self.curAction = action;
    
    return self;
}

#pragma mark - POST Data With - JSON
#pragma mark -
- (void)postRequestJSONData:(NSDictionary *)postVars
{
    NSURL *url = [NSURL URLWithString:WEBSERVICE_CALL_URL];
    
    NSString *contentType = @"application/json";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSError *err = nil;
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:postVars options:NSJSONWritingPrettyPrinted error:&err];
    
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
    
    [request setTimeoutInterval:kRequestTimeOut];
    
    NSString *someString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    NSLog(@"Request Data - %@", someString);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)postRequestJSONDataWithImage:(NSDictionary *)postVars
{
    NSURL *url = [NSURL URLWithString:WEBSERVICE_CALL_URL];
    
    NSString *contentType = @"application/json";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSError *err = nil;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithDictionary:postVars];
    
    if ([postVars[kAPIproPic] isKindOfClass:[UIImage class]]) {
        NSData *dataImage = UIImageJPEGRepresentation([postVars objectForKey:kAPIproPic], 1.0f);
        [params setObject:[self base64forData:dataImage] forKey:kAPIproPic];
    }
    else {
        [params removeObjectForKey:kAPIproPic];
    }
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&err];
    
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
    
    [request setTimeoutInterval:kRequestTimeOut];
    
    NSString *someString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    NSLog(@"Request Data - %@", someString);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)postImage:(NSDictionary *)postVars
{
    
    NSURL *url = [NSURL URLWithString:WEBSERVICE_CALL_URL];
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSData *dataImage = UIImageJPEGRepresentation([postVars objectForKey:kAPIproPic], 1.0f);
    
    NSMutableData* body = [NSMutableData data];
    
    NSString* boundary = @"---------------------------14737809831466499882746641449";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    for(NSString *key in postVars)
    {
        if(![key isEqualToString:kAPIproPic])
        {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",[postVars valueForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    if([postVars objectForKey:kAPIproPic])
    {
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.jpg\"\r\n", @"profilepic"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:dataImage];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    
    [request setTimeoutInterval:kRequestTimeOut];
    
    NSURLConnection *cn = [NSURLConnection connectionWithRequest:request delegate:self];
    [cn start];
    
}


- (void)postAsyncRequestJSONData:(NSDictionary *)postVars
{
    NSURL *url = [NSURL URLWithString:WEBSERVICE_CALL_URL];
    
    NSString *contentType = @"application/json";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSError *err = nil;
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:postVars options:NSJSONWritingPrettyPrinted error:&err];
    
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
    
    [request setTimeoutInterval:kRequestTimeOut];
    
    NSString *someString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    NSLog(@"Request Data - %@", someString);
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *resData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response
                                                        error:&error];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (error) {
            
        }
        else{
            NSError *err = nil;
            NSDictionary *dictResponse = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&err]];
            NSLog(@"%@", dictResponse);
            if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_OK])
            {
                if([delegate respondsToSelector:@selector(connectionDidFinishedForAction:andWithResponse:)])
                {
                    [delegate performSelector:@selector(connectionDidFinishedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.curAction] withObject:dictResponse];
                }
            }
            else if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_ERR])
            {
                if([delegate respondsToSelector:@selector(connectionFailedForAction:andWithResponse:)])
                {
                    [delegate performSelector:@selector(connectionFailedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.curAction] withObject:dictResponse];
                }
            }
        }
    });
    
}

- (NSString*)base64forData:(NSData*)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger Datalength = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((Datalength + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < Datalength; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < Datalength) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < Datalength ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < Datalength ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - NSURLConnection Delegate
#pragma mark -
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error description]);
    if (self.curAction == 4) {
        ShareObj.isSearchingFriend = NO;
        [ShareObj.arrSearchedFriends removeAllObjects];
    }
    if([delegate respondsToSelector:@selector(connectionFailedForAction:andWithResponse:)])
    {
        [delegate performSelector:@selector(connectionFailedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.curAction] withObject:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *err = nil;
    
    NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:&err]];
    NSLog(@"%@", dictResponse);
    
    if ([dictResponse count] > 0) {
        if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_OK])
        {
            if([delegate respondsToSelector:@selector(connectionDidFinishedForAction:andWithResponse:)])
            {
                [delegate performSelector:@selector(connectionDidFinishedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.curAction] withObject:dictResponse];
            }
        }
        else if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_ERR])
        {
            if([delegate respondsToSelector:@selector(connectionFailedForAction:andWithResponse:)])
            {
                [delegate performSelector:@selector(connectionFailedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.curAction] withObject:dictResponse];
            }
        }
    }
    else
    {
        if([delegate respondsToSelector:@selector(connectionFailedForAction:andWithResponse:)])
        {
            [delegate performSelector:@selector(connectionFailedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.curAction] withObject:dictResponse];
        }
    }
}
@end
