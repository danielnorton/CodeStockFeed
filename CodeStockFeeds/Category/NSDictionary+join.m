//
//  NSDictionary+join.m
// 
//
//  Created by Daniel Norton on 11/19/10.
//  Copyright 2010 Daniel Norton. All rights reserved.
//

#import "NSDictionary+join.h"

#define kDefaultJoin @"&"

@implementation NSDictionary(join)

- (NSString *)join {
	return [self join:kDefaultJoin];
}

- (NSString *)join:(NSString *)seperator {
	
	NSMutableString *resultString = [NSMutableString string];
	[[self allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	
		NSString* key = (NSString *)obj;
		if (resultString.length > 0) {
			[resultString appendString:seperator];
		}
		
		[resultString appendFormat:@"%@=%@", key, [self objectForKey:key]];
	}];
	
	return resultString;
}
@end
