//
//  CodeStockFeedsAppDelegate.h
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/1/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "Reachability.h"

@interface CodeStockFeedsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, readonly) Reachability *internetReach;

- (BOOL)canReachInternet;

@end
