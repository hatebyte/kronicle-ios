//
//  KRScrollView.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRKronicle.h"

typedef enum {
    KRSwipeUpScrollViewLeft,
    KRSwipeUpScrollViewRight,
} KRSwipeUpScrollViewSwipeDirection;


@class KRScrollView;
@protocol KRScrollViewDelegate <NSObject>
- (void)scrollView:(KRScrollView *)scrollView pageToIndex:(int)stepIndex;
@end


@interface KRScrollView : UIScrollView 

@property(nonatomic, weak) id <KRScrollViewDelegate> scrollDelegate;

- (id)initWithFrame:(CGRect)frame andKronicle:(KRKronicle *)kronicle;
- (void)scrollToPage:(int)page;
- (void)updateCurrentStepClock:(NSString *)timeString;
- (void)setCurrentStep:(int)stepIndex;
- (void)updateForLastStep;

@end
