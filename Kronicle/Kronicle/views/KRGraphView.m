//
//  KRGraphView.m
//  Kronicle
//
//  Created by Jabari Bell on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRGraphView.h"
#import "KRColorHelper.h"
#import "KRGlobals.h"
#import <QuartzCore/QuartzCore.h>

@interface KRGraphView() {
    @private
    CADisplayLink * _runloopConsilieri;
    CGFloat _currentVal;
    CGFloat _destVal;
    UIView *_previewView;
}
@property(strong, atomic) UIView *progressBarView;
@end

@implementation KRGraphView

#pragma mark - Public Methods

#pragma mark - Init Stuff

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isCurrentStep = YES;
        self.backgroundColor = [KRColorHelper orange];
        _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _progressBarView.backgroundColor = [KRColorHelper turquoise];
        [self addSubview:_progressBarView];
        
        _previewView = [[UIView alloc] initWithFrame:self.bounds];
        _previewView.backgroundColor = [KRColorHelper orange];
        [self addSubview:_previewView];
        
        _runloopConsilieri = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame)];
    }
    return self;
}

- (void)showDisplayForRatio:(CGFloat)ratio {
    _destVal = self.frame.size.width * ratio;
}

- (void)showPreview {
    if (_previewView.alpha == 1) {
        return;
    }

    _previewView.alpha = 0;
    _previewView.hidden = NO;
    [UIView animateWithDuration:.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _previewView.alpha = 1.f;
                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)showDisplayWithReset:(BOOL)shouldReset {
    [self removeRunLoop];
    if (shouldReset) {
        [self reset];
    }
    [self addRunLoop];
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _previewView.alpha = 0;
                     }
                     completion:^(BOOL fin){
                         _previewView.hidden = YES;
                     }];
}

- (void)reset {
    [self removeRunLoop];
    _destVal = 0;
    _progressBarView.frame = CGRectMake(0, 0, 0, self.frame.size.height);
}

- (void)removeRunLoop {
    [_runloopConsilieri removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)addRunLoop {
    [_runloopConsilieri addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [self removeRunLoop];
}

- (void)updateFrame {
    _currentVal += (_destVal-_currentVal) / 4;
    _progressBarView.frame = CGRectMake(0, 0, _currentVal, self.frame.size.height);
}

@end
