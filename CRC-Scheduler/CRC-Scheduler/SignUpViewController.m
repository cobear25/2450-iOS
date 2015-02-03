//
//  SignUpViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 1/21/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "SignUpViewController.h"
#import "UIColor+CRCAdditions.h"

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameTextField.layer.borderColor = [UIColor CRCGreenColor].CGColor;
    self.usernameTextField.layer.borderWidth = 1;
    self.usernameTextField.layer.cornerRadius = 4;
    self.passwordTextField.layer.borderColor = [UIColor CRCGreenColor].CGColor;
    self.passwordTextField.layer.borderWidth = 1;
    self.passwordTextField.layer.cornerRadius = 4;
    self.confirmPasswordTextField.layer.borderColor = [UIColor CRCGreenColor].CGColor;
    self.confirmPasswordTextField.layer.borderWidth = 1;
    self.confirmPasswordTextField.layer.cornerRadius = 4;
}
- (IBAction)signUpButtonTapped:(UIButton *)sender {
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
