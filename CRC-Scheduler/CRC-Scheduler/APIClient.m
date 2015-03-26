//
//  APIClient.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/24/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

- (void)logIn {
    NSDictionary *params = @{@"username": @"cmace"};
    [self GET:@"http://cs2450-web.herokuapp.com/api/users/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
@end
