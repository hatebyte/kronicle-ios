//
//  KRStepListView.m
//  Kronicle
//
//  Created by Scott on 8/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRStepListView.h"
#import <QuartzCore/QuartzCore.h>
#import "KRClockManager.h"
#import "KRGlobals.h"

@interface KRStepListView () <UIGestureRecognizerDelegate> {
    @private
    UILabel *_titleLabel;
    UILabel *_subLabel;
    CGFloat _destVal;
    CGFloat _currentVal;
    CALayer *_turquoiseBar;
    CADisplayLink * _runloopConsilieri;
    UITapGestureRecognizer *_cellTapper;
}

@end


@implementation KRStepListView
+ (CGFloat)cellHeight {
    return 80.f;
}


- (id)initWithFrame:(CGRect)frame andStep:(Step *)step
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _step = step;
        
        CALayer *yellowBar = [CALayer layer];
        yellowBar.frame = CGRectMake(0, 0, 20, frame.size.height);
        yellowBar.backgroundColor = [KRColorHelper orange].CGColor;
        [self.layer addSublayer:yellowBar];
        
        _turquoiseBar = [CALayer layer];
        _turquoiseBar.frame = CGRectMake(0, 0, 20, 0);
        _turquoiseBar.backgroundColor = [KRColorHelper turquoise].CGColor;
        [self.layer addSublayer:_turquoiseBar];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_turquoiseBar.frame.size.width + 10, 8, 290, 40)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:26];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [KRColorHelper turquoise];
        _titleLabel.text = [NSString stringWithFormat:@"%@", _step.title];
        [self addSubview:_titleLabel];
        
        _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x+1,
                                                              _titleLabel.frame.origin.y + _titleLabel.frame.size.height-12,
                                                              290,
                                                              30)];
        _subLabel.textAlignment = NSTextAlignmentLeft;
        _subLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeRegular];
        _subLabel.textColor = [UIColor grayColor];
        _subLabel.backgroundColor = [UIColor clearColor];
        _subLabel.textColor = [KRColorHelper turquoise];
        NSString *time = [KRClockManager clockTimeString:_step.time];
        if ([[time substringToIndex:1] isEqualToString:@"0"]) {
            time = [time substringFromIndex:1];
        }
        _subLabel.text = time;
        [self addSubview:_subLabel];
        
        _cellTapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelected:)];
        _cellTapper.cancelsTouchesInView = NO;
        _cellTapper.delegate = self;
        [self addGestureRecognizer:_cellTapper];

        
        _runloopConsilieri = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame)];
        
    }
    return self;
}

#pragma public methods
- (void)setStepCompleted:(BOOL)isCompleted {
    [self removeRunLoop];
    if (isCompleted) {
        [self animateComplete];
    } else {
        [self animateIncomplete];
    }
}

- (void)setTimeForLastStep {
    _subLabel.text = @"Finished!";
}

- (void)setCurrentStep {
    [self addRunLoop];
    [UIView animateWithDuration:.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _titleLabel.textColor = [KRColorHelper turquoise];
                         _subLabel.textColor = [KRColorHelper turquoise];
                     }
                     completion:^(BOOL fin){
                     }];

}

- (void)updateCurrentStepWithRatio:(CGFloat)stepRatio {
    _destVal = self.frame.size.height * stepRatio;
    
    
}

#pragma private methods
- (void)updateFrame {
    _currentVal += (_destVal - _currentVal) / 4;
//    _turquoiseBar.frame = CGRectMake(0, 0, _turquoiseBar.frame.size.width, _currentVal);
    [CATransaction setDisableActions:YES];
    _turquoiseBar.frame = CGRectMake(0, 0, _turquoiseBar.frame.size.width, _destVal);
    [CATransaction setDisableActions:NO];
}

- (void)removeRunLoop {
    [_runloopConsilieri invalidate];
    _destVal = 0;
    _currentVal = 0;
}
- (void)addRunLoop {
    [_runloopConsilieri addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)animateComplete {
    [CATransaction setDisableActions:YES];
    _turquoiseBar.frame = CGRectMake(0, 0, _turquoiseBar.frame.size.width, self.frame.size.height);
    [CATransaction setDisableActions:NO];
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _titleLabel.textColor = [KRColorHelper turquoise];
                         _subLabel.textColor = [KRColorHelper turquoise];
                    }
                     completion:^(BOOL fin){
                     }];
}

- (void)animateIncomplete {
    [CATransaction setDisableActions:YES];
    _turquoiseBar.frame = CGRectMake(0, 0, _turquoiseBar.frame.size.width, 0);
    [CATransaction setDisableActions:NO];
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _titleLabel.textColor = [KRColorHelper orange];
                         _subLabel.textColor = [KRColorHelper orange];
                     }
                     completion:^(BOOL fin){
                     }];
}

#pragma uigesture 
- (IBAction)cellSelected:(id)sender {
    [self.delegate stepListView:self selectedByIndex:(int)_step.indexInKronicle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
