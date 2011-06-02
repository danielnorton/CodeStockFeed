//
//  ModelCore.h
//  
//
//  Created by Daniel Norton on 4/28/10.
//  Copyright 2011 Daniel Norton. All rights reserved.
//



@interface ModelCore : NSObject {
    NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	BOOL useBundleFile;
}

+ (ModelCore *)sharedManager;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@end

