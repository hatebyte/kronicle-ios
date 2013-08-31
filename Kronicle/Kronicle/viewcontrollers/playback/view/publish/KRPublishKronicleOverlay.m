//
//  KRPublishKronicleOverlay.m
//  Kronicle
//
//  Created by Scott on 8/31/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRPublishKronicleOverlay.h"
#import "KRPublishKronicleModule.h"
#import "Kronicle+Helper.h"

@interface KRPublishKronicleOverlay () {
    @private
    KRPublishKronicleModule *_overlayModule;
    __weak Kronicle *_kronicle;
}

@end

@implementation KRPublishKronicleOverlay

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor                    = [UIColor blackColor];
        _kronicle                               = kronicle;
        
        //_overlayModule                          = [[KRPublishKronicleModule alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andKronicle:_kronicle];
    }
    return self;
}


@end
