//
//  EditDateViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 2/3/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "EditDateViewController.h"

@interface EditDateViewController()
@property (weak, nonatomic) IBOutlet UIDatePicker *firstDayDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *lastDayDatePicker;

@end

@implementation EditDateViewController

- (void)viewWillDisappear:(BOOL)animated {
    NSDate *startDate = self.firstDayDatePicker.date;
    NSDate *endDate = self.lastDayDatePicker.date;
    [[NSUserDefaults standardUserDefaults] setObject:startDate forKey:@"startDate"];
    [[NSUserDefaults standardUserDefaults] setObject:endDate forKey:@"endDate"];
}

@end
