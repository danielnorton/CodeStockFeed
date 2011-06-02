//
//  UITableViewCell+activity.h
//  LeanKit
//
//  Created by Daniel Norton on 2/16/11.
//  Copyright 2011 Daniel Norton. All rights reserved.
//


@interface UITableViewCell(activity)

- (void)setActivityIndicatorAccessoryView;
- (void)clearAccessoryViewWith:(UITableViewCellAccessoryType)type;
- (void)setActivityIndicatorAnimating:(BOOL)isAnimating;
@end
