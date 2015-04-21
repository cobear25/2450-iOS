//
//  ViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 1/20/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+CRCAdditions.h"
#import "APIClient.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (strong, nonatomic) APIClient *client;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;

    self.usernameTextField.layer.borderColor = [UIColor CRCGreenColor].CGColor;
    self.usernameTextField.layer.borderWidth = 1;
    self.usernameTextField.layer.cornerRadius = 4;
    self.passwordTextField.layer.borderColor = [UIColor CRCGreenColor].CGColor;
    self.passwordTextField.layer.borderWidth = 1;
    self.passwordTextField.layer.cornerRadius = 4;

   self.client = [APIClient sharedClient];

//    [self.client getShiftsForUser:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4 animations:^{
        self.topSpaceConstraint.constant -= 60;
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4 animations:^{
        self.topSpaceConstraint.constant += 60;
    }];
}
- (IBAction)logInTapped:(UIButton *)sender {
    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter your username and password." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logging In..." message:@"\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator startAnimating];
        [alert setValue:indicator forKey:@"accessoryView"];
        [alert show];
        [self.client getTokenForUsername:self.usernameTextField.text Password:self.passwordTextField.text success:^{
            [alert dismissWithClickedButtonIndex:0 animated:NO];

            [[NSUserDefaults standardUserDefaults] setObject:self.usernameTextField.text forKey:@"username"];
            [self performSegueWithIdentifier:@"login" sender:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [alert dismissWithClickedButtonIndex:0 animated:NO];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Invalid username and/or password" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            self.passwordTextField.text = @"";
        }];
    }
}
@end
