//
//  ModelCore.m
// 
//
//  Created by Daniel Norton on 10/6/10.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "ModelCore.h"
#import "UIApplication+delegate.h"

#define kUseBundleFile YES


@interface ModelCore()
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSString *)applicationLibraryDirectory;
@end

@implementation ModelCore

#pragma mark -
#pragma mark NSObject
- (void)dealloc {    
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
    [super dealloc];
}

- (id)init {
	if (![super init]) return nil;
	useBundleFile = kUseBundleFile;
	return self;
}

#pragma mark -
#pragma mark ModelCore
- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	
	if (!useBundleFile) {
		[managedObjectContext save:nil];
	}
	
    return managedObjectContext;
}

#pragma mark Private Extensions
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
	NSString *fileName = [UIApplication appName];
	NSString *type = @"sqlite";
	NSString *fileNameWithExtension = [NSString stringWithFormat:@"%@.%@", fileName, type];
	NSString *storePath = [[self applicationLibraryDirectory] stringByAppendingPathComponent: fileNameWithExtension];
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSLog(@"path: %@", storePath);
	if (useBundleFile) {	
		// Set up the store, provide a pre-populated default store.
		NSString *bundleStorePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:storePath]) {
			if (bundleStorePath) {
				[fileManager copyItemAtPath:bundleStorePath toPath:storePath error:NULL];
			}
		}
	}
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
    return persistentStoreCoordinator;
}

- (NSString *)applicationLibraryDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Singleton
static ModelCore *sharedModelManager = nil;

+(ModelCore *)sharedManager {
    if (sharedModelManager == nil) {
        sharedModelManager = [[super allocWithZone:NULL] init];
    }
    return sharedModelManager;
}

+(id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
