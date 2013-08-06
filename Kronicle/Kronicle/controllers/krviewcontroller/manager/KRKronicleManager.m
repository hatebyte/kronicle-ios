//
//  KRKronicleManager.m
//  Kronicle
//
//  Created by Scott on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleManager.h"


@interface KRKronicleManager () {
    @private
    __weak KRKronicle *_kronicle;
    
}

@end

@implementation KRKronicleManager

- (id)initWithKronicle:(KRKronicle *)kronicle {
    if (self = [super init]) {
        _kronicle = kronicle;
    }
    return self;
}

#pragma public methods 
- (void)setStep:(int)stepIndex {
    if (stepIndex >= _kronicle.steps.count-1 || stepIndex < 0) {
        return;
    }
    self.currentStepIndex = stepIndex;
    KRStep *s = [_kronicle.steps objectAtIndex:self.currentStepIndex];
    [self.delegate manager:self updateUIForStep:s];
}

- (void)setPreviewStep:(int)stepIndex {
    stepIndex =(stepIndex >= _kronicle.steps.count-1) ? (_kronicle.steps.count-1) : stepIndex;
    stepIndex =(stepIndex < 0) ? 0 : stepIndex;
    
    self.previewStepIndex = stepIndex;
    KRStep *s = [_kronicle.steps objectAtIndex:self.previewStepIndex];
    [self.delegate manager:self previewUIForStep:s];
}

#pragma private methods

@end
