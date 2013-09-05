//
//  KRSwipeViewNavigation.h
//  Kronicle
//
//  Created by Scott on 8/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRSwipeViewNavigation;
@protocol KRSwipeViewNavigationDelegate <UIScrollViewDelegate>

- (void)scrollView:(KRSwipeViewNavigation *)scrollView swipedUpWithDistance:(int)distance;
- (void)scrollView:(KRSwipeViewNavigation *)scrollView swipedDownWithDistance:(int)distance;

@end


@interface KRSwipeViewNavigation : UIView 

@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, assign) BOOL isBelowScreen;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, weak) id <KRSwipeViewNavigationDelegate> delegate;

- (void)toggleOpenClose;
- (void)close;
- (void)reposition;
- (void)hide;


+ (CGFloat)maxHeight;
+ (CGFloat)cellHeight;

@end
