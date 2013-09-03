//
//  KRKronicleManager.m
//  Kronicle
//
//  Created by Scott on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleManager.h"
#import "KRGlobals.h"


@interface KRKronicleManager () {
    @private
    __weak Kronicle *_kronicle;
    
}

@end

@implementation KRKronicleManager

- (id)initWithKronicle:(Kronicle *)kronicle {
    if (self = [super init]) {
        _kronicle = kronicle;
        self.currentStepIndex = 0;
        self.previewStepIndex = 0;
    }
    return self;
}

#pragma public methods 
- (void)setStep:(NSInteger)stepIndex {
    if (stepIndex >= [_kronicle.steps count] || stepIndex < 0) {
        DDLogError(@"KRONICLE IS COMPLETED");
        //self.currentStepIndex = [_kronicle.steps count];
        [self.delegate kronicleComplete:self];
        return;
    }
    
    _requestedDirection = (self.currentStepIndex < stepIndex);
    self.currentStepIndex = stepIndex;
    Step *s = [_kronicle.steps objectAtIndex:self.currentStepIndex];
    [self.delegate manager:self updateUIForStep:s];
}

- (void)setPreviewStep:(NSInteger)stepIndex {
    if (stepIndex >= [_kronicle.steps count] || stepIndex < 0) {
        DDLogError(@"CANT PREVIEW THAT STEP");                              
        //self.previewStepIndex = [_kronicle.steps count];
        return;
    }
    _requestedDirection = (self.previewStepIndex < stepIndex);
    self.previewStepIndex = stepIndex;
    Step *s = [_kronicle.steps objectAtIndex:self.previewStepIndex];
    [self.delegate manager:self previewUIForStep:s];
}

#pragma private methods

@end
