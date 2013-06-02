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
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, 292, 50)];
        self.titleLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:32];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = self.step.title;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        [self.titleLabel setFont:[KRFontHelper getFont:KRBrandonLight withSize:28]];
        [self.titleLabel sizeToFit];

        [self addSubview:self.titleLabel];
        
        int titleHeight = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y;
        self.description = [[UITextView alloc] initWithFrame:CGRectMake(7,
                                                                        titleHeight-5,
                                                                        306,
                                                                        frame.size.height - titleHeight)];
        self.description.font = [KRFontHelper getFont:KRMinionProRegular withSize:16];
        self.description.text = self.step.description;
//        self.description.text = @"self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description self.description";
        self.description.scrollEnabled = NO;
        self.description.textColor = [UIColor blackColor];
        //self.description.contentInset = UIEdgeInsetsMake(3,-8,3,0);
        self.description.editable = NO;
        self.description.backgroundColor = [UIColor clearColor];
        [self addSubview:self.description];
        
//        for (NSString *familyName in [UIFont familyNames]) {
//            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//                NSLog(@"%@", fontName);
//            }
//        }

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
