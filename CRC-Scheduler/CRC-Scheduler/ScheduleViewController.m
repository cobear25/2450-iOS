//
//  ScheduleViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 1/21/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "ScheduleViewController.h"
#import "UIColor+CRCAdditions.h"

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor CRCGreenColor], NSForegroundColorAttributeName, nil];

    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationItem setHidesBackButton:YES];
//    UIBarButtonItem *request = [UIBarButtonItem b]
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Requests >" style:UIBarButtonItemStyleDone target:self action:@selector(requestButtonTapped)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor CRCGreenColor];
}

- (void)requestButtonTapped {
    [self performSegueWithIdentifier:@"requestSegue" sender:self];
}

@end
