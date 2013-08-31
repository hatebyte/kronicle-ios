//
//  KRReviewOverlay.h
//  Kronicle
//
//  Created by Scott on 8/31/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

    
@class KRReviewOverlay;
@protocol KRReviewOverlayDelegate <NSObject>
- (void)reviewOverlay:(KRReviewOverlay *)reviewOverlay finishedWithValue:(CGFloat)value;
- (void)reviewOverlayCancelled;
@end

@interface KRReviewOverlay : UIView

@property(nonatomic, weak) id <KRReviewOverlayDelegate> delegate;

- (void)setReviewWithValue:(CGFloat)value;

@end
