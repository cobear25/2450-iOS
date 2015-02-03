//
//  RequestViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 1/21/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "RequestViewController.h"
#import "UIColor+CRCAdditions.h"
#import "UIColor+CRCAdditions.h"

@interface RequestViewController() <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) BOOL viewIsUp;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor CRCGreenColor], NSForegroundColorAttributeName, nil];

    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor CRCGreenColor];
    [self.navigationController.navigationBar setTintColor:[UIColor CRCGreenColor]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editDate)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editDate)];
    [self.startDateView addGestureRecognizer:tap];
    [self.endDateView addGestureRecognizer:tap2];

    [self.ptoSwitch setOn:NO];
    self.ptoSwitch.onTintColor = [UIColor CRCGreenColor];
    self.reasonTextView.delegate = self;
    self.reasonTextView.layer.borderColor = [UIColor CRCGreenColor].CGColor;
    self.reasonTextView.layer.borderWidth = 1;

    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:dismissKeyboard];
    self.startDateLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    self.endDateLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"startDate"] != nil) {
        self.startDateLabel.text = [NSDateFormatter localizedStringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"startDate"] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    } else {
        self.startDateLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"endDate"] != nil) {
        self.endDateLabel.text = [NSDateFormatter localizedStringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"endDate"] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    } else {
        self.endDateLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
}

- (void)dismissKeyboard {
    [self.reasonTextView resignFirstResponder];
    [self.hoursTextField resignFirstResponder];
    if (self.viewIsUp) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectOffset(self.view.frame, 0, 200);
        }];
        self.viewIsUp = NO;
    }
}
- (void)editDate {
    [self performSegueWithIdentifier:@"editDateSegue" sender:self];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectOffset(self.view.frame, 0, -200);
    }];
    self.viewIsUp = YES;
}
- (IBAction)submitButtonTapped:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your request has been submitted" message:@"" delegate:self cancelButtonTitle:@"Ok, thanks" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startDate"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"endDate"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
