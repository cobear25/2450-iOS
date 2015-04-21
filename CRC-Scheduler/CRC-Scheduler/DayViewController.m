//
//  DayViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/10/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "DayViewController.h"
#import "DayViewTableViewCell.h"
#import "Shift.h"
#import "Role.h"
#import "UIColor+CRCAdditions.h"

@interface DayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) NSInteger cellCount;

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.shifts = [[NSMutableArray alloc] init];
    self.cellCount = 48;
    self.tableView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.tableView registerNib:[UINib nibWithNibName:@"DayViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [self.tableView reloadData];
}

- (NSInteger)rowForTime:(NSInteger)hour Minute:(NSInteger)minute {
    BOOL firstHalfHour = YES;
    if (minute >= 30) {
        firstHalfHour = NO;
    }
    if (firstHalfHour) {
        return hour * 2;
    } else {
        return hour * 2 + 1;
    }
}

#pragma mark - TableView Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row % 2 == 0) {
        [cell.timeLabel setText:[NSString stringWithFormat:@"%ld:00", (long)indexPath.row/2]];
    } else {
        [cell.timeLabel setText:[NSString stringWithFormat:@"%ld:30", (long)indexPath.row/2]];
    }
//    cell.backgroundColor = [UIColor whiteColor];
    [cell.roleLabel setText:@""];
    for (Shift *shift in self.shifts) {
        NSDate *startdate = shift.startTime;
        NSDate *endDate = shift.endTime;
        NSTimeZone *tz = [NSTimeZone localTimeZone];
        NSDateFormatter *hourformatter = [[NSDateFormatter alloc] init];
        [hourformatter setDateFormat:@"HH"];
        [hourformatter setTimeZone:tz];

        NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc] init];
        [minuteFormatter setDateFormat:@"mm"];
        NSInteger startHour = [[hourformatter stringFromDate:startdate] integerValue];
        NSInteger startMinute = [[minuteFormatter stringFromDate:startdate] integerValue];

        NSInteger endHour = [[hourformatter stringFromDate:endDate] integerValue];
        NSInteger endMinute = [[minuteFormatter stringFromDate:endDate] integerValue];

        NSInteger roll = shift.role;
        Role *roleObject;
        if (shift.role) {
            roleObject = [self.roles objectAtIndex:roll - 1];
        } else {
            roleObject = [[Role alloc] init];
            roleObject.colorString = @"#ffffff";
            roleObject.title = @"Unknown Role";
            roleObject.descriptionString = @"";
        }

        if (indexPath.row >= [self rowForTime:startHour Minute:startMinute] && indexPath.row <= [self rowForTime:endHour Minute:endMinute]) {
            cell.backgroundColor = [UIColor colorFromHexString:roleObject.colorString];
            [cell.roleLabel setText:roleObject.title];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
            [cell.roleLabel setText:@""];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

@end
