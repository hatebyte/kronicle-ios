//
//  KRPublishKronicleModule.m
//  Kronicle
//
//  Created by Scott on 8/31/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRPublishKronicleModule.h"
#import "Kronicle+Helper.h"
#import <QuartzCore/QuartzCore.h>
#import "KRGlobals.h"
#import "KRClockManager.h"

@interface KRPublishKronicleModule () {
    @private
    __weak Kronicle *_kronicle;
    UITextView *_titleLabel;
    UILabel *_timeLabel;
    UIImageView *_fpoImageView;
}

@end

@implementation KRPublishKronicleModule

+ (CGFloat)width {
    return 240.f;
}

+ (CGFloat)height {
    return 333.f;
}

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle {
    self = [super initWithFrame:frame];
    if (self) {
        _kronicle = kronicle;
        
        self.clipsToBounds          = YES;
        self.backgroundColor = [UIColor clearColor];
        NSInteger grayY                     = 165;

        _coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (grayY - frame.size.width) * .5, frame.size.width, frame.size.width)];
        _coverImage.image = [UIImage imageWithContentsOfFile:_kronicle.fullCoverURL];
        _coverImage.backgroundColor   = [UIColor blackColor];
        [self addSubview:_coverImage];
        
        
        NSMutableParagraphStyle *paragraphStyle         = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple               = 30.f;
        paragraphStyle.maximumLineHeight                = 30.f;
        paragraphStyle.minimumLineHeight                = 30.f;
        
        NSString *string                     = _kronicle.title;
        NSDictionary *attribute              = @{ NSParagraphStyleAttributeName : paragraphStyle, };
        _titleLabel                          = [[UITextView alloc] initWithFrame:CGRectMake(kPadding-10, 54, frame.size.width - (2 * kPadding), 300)];
        _titleLabel.attributedText           = [[NSAttributedString alloc] initWithString:string attributes:attribute];
        _titleLabel.font                     = [KRFontHelper getFont:KRBrandonLight withSize:30];
        _titleLabel.textColor                = [UIColor whiteColor];
        _titleLabel.backgroundColor          = [UIColor clearColor];
        _titleLabel.editable                 = NO;
        _titleLabel.layer.shadowColor        = [[UIColor blackColor] CGColor];
        _titleLabel.layer.shadowOffset       = CGSizeMake(.7f, .7f);
        _titleLabel.layer.shadowOpacity      = .7f;
        _titleLabel.layer.shadowRadius       = .7f;
        _titleLabel.backgroundColor          = [UIColor clearColor];
        CGSize titleSize                     = [_titleLabel sizeThatFits:CGSizeMake(_titleLabel.frame.size.width, 2000)];
        NSLog(@"titleSize.heght: %f", titleSize.height);
        [self addSubview:_titleLabel];
        
        
        NSString *time = [KRClockManager stringTimeForInt:_kronicle.totalTime];
        time =([[time substringToIndex:1] isEqualToString:@"0"]) ? [time substringFromIndex:1] : time;
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding,
                                                               0,
                                                               frame.size.width - (2 * kPadding),
                                                               26)];
        _timeLabel.font                     = [KRFontHelper getFont:KRBrandonLight withSize:24];
        _timeLabel.textColor                = [UIColor whiteColor];
        _timeLabel.backgroundColor          = [UIColor clearColor];
        _timeLabel.text                     = time;
        _timeLabel.layer.shadowColor        = [[UIColor blackColor] CGColor];
        _timeLabel.layer.shadowOffset       = CGSizeMake(.7f, .7f);
        _timeLabel.layer.shadowOpacity      = .7f;
        _timeLabel.layer.shadowRadius       = .7f;
        [self addSubview:_timeLabel];
        
        NSInteger y                         = (165 - (titleSize.height + _timeLabel.frame.size.height)) * .5;
        _titleLabel.frame                   = CGRectMake(_titleLabel.frame.origin.x,
                                                          y+10,
                                                          _titleLabel.frame.size.width,
                                                          titleSize.height);
        _timeLabel.frame                    = CGRectMake(_timeLabel.frame.origin.x,
                                                          _titleLabel.frame.origin.y + _titleLabel.frame.size.height,
                                                          _timeLabel.frame.size.width,
                                                          _timeLabel.frame.size.height);
        
        


        
        CALayer *grayLayer                  = [CALayer layer];
        grayLayer.backgroundColor           = [KRColorHelper grayLight].CGColor;
        grayLayer.frame                     = CGRectMake(0, grayY, frame.size.width, 38);

        _fpoImageView                       = [[UIImageView alloc] initWithFrame:CGRectMake(0, grayY, 240, 125)];
        _fpoImageView.image                 = [UIImage imageNamed:@"fpo_switches"];
        _fpoImageView.backgroundColor       = [UIColor clearColor];
        
        CALayer *whiteLayer                 = [CALayer layer];
        whiteLayer.backgroundColor          = [UIColor whiteColor].CGColor;
        whiteLayer.frame                    = _fpoImageView.frame;

        [self.layer addSublayer:whiteLayer];
        [self.layer addSublayer:grayLayer];
        [self addSubview:_fpoImageView];
        

        self.publishButton                      = [UIButton buttonWithType:UIButtonTypeCustom];
        self.publishButton.frame                = CGRectMake(0,
                                                         _fpoImageView.frame.size.height + _fpoImageView.frame.origin.y,
                                                         frame.size.width,
                                                         46);
        self.publishButton.backgroundColor      = [KRColorHelper turquoise];
        self.publishButton.titleLabel.font      = [KRFontHelper getFont:KRBrandonRegular withSize:17];

        [self.publishButton setTitle:@"Publish" forState:UIControlStateNormal];
        [self.publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_publishButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.publishButton];
        
        self.cameraButton                   = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cameraButton.frame             = CGRectMake(0,0, 42, 32);
        [self.cameraButton setImage:[UIImage imageNamed:@"camerabutton"] forState:UIControlStateNormal];
//        [self.cameraButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cameraButton];
        
        self.cancelButton                   = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame             = CGRectMake(frame.size.width - 42,0, 42, 32);
        [self.cancelButton setImage:[UIImage imageNamed:@"cancelpublish"] forState:UIControlStateNormal];
//        [self.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
    }
    return self;
}

@end
