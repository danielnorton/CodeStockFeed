//
//  FeedViewControllerBase.m
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/1/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "FeedViewControllerBase.h"
#import "UITableViewCell+activity.h"
#import "UIViewController+popup.h"

@interface FeedViewControllerBase()

- (void)didTapRefreshButton:(UIBarButtonItem *)sender;
- (void)configureRefreshingCell:(UITableViewCell *)cell;
- (void)enableWithLoadingCellMessage:(NSString *)message;

@end


@implementation FeedViewControllerBase


@synthesize repo;
@synthesize fetchedResultsController;
@synthesize remoteServicePath;
@synthesize isLoading;


#pragma mark -
#pragma mark NSObject
- (void)dealloc {
	
	[repo release];
	[fetchedResultsController release];
	[remoteServicePath release];
	[super dealloc];
}


#pragma mark UIViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																			 target:self
																			 action:@selector(didTapRefreshButton:)];
	[refresh setStyle:UIBarButtonItemStylePlain];
	[self.navigationItem setRightBarButtonItem:refresh];
	[refresh release];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	
	if (isLoading) return 1;
	
	return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	
	if (isLoading) return 1;
	
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (isLoading) {
		
		static NSString *loadingCellIdentifier = @"loadingCell";
		UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadingCellIdentifier] autorelease];
		}
		
		[self configureRefreshingCell:cell];
		return cell;
	}
	
	
	static NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}


#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark HTTPRequestServiceDelegate
- (void)httpRequestServiceDidFinish:(HTTPRequestService *)sender {
	
	NSArray *items = [sender.json objectAtIndex:0];
	[self loadModelFromJson:items];
	
	NSError *error = nil;
	[fetchedResultsController performFetch:&error];
	if (error) {
		[self enableWithLoadingCellMessage:@"Failed Refresh"];
		return;
	}
	
	[self setIsLoading:NO];
	[self.navigationItem.rightBarButtonItem setEnabled:YES];
	
	NSArray *sections = [fetchedResultsController sections];
	[fetchedResultsController setDelegate:self];
	[self.tableView beginUpdates];
	
	NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:sections.count];
	NSIndexSet *removeSections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, sections.count - 1)];
	
	for (int i = 0; i < sections.count; i++) {
		
		id<NSFetchedResultsSectionInfo> section = [sections objectAtIndex:i];
		int j = (i == 0) ? 1 : 0;
		for (; j < [section numberOfObjects]; j++) {
			
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
			[indexPaths addObject:indexPath];
		}		
	}
	
	[self.tableView insertSections:removeSections withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	NSIndexSet *top = [NSIndexSet indexSetWithIndex:0];
	[self.tableView reloadSections:top withRowAnimation:UITableViewRowAnimationNone];
	
	[self.tableView endUpdates];
}

- (void)httpRequestServiceDidTimeout:(HTTPRequestService *)sender {

	[self enableWithLoadingCellMessage:@"Request Timed Out"];
}


#pragma mark -
#pragma mark FeedViewControllerBase
#pragma mark Public Messages
- (void)beginRefresh {
	
	[self setIsLoading:YES];
	[self.navigationItem.rightBarButtonItem setEnabled:NO];
	
	NSArray *sections = [fetchedResultsController sections];
	[fetchedResultsController setDelegate:nil];
	[self.tableView beginUpdates];
	
	if (sections.count > 0) {

		NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:sections.count];
		NSIndexSet *removeSections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, sections.count - 1)];
		
		for (int i = 0; i < sections.count; i++) {
			
			id<NSFetchedResultsSectionInfo> section = [sections objectAtIndex:i];
			int j = (i == 0) ? 1 : 0;
			for (; j < [section numberOfObjects]; j++) {
				
				NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
				[indexPaths addObject:indexPath];
			}		
		}
		
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView deleteSections:removeSections withRowAnimation:UITableViewRowAnimationFade];
	}
	
	NSIndexSet *top = [NSIndexSet indexSetWithIndex:0];
	[self.tableView reloadSections:top withRowAnimation:UITableViewRowAnimationNone];
	
	[self.tableView endUpdates];
	
	NSError *error = nil;
	[repo purge:&error];
	
	HTTPRequestService *service = [[HTTPRequestService alloc] init];
	[service setDelegate:self];
	[service beginRequest:remoteServicePath
				   method:HTTPRequestServiceMethodGet
				   params:[NSDictionary dictionary]
		   withReturnType:HTTPRequestServiceReturnTypeJson];
	
	[service release];	
}

- (void)performFetch {
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		
		[self popup:@"An error occurred while loading the data."];
		
	} else {
		
		[self.tableView setDataSource:self];
	}
}

- (void)loadModelFromJson:(NSArray *)json {
	// no-op
}


#pragma mark Private Extension
- (void)didTapRefreshButton:(UIBarButtonItem *)sender {
	[self beginRefresh];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	// no-op
}

- (void)configureRefreshingCell:(UITableViewCell *)cell {
	
	[cell.textLabel setText:@"Refreshing..."];
	[cell.textLabel setTextColor:[UIColor lightGrayColor]];
	[cell setActivityIndicatorAccessoryView];
}

- (void)enableWithLoadingCellMessage:(NSString *)message {
	
	[self setIsLoading:NO];
	[self.navigationItem.rightBarButtonItem setEnabled:YES];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell clearAccessoryViewWith:UITableViewCellAccessoryNone];
	[cell.textLabel setText:message];
}


@end

