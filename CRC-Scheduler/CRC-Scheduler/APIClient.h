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

+ (instancetype)sharedClient;

- (void)logInWithUsername:(NSString *)username success:(void (^)())success
                  failure:(APIClientErrorBlock)failure;

- (void)getShiftsOnSuccess:(void (^)(id json))success failure:(APIClientErrorBlock)failure;

- (void)getTokenForUsername:(NSString *)username Password:(NSString *)password success:(void (^)())success failure:(APIClientErrorBlock)failure;
- (void)getRoleForNumber:(NSInteger)number success:(void (^)(id json))success failure:(APIClientErrorBlock)failure;
- (void)getRoles:(void (^)(id json))success failure:(APIClientErrorBlock)failure;

@end
