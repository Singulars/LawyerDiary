//
//  SharedManager.m
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import "SharedManager.h"
static SharedManager *sharedManager;

@implementation SharedManager

@synthesize loginuserId;
@synthesize serverDateTime;
@synthesize syncContactsDateTime;
@synthesize loginUserName;
@synthesize currentPassword;
@synthesize updatedPassword;
@synthesize deviceToken;
@synthesize searchStr;
@synthesize arrSearchedFriends;
@synthesize arrContacts;

@synthesize shouldDownloadImages;
@synthesize isInternetConnected;
@synthesize isSyncingContacts;
@synthesize isSyncingFriends;
@synthesize isLoadingFriendRequests;
@synthesize isSearchingFriend;

@synthesize fetchSubordinateStatus;
@synthesize hasAdminAccess;

+ (SharedManager *)sharedManger
{
    if(sharedManager == nil)
    {
        sharedManager = [[SharedManager alloc] init];
        
        sharedManager.shouldDownloadImages = YES;
        sharedManager.isInternetConnected = NO;
        sharedManager.isSyncingContacts = NO;
        sharedManager.isSyncingFriends = NO;
        sharedManager.isLoadingFriendRequests = NO;
        sharedManager.isSearchingFriend = NO;
        
        sharedManager.arrSearchedFriends = [[NSMutableArray alloc] init];
        sharedManager.arrContacts = [[NSMutableArray alloc] init];
        
        sharedManager.deviceToken = @"";
        
        sharedManager.fetchSubordinateStatus = kStatusUndetermined;
    }
    
    return sharedManager;
}

- (void)resetNotificationBadgeCount
{
    if(ShareObj.isInternetConnected)
    {
        @try {
            NSDictionary *postDataDict = @{kAPIMode: kresetNotificationCount,
                                           kAPIuserId: USER_ID
                                           };
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                
                // SEND REQUEST TO GET UPDATES
                
                NSURL *url = [NSURL URLWithString:WEBSERVICE_CALL_URL];
                
                NSString *contentType = @"application/json";
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setHTTPMethod:@"POST"];
                [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                NSError *err = nil;
                
                NSData *body = [NSJSONSerialization dataWithJSONObject:postDataDict options:NSJSONWritingPrettyPrinted error:&err];
                
                [request setHTTPBody:body];
                [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
                
                [request setTimeoutInterval:kRequestTimeOut];
                
                NSString *someString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                
                NSLog(@"Request Data - %@", someString);
                
                NSURLResponse *response = nil;
                NSError *error = nil;
                
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                             returningResponse:&response
                                                                         error:&error];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSError *err = nil;
                    
                    @try {
                        NSDictionary *dictResponse = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err]];
                        
                        NSLog(@"%@", dictResponse);
                        
                        if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_OK])
                        {
                            
                            
                            //                        [self performSelector:@selector(getCurrentServerDateTime) withObject:nil afterDelay:2];
                        }
                        else if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_ERR])
                        {
                            
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%s %@",__FUNCTION__, [exception debugDescription]);
                    }
                    @finally {
                    }
                });
            });
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

- (void)getCurrentServerDateTime
{
    if(ShareObj.isInternetConnected)
    {
        @try {
            NSDictionary *postDataDict = @{kAPIMode: kgetServerDateTime
                                           };
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                
                // SEND REQUEST TO GET UPDATES
                
                NSURL *url = [NSURL URLWithString:WEBSERVICE_CALL_URL];
                
                NSString *contentType = @"application/json";
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setHTTPMethod:@"POST"];
                [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                NSError *err = nil;
                
                NSData *body = [NSJSONSerialization dataWithJSONObject:postDataDict options:NSJSONWritingPrettyPrinted error:&err];
                
                [request setHTTPBody:body];
                [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
                
                [request setTimeoutInterval:kRequestTimeOut];
                
                NSString *someString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                
                NSLog(@"Request Data - %@", someString);
                
                NSURLResponse *response = nil;
                NSError *error = nil;
                
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                             returningResponse:&response
                                                                         error:&error];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSError *err = nil;
                    
                    @try {
                        NSDictionary *dictResponse = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err]];
                        
                        NSLog(@"%@", dictResponse);
                        
                        if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_OK])
                        {
                            self.serverDateTime = [dictResponse valueForKey:@"serverdatetime"];
                            
                            //                        [self performSelector:@selector(getCurrentServerDateTime) withObject:nil afterDelay:2];
                        }
                        else if([[dictResponse valueForKey:kAPIstatus] isEqualToString:RESPONSE_STATUS_ERR])
                        {
                            
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%s %@",__FUNCTION__, [exception debugDescription]);
                    }
                    @finally {
                    }
                });
            });
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}


- (void)fetchSubordinatesWithCompletionHandler:(void (^)(BOOL finished))completionHandler
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            NSDictionary *params = @{
                                     kAPIMode: kloadSubordinate,
                                     kAPIuserId: USER_ID
                                     };
            
            [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                RemoveHasAdminAccess;
                RemoveFetchSubordinateStatus;
                
                if (responseObject == nil) {
                    fetchSubordinateStatus = kStatusFailed;
                }
                else {
                    if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        fetchSubordinateStatus = kStatusFailed;
                    }
                    else {
                        NSArray *arrSubordinates = [responseObject valueForKey:kAPIsubordinateData];
                        
                        if (arrSubordinates.count > 0) {
                            
                            for (NSDictionary *obj in arrSubordinates) {
                                [Subordinate saveSubordinate:obj];
                            }
                            
                            Subordinate *obj = [Subordinate fetchSubordinateWhoHasAccess];
                            if (obj != nil) {
                                hasAdminAccess = NO;
                            }
                            else {
                                hasAdminAccess = YES;
                            }
                            
                            fetchSubordinateStatus = kStatusSuccess;
                        }
                        else {
                            hasAdminAccess = YES;
                            fetchSubordinateStatus = kStatusSuccess;
                        }
                        
                        SetHasAdminAccess(hasAdminAccess);
                    }
                }
                
                SetFetchSubordinateStatus(fetchSubordinateStatus);
                completionHandler(YES);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (error.code == kCFURLErrorTimedOut) {
                    fetchSubordinateStatus = kStatusFailedBecauseInternet;
                }
                else if (error.code == kCFURLErrorNetworkConnectionLost) {
                    fetchSubordinateStatus = kStatusFailedBecauseInternet;
                }
                else {
                    fetchSubordinateStatus = kStatusFailed;
                }
                
                SetFetchSubordinateStatus(fetchSubordinateStatus);
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
    else {
        fetchSubordinateStatus = kStatusFailedBecauseInternet;
        
        SetFetchSubordinateStatus(fetchSubordinateStatus);
    }
}

- (void)updateAdminAccessVariablesValue
{
    ShareObj.hasAdminAccess = GetHasAdminAccess;
    ShareObj.fetchSubordinateStatus = GetFetchSubordinateStatus;
}

- (void)saveProfileData:(NSDictionary *)params forAction:(NSInteger)action
{
    [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject == nil) {
            
        }
        else {
            if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                
            }
            else {
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error.code == kCFURLErrorTimedOut) {
            [Global showNotificationWithTitle:@"Profile update request timed out." titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else if (error.code == kCFURLErrorNetworkConnectionLost) {
            [Global showNotificationWithTitle:@"Profile update failed. Network connection lost!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
        else {
            [Global showNotificationWithTitle:@"Profile update failed. Try again later!" titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
        }
    }];
}

@end
