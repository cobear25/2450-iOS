//
//  ScheduleViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 1/21/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "ScheduleViewController.h"
#import "UIColor+CRCAdditions.h"

@interface ScheduleViewController()
@property (weak, nonatomic) IBOutlet UIView *greenUnderbar;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *scheduleView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor CRCGreenColor], NSForegroundColorAttributeName, nil];

    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Requests >" style:UIBarButtonItemStyleDone target:self action:@selector(requestButtonTapped)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor CRCGreenColor];

    UITapGestureRecognizer *dayTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    UITapGestureRecognizer *weekTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    UITapGestureRecognizer *monthTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    [self.todayLabel addGestureRecognizer:dayTapped];
    [self.weekLabel addGestureRecognizer:weekTapped];
    [self.monthLabel addGestureRecognizer:monthTapped];

    [self animateGreenUnderbarToLabel:self.todayLabel];
}

- (void)requestButtonTapped {
    [self performSegueWithIdentifier:@"requestSegue" sender:self];
}

- (void)labelTapped:(UITapGestureRecognizer *) gesture {
    UILabel *label = (UILabel *)gesture.view;
    [self animateGreenUnderbarToLabel:label];
}

- (void)animateGreenUnderbarToLabel:(UILabel *)label {
    CGRect frame = label.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.greenUnderbar.frame = CGRectMake(frame.origin.x, self.greenUnderbar.frame.origin.y, frame.size.width, self.greenUnderbar.frame.size.height);
    }];
    // Display appropriate view
    [self showScheduleViewForSelection:label];
}

- (void)showScheduleViewForSelection:(UILabel *)label {
    if (label == self.todayLabel) {
        self.scheduleView.backgroundColor = [UIColor orangeColor];
    } else if (label == self.weekLabel) {
        self.scheduleView.backgroundColor = [UIColor purpleColor];
    } else {
        self.scheduleView.backgroundColor = [UIColor redColor];
    }
}

@end
