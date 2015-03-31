//
//  APIClient.h
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/24/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void(^APIClientErrorBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface APIClient : AFHTTPRequestOperationManager

- (void)logInWithUsername:(NSString *)username success:(void (^)())success
                  failure:(APIClientErrorBlock)failure;

- (void)getShiftsForUser:(NSInteger)userID;

- (void)getTokenForUsername:(NSString *)username Password:(NSString *)password;

@end
