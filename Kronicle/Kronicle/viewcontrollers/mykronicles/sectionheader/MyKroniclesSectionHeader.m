//
//  MyKroniclesSectionHeader.m
//  Kronicle
//
//  Created by Scott on 8/25/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "MyKroniclesSectionHeader.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyKroniclesSectionHeader

+ (CGFloat)headerHeight {
    return 61.f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        CALayer *layer = [CALayer layer];
        [layer setBackgroundColor:[[KRColorHelper turquoiseDark] CGColor]];
        layer.frame = CGRectMake(0, 0, 320, 45);
        [self.layer addSublayer:layer];

        
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
