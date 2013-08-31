//
//  KRPublishKronicleModule.m
//  Kronicle
//
//  Created by Scott on 8/31/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRPublishKronicleModule.h"
#import "Kronicle+Helper.h"

@interface KRPublishKronicleModule () {
    @private
    __weak Kronicle *_kronicle;
}

@end

@implementation KRPublishKronicleModule

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle
{
    self = [super initWithFrame:frame];
    if (self) {
        _kronicle = kronicle;
    }
    return self;
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
