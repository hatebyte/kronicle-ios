//
//  DurationCreatorView.h
//  Kronicle
//
//  Created by Scott on 6/4/13.
//  Copyright (c) 2013 Hai Koncept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DurationCreatorView;
@protocol DurationCreatorViewDelegate <NSObject>
- (void)touchView:(DurationCreatorView *)durationCreatorView updateWithPercent:(CGFloat)percent;
@end

@interface DurationCreatorView : UIView {
    @private
    CGFloat _angle;
    CGFloat _lastAngle;
    CGFloat _radius;
    CGFloat _stroke;
    CGFloat _alpha;
    CGFloat _adjustedRadius;
    bool _remove;
    NSTimer *_timer;
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGPoint _leadPoint;
    BOOL _listening;
    
}

@property(nonatomic, assign) CGFloat percent;
@property(nonatomic, assign) CGFloat value;
@property(nonatomic, strong) id <DurationCreatorViewDelegate> delegate;

@end
