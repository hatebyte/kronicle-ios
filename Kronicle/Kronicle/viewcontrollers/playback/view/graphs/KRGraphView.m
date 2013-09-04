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
        _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        _progressBarView.backgroundColor = [KRColorHelper turquoise];
        [self addSubview:_progressBarView];
    }
    return self;
}

- (void)showDisplayForRatio:(CGFloat)ratio {
    _destVal = self.frame.size.width * ratio;
    
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _progressBarView.frame = CGRectMake(0, 0, _destVal, self.frame.size.height);
                     }
                     completion:^(BOOL fin){
                     }];

}

- (void)showDisplayWithReset:(BOOL)shouldReset {
    [self reset];
}

- (void)reset {
    _destVal = 0;
    _progressBarView.frame = CGRectMake(0, 0, 0, self.frame.size.height);
}

@end
