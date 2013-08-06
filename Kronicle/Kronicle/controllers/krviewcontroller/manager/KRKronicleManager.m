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
    if (stepIndex >= _kronicle.steps.count) {
        return;
    }
    KRStep *s = [_kronicle.steps objectAtIndex:stepIndex];
    [self.delegate manager:self updateUIForStep:s];
}

- (void)setPreviewStep:(int)stepIndex {
    if (stepIndex >= _kronicle.steps.count) {
        return;
    }
    KRStep *s = [_kronicle.steps objectAtIndex:stepIndex];
    [self.delegate manager:self previewUIForStep:s];
}

#pragma private methods

@end
