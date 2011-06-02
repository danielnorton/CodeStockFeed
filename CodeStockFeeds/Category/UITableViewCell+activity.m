//
//  UITableViewCell+activity.m
//  LeanKit
//
//  Created by Daniel Norton on 2/16/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//

#import "UITableViewCell+activity.h"


@implementation UITableViewCell(activity)

- (void)setActivityIndicatorAccessoryView {

	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activity startAnimating];
	[activity setHidesWhenStopped:NO];
	[self setAccessoryView:activity];
	[activity release];
}

- (void)clearAccessoryViewWith:(UITableViewCellAccessoryType)type {
	
	[self setAccessoryView:nil];
	[self setAccessoryType:type];
}

- (void)setActivityIndicatorAnimating:(BOOL)isAnimating {
	
	UIActivityIndicatorView *activity = (UIActivityIndicatorView *)self.accessoryView;
	if (!activity || ![activity isKindOfClass:[UIActivityIndicatorView class]]) return;
	
	if (isAnimating) {
		
		[activity startAnimating];
		
	} else {
		
		[activity stopAnimating];
	}

}


@end

