//
//  SpeakerListViewController.m
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/2/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "SpeakerListViewController.h"
#import "Model.h"
#import "UIViewController+popup.h"
#import	"SpeakerRepository.h"

@implementation SpeakerListViewController


#pragma mark -
#pragma mark UIViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	
	ModelCore *core = [ModelCore sharedManager];
	SpeakerRepository *repo = [[SpeakerRepository alloc] initWithContext:core.managedObjectContext];
	[self setRepo:repo];
	[repo release];
	
	NSFetchedResultsController *controller = [self.repo controllerForAll];
	[self setFetchedResultsController:controller];
	
	[self setRemoteServicePath:@"http://codestock.org/api/v2.0.svc/AllSpeakersJson"];
	
	[self performFetch];
}


#pragma mark FeedViewControllerBase
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	Speaker *speaker = (Speaker *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	[cell.textLabel setText:speaker.name];

	[NSThread sleepForTimeInterval:0.1f];
}

- (void)loadModelFromJson:(NSArray *)json {
	
	SpeakerRepository *repo = (SpeakerRepository *)self.repo;
	
	[json enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		NSDictionary *item = (NSDictionary *)obj;
		Speaker *speaker = (Speaker *)[repo insertNewObject];
		
		[speaker setName:[item objectForKey:@"Name"]];
	}];
	
	NSError *error = nil;
	if (![repo save:&error]) {
		
		[self popup:@"An error occurred while retreiving the data"];
	}	
}


@end

