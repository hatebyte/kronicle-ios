//
//  KRScrollView.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kronicle+Helper.h"

typedef enum {
    KRSwipeUpScrollViewLeft,
    KRSwipeUpScrollViewRight,
} KRSwipeUpScrollViewSwipeDirection;


@class KRScrollView;
@protocol KRScrollViewDelegate <NSObject>
- (void)scrollView:(KRScrollView *)scrollView pageToIndex:(NSInteger)stepIndex;
@end


@interface KRScrollView : UIScrollView 

@property(nonatomic, weak) id <KRScrollViewDelegate> scrollDelegate;

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle;
- (void)scrollToPage:(int)page;
- (void)updateCurrentStepClock:(NSString *)timeString;
- (void)setCurrentStep:(int)stepIndex;
- (void)updateForFinished;

@end
