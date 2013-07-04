//
//  AppNotesListVC.m
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import "APTNotesListVC.h"
#import "APTNoteCell.h"
#import "APTNoteDetailVC.h"

@interface APTNotesListVC ()

- (void)setupView;

@end

@implementation APTNotesListVC

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
	[self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self loadNotes];
}

/**
 This Function setups View
 @return
 */
- (void)setupView
{
	UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered target:self action:@selector(syncAction)];
	self.navigationItem.leftBarButtonItem = leftBarItem;
	UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote)];
	self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)updateTable
{
	UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,44)];
	[headerView setTextAlignment:NSTextAlignmentCenter];
	[headerView setBackgroundColor:[UIColor clearColor]];
	headerView.text = NSLocalizedString(@"No Notes",nil);
	self.tableView.tableHeaderView = [self.notes count] ? nil : headerView;
	[self.tableView reloadData];
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
 This Function loads Notes
 @return
 */

- (void)loadNotes
{
	[self showLoading];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,
											 0), ^{
		NSError *error = nil;
		
		NSManagedObjectContext *context = [[AppLiftAccess sharedAccess]
										   managedObjectContext];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note"
												  inManagedObjectContext:context];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
											initWithKey:@"latitude" ascending:NO];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:@[sortDescriptor]];
		
		NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
														 error:&error];
		
		self.notes = fetchedObjects;
		
		LLog(@"Loaded Notes:%@",self.notes);
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self hideLoading];
			[self updateTable];
		});
	});
}

/**
 This Function add Note 
 @return
 */

- (void)addNote
{
	LLog();
	
	APTNoteDetailVC *detailVC = [[APTNoteDetailVC alloc] initWithNibName:@"APTNoteDetailVC"
															  bundle:nil];
	[detailVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	
	UINavigationController * navController = [[UINavigationController alloc] initWithNavigationBarClass:nil toolbarClass:nil];
	navController.viewControllers = @[detailVC];
	
	[self presentViewController:navController animated:YES completion:nil];
}

/**
 This Function deletes Note from local storage
 @param Note
 */

- (void)deleteNote:(Note *)note
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,
											 0), ^{
		// Delete Object from local store
		NSManagedObjectContext *context = [[AppLiftAccess sharedAccess]
										   managedObjectContext];
		[context deleteObject:(NSManagedObject*)note];
		
		[context save:NULL];
	});

	
	// Update UI
	NSMutableArray *notesList = [NSMutableArray arrayWithArray:self.notes];
	[notesList removeObject:note];
	self.notes = [NSArray arrayWithArray:notesList];
}

#pragma mark 

- (void)syncAction
{
	LLog(@"Sync is not implemented yet");
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 	return [self.notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"AppNoteCell";
	
	APTNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	Note *note = [self.notes objectAtIndex:indexPath.row];
	if (cell == nil)
	{
		cell = [[APTNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	[cell configureCellWithNote:note];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Note *note = [self.notes objectAtIndex:indexPath.row];
	
	LLog(@"Selected Note:%@", note);
	
	APTNoteDetailVC *detailVC = [[APTNoteDetailVC alloc] initWithNibName:@"APTNoteDetailVC"
																  bundle:nil];
	[detailVC setNote: note];

	[self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        [self deleteNote:[self.notes objectAtIndex:indexPath.row]];

		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
		
		[self updateTable];
	}   
}

@end
