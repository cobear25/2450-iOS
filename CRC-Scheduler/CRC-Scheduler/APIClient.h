//
//  APIClient.h
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/24/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface APIClient : AFHTTPRequestOperationManager

- (void)logIn;

@end
