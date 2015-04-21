//
//  DayViewController.h
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/10/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *shifts;
@property (strong, nonatomic)NSMutableArray *roles;
@end
