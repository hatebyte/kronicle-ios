//
//  KRPublishOverlay.m
//  Kronicle
//
//  Created by Scott on 8/25/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRPublishOverlay.h"

@implementation KRPublishOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.3];
        
        
    }
    return self;
}

- (void)animateIn {
    
    self.alpha = 0;
    
    
    
}

- (void)animateOut {

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
