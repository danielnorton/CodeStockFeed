//
//  CodeStockFeedsAppDelegate.m
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/1/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "CodeStockFeedsAppDelegate.h"
#import "UIApplication+delegate.h"


#define kReachabiltyMaxNotify 3
#define kReachabilityNotifyKey @"ReachabilityNotifyKey"


@interface CodeStockFeedsAppDelegate()

- (void)reachabilityChanged:(NSNotification *)note;
- (BOOL)shouldAlertForReachabilityChanged;

@end


@implementation CodeStockFeedsAppDelegate


@synthesize window;
@synthesize tabBarController;
@synthesize internetReach;

#pragma mark -
#pragma mark NSObject
- (void)dealloc {
	
    [window release];
	[tabBarController release];
	[internetReach release];
    [super dealloc];
}


#pragma mark UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifer];
	
	[self reachabilityChanged:nil];
	
	[window setRootViewController:tabBarController];
	[window makeKeyAndVisible];
	
    return YES;
}



#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)aTabBarController didSelectViewController:(UIViewController *)viewController {

	UIColor *color = nil;
	switch (aTabBarController.selectedIndex) {
			
		case 0:
			color = [UIColor orangeColor];
			break;
			
		case 1:
			color = [UIColor greenColor];
			break;			
			
		default:
			color = [UIColor groupTableViewBackgroundColor];
			break;
	}
	
	[viewController.view setBackgroundColor:color];
	[viewController release];
}


#pragma mark -
#pragma mark CodeStockFeedsAppDelegate
#pragma mark Public Messages
- (BOOL)canReachInternet {
	return (internetReach.currentReachabilityStatus != NotReachable);
}


#pragma mark Private Extension
- (void)reachabilityChanged:(NSNotification *)note {
	
	if (![self canReachInternet]) {
		
		if (![self shouldAlertForReachabilityChanged]) return;
		
		NSString *const message = @"Internet connectivity is not available. Some features may be disabled.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UIApplication appName]
														message:NSLocalizedString(message, message)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
											  otherButtonTitles:nil];
		[alert show];	
		[alert release];
	}
}

- (BOOL)shouldAlertForReachabilityChanged {
	
	static BOOL hasNotifiedThisRun = NO;
	
	if (hasNotifiedThisRun) return NO;
	
	hasNotifiedThisRun = YES;
	
	int count = [[[NSUserDefaults standardUserDefaults] objectForKey:kReachabilityNotifyKey] integerValue];
	if (count >= kReachabiltyMaxNotify) return NO;
	
	count++;
	NSString *countObject = [NSString stringWithFormat:@"%i", count];
	[[NSUserDefaults standardUserDefaults] setObject:countObject forKey:kReachabilityNotifyKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	return YES;
}

@end
