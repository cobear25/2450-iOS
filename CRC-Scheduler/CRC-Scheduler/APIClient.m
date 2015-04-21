//
//  APIClient.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/24/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (instancetype)sharedClient
{
    static APIClient *_sharedClient;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* baseURL = @"http://cs2450-web.herokuapp.com";
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });

    return _sharedClient;
}

- (void)logInWithUsername:(NSString *)username success:(void (^)())success
                  failure:(APIClientErrorBlock)failure {
    NSDictionary *params = @{@"username": username};
    [self GET:@"http://cs2450-web.herokuapp.com/api/users/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
        {
            success();
        }
//        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        if (failure)
        {
            failure(operation, error);
        }
    }];
}

- (void)getShiftsOnSuccess:(void (^)(id json))success failure:(APIClientErrorBlock)failure {
    NSString *url = @"http://cs2450-web.herokuapp.com/api/shifts/";
    [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
//        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
        NSLog(@"Error: %@", error);
    }];
}

- (void)getTokenForUsername:(NSString *)username Password:(NSString *)password success:(void (^)())success failure:(APIClientErrorBlock)failure {
    NSDictionary *params = @{@"username": username, @"password": password};
    NSString *url = @"/accounts/token/get/";
    [self GET:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSString *token = [responseObject objectForKey:@"token"];
          [self.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
          if (success)
          {
              success();
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure)
          {
              failure(operation, error);
          }
      }];
}

- (void)getRoleForNumber:(NSInteger)number success:(void (^)(id json))success failure:(APIClientErrorBlock)failure {
    NSString *url = [NSString stringWithFormat:@"/api/roles/%ld", number];
    [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (void)getRoles:(void (^)(id json))success failure:(APIClientErrorBlock)failure {
    NSString *url = @"/api/roles/";
    [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}
@end
