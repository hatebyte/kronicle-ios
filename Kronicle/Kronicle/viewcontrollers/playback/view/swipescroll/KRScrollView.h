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

+ (CGFloat)playbackHeight;
+ (CGFloat)finishedHeight;

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle;
- (void)scrollToPage:(NSInteger)page;
- (void)updateCurrentStepClock:(NSString *)timeString;
- (void)setCurrentStep:(NSInteger)stepIndex;
- (void)updateForFinished;

@end
