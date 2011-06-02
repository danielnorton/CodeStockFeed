//
//  UIApplication+delegate.h
// 
//
//  Created by Daniel Norton on 11/3/10.
//  Copyright 2010 Daniel Norton. All rights reserved.
//

#import "CodeStockFeedsAppDelegate.h"

@interface UIApplication(delegate)
+ (CodeStockFeedsAppDelegate *)thisApp;
+ (NSString *)appName;
+ (NSString *)version;
@end
