//
//  AddStepTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddStepTableViewCell.h"
#import "KRGlobals.h"
#import "StepBlockView.h"

@interface AddStepTableViewCell () <StepBlockViewDelegate> {
    @private
    __weak NSArray *_stepArray;
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
        self.selectionStyle                     = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor        = [UIColor clearColor];

    }
    return self;
}

- (void)prepareForReuseWithArray:(NSArray *)stepArray {
    _stepArray = stepArray;
    int i = 0;
    for (int i=0; i<[self.contentView.subviews count]; i++) {
        [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
    }
    i = 0;
    int size = [AddStepTableViewCell cellHeight]-kPadding;
    CGRect frame = CGRectMake(kPadding, 0, size, size);
    for (i = 0; i < _stepArray.count; i++) {
        frame.origin = CGPointMake((kPadding-1) + ((size + kPadding) * i), 0);
        id s = [_stepArray objectAtIndex:i];
        StepBlockView *sb;
        if ([s isKindOfClass:[NSString class]]) {
            sb = [[StepBlockView alloc] initAsAddStepWithFrame:frame];
        } else {
            sb = [[StepBlockView alloc] initWithFrame:frame andStep:s];
        }
        sb.tag = i;
        sb.delegate = self;
        [self.contentView addSubview:sb];
    }
    
    
}


#pragma mark StepBlockView
- (void)stepBlockView:(StepBlockView *)stepBlockView deleteStepIndex:(int)stepIndex {
    [self.delegate stepDeletionRequested:self forStep:[_stepArray objectAtIndex:stepBlockView.tag]];
}

- (void)stepBlockView:(StepBlockView *)stepBlockView requestStepIndex:(int)stepIndex {
    [self.delegate stepEditingRequested:self forStep:[_stepArray objectAtIndex:stepBlockView.tag]];
}



@end
