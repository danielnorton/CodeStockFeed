//
//  SpeakerRepository.m
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/2/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "SpeakerRepository.h"


@implementation SpeakerRepository


#pragma mark -
#pragma mark RepositoryBase
- (id)initWithContext:(NSManagedObjectContext *)aManagedObjectContext {
	if (![super initWithContext:aManagedObjectContext]) return nil;
	
	[self setTypeName:@"Speaker"];
	[self setDefaultSortDescriptorsByKey:@"name"];
	
	return self;
}


@end

