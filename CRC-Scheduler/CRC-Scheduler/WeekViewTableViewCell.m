//
//  WeekViewTableViewCell.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/19/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "WeekViewTableViewCell.h"

@implementation WeekViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
