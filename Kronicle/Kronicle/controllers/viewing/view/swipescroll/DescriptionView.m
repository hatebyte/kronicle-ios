//
//  DescriptionView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "DescriptionView.h"
#import "KRFontHelper.h"
#import "KRClockManager.h"

@interface DescriptionView () {
    @private
    UILabel *_clockLabel;

}

@end

@implementation DescriptionView

- (id)initWithFrame:(CGRect)frame andStep:(KRStep*)step
{
    self = [super initWithFrame:frame];
    if (self) {
        self.step = step;
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 320, 30)];
        _clockLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:38];
        _clockLabel.textColor = [UIColor whiteColor];
        _clockLabel.backgroundColor = [UIColor clearColor];
        _clockLabel.textAlignment = NSTextAlignmentCenter;
        _clockLabel.text = @"00:00";

        [self addSubview:_clockLabel];
        
        _subClockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   _clockLabel.frame.origin.y + _clockLabel.frame.size.height+4,
                                                                   320,
                                                                   17)];
        _subClockLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:17];
        _subClockLabel.textColor = [UIColor whiteColor];
        _subClockLabel.backgroundColor = [UIColor clearColor];
        _subClockLabel.textAlignment = NSTextAlignmentCenter;
        _subClockLabel.text = @"until next step";
        [self addSubview:_subClockLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,
                                                                    _subClockLabel.frame.origin.y + _subClockLabel.frame.size.height + 20,
                                                                    292,
                                                                    50)];
        self.titleLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:40];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = self.step.title;
//        NSLog(@"self.step.title : %@", self.step.title);
//        NSLog(@"self.step.description : %@", self.step.description);
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
        NSRange range = [self.step.imageUrl rangeOfString:@".mov"];
        if (range.location != NSNotFound) {
            self.description.text = @"\nG  ---------------------------------------------\nD  ---------------------------------------------\nA  ---00-----------------55-----------------00\nE  22------00---22------------00---22--------\n\nG  ---------------------------------------------\nD  ---------------------------------------------\nA  ---00-----------------55-----------------00\nE  22------00---22------------00---22--------";
        }else {
            self.description.text = self.step.description;
        }
        
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

- (void)updateClock:(NSString *)timeString {
    _clockLabel.text = timeString;
}

- (void)resetClock {
    _clockLabel.text = [KRClockManager stringTimeForInt:(int)_step.time];
}

- (void)updateForLastStep {
    _clockLabel.text = @"Finished!";
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
