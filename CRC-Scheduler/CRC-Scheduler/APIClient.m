//
//  APIClient.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/24/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

- (void)logInWithUsername:(NSString *)username success:(void (^)())success
                  failure:(APIClientErrorBlock)failure {
    NSDictionary *params = @{@"username": username};
    [self GET:@"http://cs2450-web.herokuapp.com/api/users/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
        {
            success();
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure)
        {
            failure(operation, error);
        }
    }];
}

- (void)getShiftsForUser:(NSInteger)userID {
    NSDictionary *params = @{@"username": @"cmace"};
    NSString *url = [NSString stringWithFormat:@"http://cs2450-web.herokuapp.com/api/shifts/%ld/", (long)userID];
    [self GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getTokenForUsername:(NSString *)username Password:(NSString *)password {
    NSDictionary *params = @{@"username": username, @"password": password};
    NSString *url = @"http://cs2450-web.herokuapp.com/accounts/token/get/";
    [self GET:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
}
@end
