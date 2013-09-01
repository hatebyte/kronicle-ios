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
#import <QuartzCore/QuartzCore.h>

@interface StepBlockView () <UIGestureRecognizerDelegate> {
    @private
    //UILabel *_title;
    UILabel *_time;
    UITextView *_title;
    UIButton *_deleteButton;
    UITapGestureRecognizer *_tapper;
    __weak Step *_step;
}

@end

@implementation StepBlockView

- (id)initWithFrame:(CGRect)frame andStep:(Step *)step {
    self = [super initWithFrame:frame];
    if (self) {
        _step = step;
        int padding = 6;
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", _step.mediaUrl]];

        self.image                      = [UIImage imageWithContentsOfFile:imagePath];
        NSString *time = [KRClockManager stringTimeForInt:(int)_step.time];
        time =([[time substringToIndex:1] isEqualToString:@"0"]) ? [time substringFromIndex:1] : time;
        NSString *descriptionString     = [NSString stringWithFormat:@"%@ \n%@", _step.title, time];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 18.0f;
        paragraphStyle.maximumLineHeight = 18.0f;
        paragraphStyle.minimumLineHeight = 18.0f;
        
//        NSFont *font = [KRFontHelper getFont:KRBrandonMedium withSize:16];
        NSString *string = descriptionString;
        NSDictionary *attribute = @{ NSParagraphStyleAttributeName : paragraphStyle, };
        _title                          = [[UITextView alloc] init];
        _title.attributedText           = [[NSAttributedString alloc] initWithString:string attributes:attribute];
        //_title.text                     = descriptionString;
        _title.font                     = [KRFontHelper getFont:KRBrandonMedium withSize:16];
        _title.textColor                = [UIColor whiteColor];
        _title.backgroundColor          = [UIColor clearColor];
        _title.editable                 = NO;
        _title.layer.shadowColor        = [[UIColor blackColor] CGColor];
        _title.layer.shadowOffset       = CGSizeMake(.7f, .7f);
        _title.layer.shadowOpacity      = .7f;
        _title.layer.shadowRadius       = .7f;
        CGSize titleSize                = [_title sizeThatFits:CGSizeMake(frame.size.width-(padding*2), 2000)];
        _title.frame                    = CGRectMake(padding-6,
                                                     frame.size.height - (titleSize.height - 3),
                                                     titleSize.width,
                                                     titleSize.height);
        [self addSubview:_title];
        
        _tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapped:)];
        _tapper.cancelsTouchesInView = NO;
        _tapper.delegate = self;
        [self addGestureRecognizer:_tapper];

        _deleteButton                   = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor   = [UIColor clearColor];
        _deleteButton.frame             = CGRectMake(self.frame.size.width-40, 0, 40, 40);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"block-x"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];

        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [KRColorHelper orange];
    }
    return self;
}

- (id)initAsAddStepWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor            = [KRColorHelper turquoise];
        int labelheight                 = (frame.size.height / 6);
        UILabel *title                  = [[UILabel alloc] initWithFrame:CGRectMake(28,
                                                                                    ((frame.size.height - labelheight) * .5)-1,
                                                                                    frame.size.width-20,
                                                                                    labelheight)];
        title.font                      = [KRFontHelper getFont:KRBrandonRegular withSize:17];
        title.textColor                 = [UIColor whiteColor];
        title.backgroundColor           = [UIColor clearColor];
        title.text                      = @"Add step";
        [self addSubview:title];
        
        UIImageView *plus               = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"plus_21px"]];
        plus.frame                      = CGRectMake(frame.size.width-47,
                                                     (frame.size.height - 21) * .5,
                                                     21,
                                                     21);
        plus.backgroundColor            = [UIColor clearColor];
        [self addSubview:plus];
    
        _tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addStepTapped:)];
        _tapper.cancelsTouchesInView = NO;
        _tapper.delegate = self;
        [self addGestureRecognizer:_tapper];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma gesture regocognizers delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

- (IBAction)deleteTapped:(id)sender {
    NSLog(@"deleteButton");
    [self.delegate stepBlockView:self deleteStepIndex:_step.indexInKronicle];

}

- (IBAction)editTapped:(id)sender {
    NSLog(@"tapped");
    [self.delegate stepBlockView:self requestStepIndex:_step.indexInKronicle];
    
}

- (IBAction)addStepTapped:(id)sender {
    NSLog(@"tapped");
    [self.delegate stepBlockViewAddStep:self];
    
}

@end
