//
//  FeedViewControllerBase.h
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/1/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "RepositoryBase.h"
#import "HTTPRequestService.h"


@interface FeedViewControllerBase : UITableViewController
<NSFetchedResultsControllerDelegate, HTTPRequestServiceDelegate>

@property (nonatomic, retain) RepositoryBase *repo;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSString *remoteServicePath;
@property (nonatomic, assign) BOOL isLoading;

- (void)beginRefresh;
- (void)performFetch;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)loadModelFromJson:(NSArray *)json;

@end
