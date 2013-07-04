//
//  AppLiftAccess.m
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import "AppLiftAccess.h"

/**
 Private Categories
 */
@interface AppLiftAccess()
{
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
}
- (NSString *)applicationDocumentsDirectory;

@end

@implementation AppLiftAccess

/**
 This Function cretates shared instance of PictagTagsAccess
 @return AppLiftAccess
 */
+ (AppLiftAccess *)sharedAccess
{
    static dispatch_once_t pred = 0;
    static AppLiftAccess *sAppListNotesAccess = nil;
    dispatch_once(&pred, ^{
        sAppListNotesAccess = [[AppLiftAccess alloc] init];
    });
	return sAppListNotesAccess;
}

/**
 This Function returns managedObjectContext
 @return NSManagedObjectContext
 */

- (NSManagedObjectContext *)managedObjectContextForThread
{
	NSThread *thread = [NSThread currentThread];
	
	if ([thread isMainThread])
	{
		return [self managedObjectContext];
	}
	
	NSString *threadKey = [NSString stringWithFormat:@"ManagedObjectContext"];
	
	if ( [[thread threadDictionary] objectForKey:threadKey] == nil )
	{
		NSManagedObjectContext *threadContext = [NSManagedObjectContext new];
        [threadContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
		
		[[thread threadDictionary] setObject:threadContext forKey:threadKey];
    }
	
	return [[thread threadDictionary] objectForKey:threadKey];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (nil != managedObjectContext)
	{
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *storeCoordinator = [self persistentStoreCoordinator];
    
    if (nil != storeCoordinator)
    {
        managedObjectContext = [NSManagedObjectContext new];
        [managedObjectContext setPersistentStoreCoordinator:storeCoordinator];
    }
    return managedObjectContext;
}

/**
 This Function returns managedObjectModel
 @return NSManagedObjectModel
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (nil != managedObjectModel)
	{
        return managedObjectModel;
    }
	
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model"
										 withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    return managedObjectModel;
}

/**
 This Function returnes persistentStoreCoordinator
 @return NSPersistentStoreCoordinator
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (nil != persistentStoreCoordinator)
	{
        return persistentStoreCoordinator;
    }
	
	if (![NSThread currentThread].isMainThread) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            (void)[self persistentStoreCoordinator];
        });
        return persistentStoreCoordinator;
    }
	
    NSString *storePath = [[self applicationDocumentsDirectory]
						   stringByAppendingPathComponent:@"Notes.sqlite"];
    
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								  initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												  configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
	return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,
                                                YES) lastObject];
}

@end
