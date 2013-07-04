//
//  ALViewController.h
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APTLoginVC : UIViewController

// Outlets
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

// Actions
- (IBAction)loginAction:(id)sender;

@end
