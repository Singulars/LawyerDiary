//
//  APIConnection.m
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import "APIConnection.h"

@implementation APIConnection

@synthesize connection;
@synthesize receivedData;
@synthesize action;
@synthesize delegate;

#pragma mark - Initiate the request
- (id)initWithAction:(NSInteger)apiAction andData:(NSDictionary *)dataDict
{
    self = [super init];
    if (self) {
        action = apiAction;
        
        switch (action) {
//            case SignUp:
//                [self postDataWithImage:dataDict];
//                break;
//            default:
//                [self postJSONData:dataDict];
//                break;
        }
        
    }
    return self;
}


#pragma mark - Post Data - JSON
#pragma mark -
- (void)postJSONData:(NSDictionary *)dataDict
{
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:WEBSERVICE_CALL_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    request.timeoutInterval = 60.0;
    
    NSLog(@"%@", WEBSERVICE_CALL_URL);
    
    NSLog(@"Request : %@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark - Post Data With Image - JSON
#pragma mark -
- (void)postDataWithImage:(NSDictionary *)dataDict
{
    NSMutableDictionary *mutableDataDict = [[NSMutableDictionary alloc] initWithDictionary:dataDict];
    
    BOOL imageFound = NO;
    for (NSString *key in mutableDataDict) {
        if ([mutableDataDict[key] isKindOfClass:[UIImage class]]) {
            imageFound = YES;
            break;
        }
    }
    
    if (imageFound) {
        NSString *base64Str = [Global encodeToBase64String:mutableDataDict[kAPIproPic]];
        [mutableDataDict setObject:base64Str forKey:kAPIproPic];
    }
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mutableDataDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:WEBSERVICE_CALL_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    request.timeoutInterval = 60.0;
    
    NSLog(@"%@", WEBSERVICE_CALL_URL);
    
    NSLog(@"Request : %@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    if([delegate respondsToSelector:@selector(connectionFailedForAction:andWithResponse:)])
    {
        [delegate performSelector:@selector(connectionFailedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.action] withObject:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *err = nil;
    
    NSDictionary *dictResponse = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingAllowFragments error:&err]];
    NSLog(@"%@", dictResponse);
    
    if ([dictResponse count] > 0) {
        if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_OK])
        {
            if([delegate respondsToSelector:@selector(connectionDidFinishedForAction:andWithResponse:)])
            {
                [delegate performSelector:@selector(connectionDidFinishedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.action] withObject:dictResponse];
            }
        }
        else if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_ERR])
        {
            if([delegate respondsToSelector:@selector(connectionFailedForAction:andWithResponse:)])
            {
                [delegate performSelector:@selector(connectionFailedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.action] withObject:dictResponse];
            }
        }
    }
    else
    {
        if([delegate respondsToSelector:@selector(connectionFailedForAction:andWithResponse:)])
        {
            [delegate performSelector:@selector(connectionFailedForAction:andWithResponse:) withObject:[NSNumber numberWithInteger:self.action] withObject:dictResponse];
        }
    }
}
@end
