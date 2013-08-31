//
//  TouchCircleCreatorView.h
//  Kronicle
//
//  Created by Scott on 6/4/13.
//  Copyright (c) 2013 Hai Koncept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchCircleCreatorView;
@protocol TouchCircleCreatorViewDelegate <NSObject>
- (void)touchCircleCreatorView:(TouchCircleCreatorView *)touchCircleCreatorView updateWithPercent:(CGFloat)percent;
@optional
@end

@interface TouchCircleCreatorView : UIView {
    @private
    CGFloat _angle;
    CGFloat _lastAngle;
    CGFloat _radius;
    CGFloat _alpha;
    CGFloat _adjustedRadius;
    bool _remove;
    NSTimer *_timer;
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGPoint _leadPoint;
    BOOL _listening;
     
}


@property(nonatomic, assign) CGLineCap lineCap;
@property(nonatomic, assign) CGLineJoin lineJoin;
@property(nonatomic, assign) CGFloat percent;
@property(nonatomic, assign) CGFloat value;
@property(nonatomic, strong) id <TouchCircleCreatorViewDelegate> delegate;
@property(nonatomic, strong) UIColor *strokeColorBackground;
@property(nonatomic, strong) UIColor *strokeColor;
@property(nonatomic, assign) CGFloat strokeWidth;
@property(nonatomic, assign) BOOL enabled;

- (void)updateGraphWithPercent:(CGFloat)percent;

@end
