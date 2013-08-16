//
//  AddStepTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddStepTableViewCell.h"
#import "KRStep.h"
#import "KRGlobals.h"
#import "StepBlockView.h"

@interface AddStepTableViewCell () {
    @private
}

@end


@implementation AddStepTableViewCell

+ (CGFloat)cellHeight {
    return 154.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                 = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareForReuseWithArray:(NSArray *)stepArray {
    int i = 0;
    for (int i=0; i<[self.contentView.subviews count]; i++) {
        [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
    }
    i = 0;
    int size = [AddStepTableViewCell cellHeight]-kPadding;
    CGRect frame = CGRectMake(kPadding, 0, size, size);
    for (i = 0; i < stepArray.count; i++) {
        frame.origin = CGPointMake((kPadding-1) + ((size + kPadding) * i), 0);
        id s = [stepArray objectAtIndex:i];
        StepBlockView *sb;
        if ([s isKindOfClass:[NSString class]]) {
            sb = [[StepBlockView alloc] initAsAddStepWithFrame:frame];
        } else {
            sb = [[StepBlockView alloc] initWithFrame:frame andStep:s];
        }
        [self.contentView addSubview:sb];
    }
    
    
}


@end
