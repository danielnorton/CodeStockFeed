//
//  SessionListViewController.m
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/2/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "SessionListViewController.h"
#import "Model.h"
#import "UIViewController+popup.h"
#import	"SessionRepository.h"

@implementation SessionListViewController


#pragma mark -
#pragma mark UIViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	
	ModelCore *core = [ModelCore sharedManager];
	SessionRepository *repo = [[SessionRepository alloc] initWithContext:core.managedObjectContext];
	[self setRepo:repo];
	[repo release];
	
	NSFetchedResultsController *controller = [self.repo controllerForAll];
	[self setFetchedResultsController:controller];
	
	[self setRemoteServicePath:@"http://codestock.org/api/v2.0.svc/AllSessionsJson"];
	
	[self performFetch];
}


#pragma mark FeedViewControllerBase
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

	Session *session = (Session *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	[cell.textLabel setText:session.title];
}

- (void)loadModelFromJson:(NSArray *)json {
	
	SessionRepository *repo = (SessionRepository *)self.repo;
	
	[json enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		NSDictionary *item = (NSDictionary *)obj;
		Session *session = (Session *)[repo insertNewObject];
		
		[session setTitle:[item objectForKey:@"Title"]];
	}];
		
	NSError *error = nil;
	if (![repo save:&error]) {
		
		[self popup:@"An error occurred while retreiving the data"];
	}	
}

@end

