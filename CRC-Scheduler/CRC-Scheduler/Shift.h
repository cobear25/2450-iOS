//
//  Shift.h
//  CRC-Scheduler
//
//  Created by Cody Mace on 4/2/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shift : NSObject

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (assign, nonatomic) NSInteger role;
@property (assign, nonatomic) NSInteger user;

@end
