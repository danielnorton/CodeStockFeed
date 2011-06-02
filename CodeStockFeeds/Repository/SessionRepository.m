//
//  SessionRepository.m
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/2/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "SessionRepository.h"


@implementation SessionRepository


#pragma mark -
#pragma mark RepositoryBase
- (id)initWithContext:(NSManagedObjectContext *)aManagedObjectContext {
	if (![super initWithContext:aManagedObjectContext]) return nil;
	
	[self setTypeName:@"Session"];
	[self setDefaultSortDescriptorsByKey:@"title"];
	
	return self;
}


@end

