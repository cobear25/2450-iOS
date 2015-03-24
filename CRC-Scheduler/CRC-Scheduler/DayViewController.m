//
//  DayViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 3/10/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "DayViewController.h"
#import "DayViewTableViewCell.h"

@interface DayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger cellCount;

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cellCount = 48;
    self.tableView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.tableView registerNib:[UINib nibWithNibName:@"DayViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"moved to parent");
}

#pragma mark - TableView Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row % 2 == 0) {
        [cell.timeLabel setText:[NSString stringWithFormat:@"%ld:00", (long)indexPath.row/2]];
    } else {
        [cell.timeLabel setText:[NSString stringWithFormat:@"%ld:30", (long)indexPath.row/2]];
    }
    if (indexPath.row >= 5 && indexPath.row < 13) {
        cell.backgroundColor = [UIColor orangeColor];
        [cell.roleLabel setText:@"Role 1"];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        [cell.roleLabel setText:@""];
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
