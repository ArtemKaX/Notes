//
//  AppLiftAccess.h
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AppLiftAccess : NSObject

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectContext *)managedObjectContextForThread;
- (NSManagedObjectModel *)managedObjectModel;

- (NSString *)applicationDocumentsDirectory;

+ (AppLiftAccess *)sharedAccess;

@end
