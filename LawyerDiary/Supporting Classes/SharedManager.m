//
//  SharedManager.m
//  AnyWordz
//
//  Created by Singulars on 19/04/15.
//  Copyright (c) 2015 Singulars. All rights reserved.
//

#import "SharedManager.h"
#import "Court.h"
#import "Client.h"
#import "Cases.h"

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

- (void)syncUpdatedCourtRecords
{
    if (IS_INTERNET_CONNECTED) {
        @try {
            
            __block NSInteger notSyncedRecordCount = 0;
            
            NSArray *courts = [Court fetchNotSyncedCourts];
            
            if (courts.count > 0) {
                Court *courtObj = courts[notSyncedRecordCount];
                
                BOOL isForSubordinate = [courtObj.isSubordinate isEqualToNumber:@1];
                
                NSDictionary *params = @{
                                         kAPIMode: ksaveCourt,
                                         kAPIuserId: USER_ID,
                                         kAPIlocalCourtId: courtObj.localCourtId,
                                         kAPIcourtId: [courtObj.courtId isEqualToNumber:@-1] ? @"" : courtObj.courtId,
                                         kAPIcourtName: courtObj.courtName,
                                         kAPImegistrateName: courtObj.megistrateName,
                                         kAPIcourtCity: courtObj.courtCity,
                                         kAPIadminId: isForSubordinate ? courtObj.adminId : @0
                                         };
                
                [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if (responseObject == nil) {
                        
                    }
                    else {
                        if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                            [Global showNotificationWithTitle:[responseObject valueForKey:kAPImessage] titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                            //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                        }
                        else {
                            [Court saveCourt:responseObject[kAPIcourData] forSubordiante:isForSubordinate withAdminDetail:isForSubordinate ? @{
                                                                                                                                               kAPIadminId: courtObj.adminId,
                                                                                                                                               kAPIadminName: courtObj.adminName,
                                                                                                                                               kAPIhasAccess: courtObj.hasAccess
                                                                                                                                               } : nil];
                        }
                    }
                    
                    notSyncedRecordCount++;
                    
                    [self syncUpdatedCourtRecords];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    notSyncedRecordCount++;
                    
                    [self syncUpdatedCourtRecords];
                }];
            }
            else {
                [self syncDeletedCourtRecords];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
}

- (void)syncDeletedCourtRecords
{
    if (IS_INTERNET_CONNECTED) {
        @try {
            
            __block NSInteger notSyncedRecordCount = 0;
            
            NSArray *courts = [Court fetchDeletedNotSyncedCourts];
            
            if (courts.count > 0) {
                Court *courtObj = courts[notSyncedRecordCount];
                
                BOOL isForSubordinate = [courtObj.isSubordinate isEqualToNumber:@1];
                
                NSDictionary *params = @{
                                         kAPIMode: kdeleteCourt,
                                         kAPIuserId: USER_ID,
                                         kAPIcourtId: courtObj.courtId,
                                         kAPIadminId: isForSubordinate ? courtObj.adminId : @0
                                         };
                
                [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if (responseObject == nil) {
                        
                    }
                    else {
                        if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                            [Global showNotificationWithTitle:[responseObject valueForKey:kAPImessage] titleColor:WHITE_COLOR backgroundColor:APP_RED_COLOR forDuration:1];
                            //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                        }
                        else {
                            [Court deleteCourt:courtObj.courtId];
                        }
                    }
                    
                    notSyncedRecordCount++;
                    
                    [self syncDeletedCourtRecords];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    notSyncedRecordCount++;
                    
                    [self syncDeletedCourtRecords];
                }];
            }
            else {
                [self syncUpdatedClientRecords];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
}

- (void)syncUpdatedClientRecords
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            __block NSInteger notSyncedRecordCount = 0;
            
            NSArray *clients = [Client fetchNotSyncedClients];
            
            if (clients.count > 0) {
                Client *clientObj = clients[notSyncedRecordCount];
                
                BOOL isForSubordinate = [clientObj.isSubordinate isEqualToNumber:@1];
                
                NSDictionary *params = @{
                                         kAPIMode: ksaveClient,
                                         kAPIuserId: USER_ID,
                                         kAPIlocalClientId: clientObj.localClientId,
                                         kAPIclientId: [clientObj.clientId isEqualToNumber:@-1] ? @"" : clientObj.clientId,
                                         kAPIclientFirstName: clientObj.clientFirstName,
                                         kAPIclientLastName: clientObj.clientLastName,
                                         kAPIemail: clientObj.email,
                                         kAPImobile: clientObj.mobile,
                                         kAPIaddress: clientObj.address,
                                         kAPIadminId: isForSubordinate ? clientObj.adminId : @0
                                         };
                
                [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if (responseObject == nil) {
                        
                    }
                    else {
                        if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                            
                            //                        UI_ALERT(@"ERROR", [responseObject valueForKey:kAPImessage], nil);
                        }
                        else {
                            //[Client saveClient:responseObject[kAPIclientData] forUser:USER_ID];
                            [Client saveClients:responseObject[kAPIclientData] forSubordiante:isForSubordinate withAdminDetail:isForSubordinate ? @{
                                                                                                                                                    kAPIadminId: clientObj.adminId,
                                                                                                                                                    kAPIadminName: clientObj.adminName,
                                                                                                                                                    kAPIhasAccess: clientObj.hasAccess
                                                                                                                                                    } : nil];
                        }
                    }
                    
                    notSyncedRecordCount++;
                    
                    [self syncUpdatedClientRecords];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    notSyncedRecordCount++;
                    
                    [self syncUpdatedClientRecords];
                    
                }];
            }
            else {
                [self syncDeletedClientRecords];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
}

- (void)syncDeletedClientRecords
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            __block NSInteger notSyncedRecordCount = 0;
            
            NSArray *clients = [Court fetchDeletedNotSyncedCourts];
            
            if (clients.count > 0) {
                Client *clientObj = clients[notSyncedRecordCount];
                
                BOOL isForSubordinate = [clientObj.isSubordinate isEqualToNumber:@1];
                
                NSDictionary *params = @{
                                         kAPIMode: kdeleteClient,
                                         kAPIuserId: USER_ID,
                                         kAPIclientId: clientObj.clientId,
                                         kAPIadminId: isForSubordinate ? clientObj.adminId : @0
                                         };
                
                [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if (responseObject == nil) {
                        
                    }
                    else {
                        if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                            
                        }
                        else {
                            [Client deleteClient:clientObj.clientId];
                        }
                    }
                    
                    notSyncedRecordCount++;
                    
                    [self syncDeletedClientRecords];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    notSyncedRecordCount++;
                    
                    [self syncDeletedClientRecords];
                }];
            }
            else {
                [self syncUpdatedCaseRecords];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
}

- (void)syncUpdatedCaseRecords
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            __block NSInteger notSyncedRecordCount = 0;
            
            NSArray *cases = [Cases fetchNotSyncedCases];
            
            if (cases.count > 0) {
                Cases *caseObj = cases[notSyncedRecordCount];
                
                BOOL isForSubordinate = [caseObj.isSubordinate isEqualToNumber:@1];
                
                NSDictionary *params = @{
                                         kAPIMode: ksaveCase,
                                         kAPIuserId: USER_ID,
                                         kAPIlocalCaseId: caseObj.localCaseId,
                                         kAPIcaseId: [caseObj.caseId isEqualToNumber:@-1] ? @"" : caseObj.caseId,
                                         kAPIcaseNo: caseObj.caseNo,
                                         kAPIlastHeardDate: caseObj.lastHeardDate,
                                         kAPInextHearingDate: caseObj.nextHearingDate,
                                         kAPIcaseStatus: caseObj.caseStatus,
                                         kAPIlocalClientId: caseObj.localClientId,
                                         kAPIclientId: caseObj.clientId,
                                         kAPIclientFirstName: caseObj.clientFirstName,
                                         kAPIclientLastName: caseObj.clientLastName,
                                         kAPImobile: caseObj.mobile,
                                         kAPIemail: @"",
                                         kAPIaddress: @"",
                                         kAPIoppositionFirstName: caseObj.oppositionFirstName,
                                         kAPIoppositionLastName: caseObj.oppositionLastName,
                                         kAPIoppositionLawyerName: caseObj.oppositionLawyerName,
                                         kAPIlocalCourtId: caseObj.localCourtId,
                                         kAPIcourtId: caseObj.courtId,
                                         kAPIcourtName: caseObj.courtName,
                                         kAPImegistrateName: caseObj.megistrateName,
                                         kAPIcourtCity: caseObj.courtCity,
                                         kAPIadminId: isForSubordinate ? caseObj.adminId : @0
                                         };
                
                NSLog(@"%@", params);
                
                [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if (responseObject == nil) {
                    
                    }
                    else {
                        if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                    
                        }
                        else {
                            [Cases updateCase:responseObject forUser:USER_ID];
                        }
                    }
                    
                    notSyncedRecordCount++;
                    
                    [self syncUpdatedCaseRecords];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    notSyncedRecordCount++;
                    
                    [self syncUpdatedCaseRecords];
                    
                }];
            }
            else {
                [self syncDeletedCaseRecords];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
        }
        @finally {
            
        }
    }
}

