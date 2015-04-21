//
//  WeekViewController.h
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/17/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekViewController : UIViewController

@property (strong, nonatomic)NSMutableArray *shifts;
@property (strong, nonatomic)NSMutableArray *shiftDays;
@property (strong, nonatomic)NSMutableArray *roles;

@end
