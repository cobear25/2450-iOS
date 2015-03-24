//
//  WeekViewTableViewCell.h
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/19/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
