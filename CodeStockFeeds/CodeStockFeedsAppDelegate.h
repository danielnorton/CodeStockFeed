//
//  CodeStockFeedsAppDelegate.h
//  CodeStockFeeds
//
//  Created by Daniel Norton on 6/1/11.
//  Copyright 2011 Firefly Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeStockFeedsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