- (void)syncDeletedCaseRecords
{
    if (IS_INTERNET_CONNECTED) {
        
        @try {
            
            __block NSInteger notSyncedRecordCount = 0;
            
            NSArray *cases = [Cases fetchDeletedNotSyncedClients];
            
            if (cases.count > 0) {
                Cases *caseObj = cases[notSyncedRecordCount];
                
                BOOL isForSubordinate = [caseObj.isSubordinate isEqualToNumber:@1];
                
                NSDictionary *params = @{
                                         kAPIMode: kdeleteCase,
                                         kAPIuserId: USER_ID,
                                         kAPIcaseId: caseObj.caseId,
                                         kAPIadminId: isForSubordinate ? caseObj.adminId : @0
                                         };
                
                [NetworkManager startPostOperationWithParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if (responseObject == nil) {
                        
                    }
                    else {
                        if ([responseObject[kAPIstatus] isEqualToString:@"0"]) {
                        
                        }
                        else {
                            [Cases deleteCase:caseObj.caseId];
                        }
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception => %@", [exception debugDescription]);
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
                
                [self updateAdminAccessVariablesValue];
                
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
                
                [self updateAdminAccessVariablesValue];
                
                completionHandler(YES);
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
        
        [self updateAdminAccessVariablesValue];
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
