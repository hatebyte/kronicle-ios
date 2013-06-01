//
//  KRSwipeUpScrollView.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRSwipeUpScrollView;

@protocol KRSwipeUpScrollViewDelegate <UIScrollViewDelegate>

- (void)scrollView:(KRSwipeUpScrollView*)scrollView swipedUpWithDistance:(int)distance;
- (void)scrollView:(KRSwipeUpScrollView*)scrollView swipedDownWithDistance:(int)distance;

@end

@interface KRSwipeUpScrollView : UIScrollView <UIGestureRecognizerDelegate> {
    @private
    UISwipeGestureRecognizer *_swipeRecongizer;
    CGRect _bounds;
    
}

@property(nonatomic, assign) BOOL isUp;
@property(nonatomic, weak) id <KRSwipeUpScrollViewDelegate> delegate;

+ (CGFloat)maxHeight;

@end
