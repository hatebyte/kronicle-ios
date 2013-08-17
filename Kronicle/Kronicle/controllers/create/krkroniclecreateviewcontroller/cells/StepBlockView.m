//
//  StepBlockView.m
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "StepBlockView.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRClockManager.h"

@interface StepBlockView () <UIGestureRecognizerDelegate> {
    @private
    UILabel *_title;
    UILabel *_time;
    UIButton *_deleteButton;
    UITapGestureRecognizer *_tapper;
    __weak KRStep *_step;
}

@end

@implementation StepBlockView

- (id)initWithFrame:(CGRect)frame andStep:(KRStep *)step {
    self = [super initWithFrame:frame];
    if (self) {
        _step = step;
        int padding = 6;
        self.image                      = [UIImage imageNamed:_step.imageUrl];

        int labelheight = (frame.size.height / 8);
        _title                          = [[UILabel alloc] initWithFrame:CGRectMake(padding, labelheight * 6, frame.size.width-(padding*2), labelheight-5)];
        _title.font                     = [KRFontHelper getFont:KRBrandonMedium withSize:16];
        _title.textColor                = [UIColor whiteColor];
        _title.backgroundColor          = [UIColor clearColor];
        _title.text                     = _step.title;
        [self addSubview:_title];

        _time                           = [[UILabel alloc] initWithFrame:CGRectMake(padding, _title.frame.origin.y + _title.frame.size.height + 2, frame.size.width-(padding*2), labelheight-5)];
        _time.text                      = [KRClockManager stringTimeForInt:_step.time];
        _time.font                      = [KRFontHelper getFont:KRBrandonMedium withSize:16];
        _time.textColor                 = [UIColor whiteColor];
        _time.backgroundColor           = [UIColor clearColor];
        [self addSubview:_time];
        
        _tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _tapper.cancelsTouchesInView = NO;
        _tapper.delegate = self;
        //[self addGestureRecognizer:_tapper];
        
        _deleteButton                   = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor   = [UIColor clearColor];
        _deleteButton.frame             = CGRectMake(self.frame.size.width-20, 0, 20, 20);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"close-x_40px"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
    
    }
    return self;
}

- (id)initAsAddStepWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [KRColorHelper turquoise];
        int labelheight = (frame.size.height / 8);
        _title                          = [[UILabel alloc] initWithFrame:CGRectMake(20, labelheight * 3.5, frame.size.width-20, labelheight)];
        _title.font                     = [KRFontHelper getFont:KRBrandonRegular withSize:18];
        _title.textColor                = [UIColor whiteColor];
        _title.backgroundColor          = [UIColor clearColor];
        _title.text                     = @"Add step";
        [self addSubview:_title];

    }
    return self;
}

- (IBAction)deleteButton:(id)sender {
    NSLog(@"deleteButton");
    [self.delegate stepBlockView:self deleteStepIndex:_step.uuid];

}

- (IBAction)tapped:(id)sender {
    NSLog(@"tapped");
    [self.delegate stepBlockView:self requestStepIndex:_step.uuid];

}

@end
