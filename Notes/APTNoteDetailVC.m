//
//  APTNoteDetailVC.m
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import "APTNoteDetailVC.h"
#import "Note.h"

@interface APTNoteDetailVC ()

- (void)setupNavigationBar;
- (void)setupView;

@end

@implementation APTNoteDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setupNavigationBar];
	[self setupView];
}

- (void)setupNavigationBar
{
	UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addNote)];
	if (self.note == nil) {
		UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];

		self.navigationItem.leftBarButtonItem = leftBarItem;
	}
	self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)setupView
{
	if (self.note != nil)
	{
		self.titleFiled.text = self.note.name;
		self.textView.text = self.note.body;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
}

- (void)cancelAction
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/*
 * This Functions show/hide custom indicator
 */
- (void)showLoading
{
	[SVProgressHUD showHUDAddedTo:self.view];
}

- (void)hideLoading
{
	[SVProgressHUD hideHUDForView:self.view];
}
/**
 This Function add Note to local storage
 @return 
 */

- (BOOL)checkNote:(NSString *)noteName
{
	NSError *error = nil;
	
	NSManagedObjectContext *context = nil;
	context = [[AppLiftAccess sharedAccess] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note"
											  inManagedObjectContext:context];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",
							  noteName];
	
    [fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
													 error:&error];
	return [fetchedObjects count]>0 ? NO : YES;
}

- (void)addNote
{
	CGFloat latitude = userCoordinate.coordinate.latitude;
	CGFloat longitude = userCoordinate.coordinate.longitude;
	NSString *name = [self.titleFiled.text trimmedString];
	NSString *body = self.textView.text;
	if ([name isEmptyString]) {
		[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Name could not be empty", nil)
								   forView:self.view];
		return;
	}

	if (![self checkNote:name]) {
		[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Note with this name already exists", nil)
								   forView:self.view];
		return;
	}
	[self showLoading];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{

		NSManagedObjectContext *context = nil;
		context = [[AppLiftAccess sharedAccess] managedObjectContext];
		NSManagedObject *managedObject = [NSEntityDescription
										  insertNewObjectForEntityForName:@"Note"
										  inManagedObjectContext:context];
		[managedObject setValue:[name trimmedString] forKey:@"name"];
		[managedObject setValue:body forKey:@"body"];
		if (latitude > 0 && longitude > 0) {
			[managedObject setValue:[NSNumber numberWithDouble:latitude]
							 forKey:@"latitude"];
			[managedObject setValue:[NSNumber numberWithDouble:longitude]
							 forKey:@"longitude"];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self hideLoading];
			[self.navigationController dismissViewControllerAnimated:YES completion:^{
				[[[AppLiftAccess sharedAccess] managedObjectContextForThread] save:NULL];
				[self syncWithServer];
			}];
		});

	});
}

- (void)syncWithServer
{
#warning Sync is not implemented due absense of server
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    LLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
	userCoordinate = location;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
	[aTextField resignFirstResponder];
	
	return YES;
}

@end
