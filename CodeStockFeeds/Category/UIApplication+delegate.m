//
//  UIApplication+delegate.m
// 
//
//  Created by Daniel Norton on 11/3/10.
//  Copyright 2010 Daniel Norton. All rights reserved.
//

#import "UIApplication+delegate.h"


@implementation UIApplication(delegate)

+ (CodeStockFeedsAppDelegate *)thisApp {
	return (CodeStockFeedsAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (NSString *)appName {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)version {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
