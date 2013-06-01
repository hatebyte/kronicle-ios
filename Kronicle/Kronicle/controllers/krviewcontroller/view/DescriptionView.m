//
//  DescriptionView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "DescriptionView.h"
#import "KRFontHelper.h"

@implementation DescriptionView

- (id)initWithFrame:(CGRect)frame andStep:(KRStep*)step
{
    self = [super initWithFrame:frame];
    if (self) {
        self.step = step;
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        self.titleLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeMedium];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = self.step.title;
        [self addSubview:self.titleLabel];
        
        int titleHeight = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y;
        self.description = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                                        titleHeight,
                                                                        320,
                                                                        frame.size.height - titleHeight)];
        self.description.font = [KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeMedium];
        self.description.text = self.step.description;
        self.description.textColor = [UIColor blackColor];
        //self.description.contentInset = UIEdgeInsetsMake(3,-8,3,0);
        self.description.editable = NO;
        self.description.backgroundColor = [UIColor clearColor];
        [self addSubview:self.description];

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
