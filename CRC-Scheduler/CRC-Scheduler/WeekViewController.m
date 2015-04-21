//
//  WeekViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/17/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "WeekViewController.h"
#import "WeekViewTableViewCell.h"
#import "Shift.h"
#import "Role.h"
#import "UIColor+CRCAdditions.h"

@interface WeekViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation WeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.shifts = [[NSMutableArray alloc] init];
    self.shiftDays = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.tableView registerNib:[UINib nibWithNibName:@"WeekViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - TableView Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:
            cell.dayLabel.text = @"M O N";
            break;
        case 1:
            cell.dayLabel.text = @"T U E";
            break;
        case 2:
            cell.dayLabel.text = @"W E D";
            break;
        case 3:
            cell.dayLabel.text = @"T H U";
            break;
        case 4:
            cell.dayLabel.text = @"F R I";
            break;
        case 5:
            cell.dayLabel.text = @"S A T";
            break;
        case 6:
            cell.dayLabel.text = @"S U N";
            break;
        default:
            break;
    }
    int shiftCount = 0;
    for (int i = 0; i<self.shifts.count; i++) {
        if (indexPath.row == [[self.shiftDays objectAtIndex:i] intValue]) {
            Shift *shift = [self.shifts objectAtIndex:i];

            Role *role;
            if (shift.role) {
                role = [self.roles objectAtIndex:shift.role - 1];
            } else {
                role = [[Role alloc] init];
                role.colorString = @"#ffffff";
                role.title = @"Unknown Role";
                role.descriptionString = @"";
            }

            CGFloat shiftWidth = cell.frame.size.width;// - cell.frame.size.width/3;
            UIView *shiftView = [[UIView alloc] initWithFrame:CGRectMake(shiftCount * shiftWidth + (shiftCount+1)*5, 0, cell.frame.size.width, cell.scrollView.frame.size.height)];
            shiftView.backgroundColor = [UIColor colorFromHexString:role.colorString];
            
            UILabel *shiftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, shiftWidth/2, shiftView.frame.size.height)];
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"HH:mm"];
            NSString *startTime = [timeFormatter stringFromDate:shift.startTime];
            NSString *endTime = [timeFormatter stringFromDate:shift.endTime];

            shiftLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
            [shiftView addSubview:shiftLabel];

            UILabel *roleTitle = [[UILabel alloc] initWithFrame:CGRectMake(shiftWidth/2, 0, shiftWidth/2, shiftView.frame.size.height)];
            roleTitle.text = role.title;
            roleTitle.font = [UIFont systemFontOfSize:20];
            [shiftView addSubview:roleTitle];

            [cell.scrollView addSubview:shiftView];
            shiftCount += 1;
        }
    }
    CGSize newSize = cell.frame.size;
    newSize.width *= shiftCount;
    [cell.scrollView setContentSize:newSize];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

@end