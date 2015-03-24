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

    APIClient *client = [APIClient new];
    [client logIn];
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
@end
