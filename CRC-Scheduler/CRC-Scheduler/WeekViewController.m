//
//  WeekViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/17/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "WeekViewController.h"
#import "WeekViewTableViewCell.h"

@interface WeekViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation WeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    UIView *shift = [[UIView alloc] initWithFrame:CGRectMake(5, 0, cell.frame.size.width/2, cell.scrollView.frame.size.height)];
    shift.backgroundColor = [UIColor greenColor];

    UILabel *shiftLabel = [[UILabel alloc] initWithFrame:shift.frame];
    shiftLabel.text = @"5:00 - 9:30";
    [shift addSubview:shiftLabel];

    UIView *shift2 = [[UIView alloc] initWithFrame:CGRectMake(10 + shift.frame.size.width, 0, cell.frame.size.width/2, cell.scrollView.frame.size.height)];
    shift2.backgroundColor = [UIColor orangeColor];

    UILabel *shift2Label = [[UILabel alloc] initWithFrame:shift.frame];
    shift2Label.text = @"1:00 - 6:30";
    [shift2 addSubview:shift2Label];


    [cell.scrollView addSubview:shift];
    [cell.scrollView addSubview:shift2];
    CGSize newSize = cell.scrollView.frame.size;
    newSize.width *= 2;
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
