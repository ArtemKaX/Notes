//
//  ALViewController.m
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import "APTLoginVC.h"
#import "APTNotesListVC.h"

@interface APTLoginVC ()

- (void)setupView;

@end

@implementation APTLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setupView];
}

- (void)setupView
{

}

#pragma mark -
#pragma mark Actions

- (IBAction)loginAction:(id)sender
{
	NSString *login = self.nameField.text;
	NSString *password = self.passField.text;
	
	if (login == nil && password == nil) {
		[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Login or password can't be empty", nil)
								   forView:self.view];
		return;
	}
	
	APTNotesListVC *listVC = [[APTNotesListVC alloc] initWithNibName:@"APTNotesListVC"
															  bundle:nil];
	[listVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	
	UINavigationController * navController = [[UINavigationController alloc] initWithNavigationBarClass:nil toolbarClass:nil];
	navController.viewControllers = @[listVC];
	
	[self presentViewController:navController animated:YES completion:nil];
}

@end
