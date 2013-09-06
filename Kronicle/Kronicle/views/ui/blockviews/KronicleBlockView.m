//
//  KronicleBlockView.m
//  Kronicle
//
//  Created by Scott on 8/25/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KronicleBlockView.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRClockManager.h"
#import <QuartzCore/QuartzCore.h>
#import "KRRatingModuleView.h"

@interface KronicleBlockView () <UIGestureRecognizerDelegate> {
    @private
    UILabel *_time;
    UITextView *_title;
    UIButton *_deleteButton;
    UIImageView *_imageView;
    UITapGestureRecognizer *_tapper;
    UIImageView *_profileFrame;
    UIImageView *_profileImage;
    UIView *_creatorView;
    UILabel *_creatorTitleLabel;
    Kronicle *_kronicle;
    KRRatingModuleView *_ratingView;
}

@end

@implementation KronicleBlockView

+ (CGFloat)blockHeight {
    return 154.f;
}

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle {
    self = [super initWithFrame:frame];
    if (self) {
        _kronicle = kronicle;
        int padding = 6;
        _imageView                      = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _imageView.image                = [UIImage imageWithContentsOfFile:kronicle.fullCoverURL];
        [self addSubview:_imageView];
        
        NSString *time = [KRClockManager displayTimeString:_kronicle.totalTime];
        time =([[time substringToIndex:1] isEqualToString:@"0"]) ? [time substringFromIndex:1] : time;
        NSString *descriptionString     = [NSString stringWithFormat:@"%@ \n%@", kronicle.title, time];
        
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
        _title.font                     = [KRFontHelper getFont:KRBrandonRegular withSize:16];
        _title.textColor                = [UIColor whiteColor];
        _title.backgroundColor          = [UIColor clearColor];
        _title.editable                 = NO;
        _title.layer.shadowColor        = [[UIColor blackColor] CGColor];
        _title.layer.shadowOffset       = CGSizeMake(.7f, .7f);
        _title.layer.shadowOpacity      = .7f;
        _title.layer.shadowRadius       = .7f;
        CGSize titleSize                = [_title sizeThatFits:CGSizeMake(frame.size.width-(padding*2), 2000)];
        _title.frame                    = CGRectMake(padding-6,
                                                     _imageView.frame.size.height - (titleSize.height - 3),
                                                     titleSize.width,
                                                     titleSize.height);
        [self addSubview:_title];

        NSInteger timeWidth = [time sizeWithFont:[KRFontHelper getFont:KRBrandonRegular withSize:16]].width + _title.frame.origin.x + 15;
        _ratingView = [[KRRatingModuleView alloc] initWithPoint:CGPointMake(timeWidth, (_title.frame.size.height + _title.frame.origin.y)-30 ) andStyle:KRRatingModuleBlock andRating:.7];
        [_ratingView setRating:_kronicle.rating];
        [self addSubview:_ratingView];
        
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
        
        _creatorView                    = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.frame.size.height, frame.size.width, 35)];
        _creatorView.backgroundColor    = [UIColor whiteColor];
        [self addSubview:_creatorView];
        
        _profileFrame                    = [[UIImageView alloc] initWithFrame:CGRectMake(0, _imageView.frame.size.height, 40, 35)];
        _profileFrame.image              = [UIImage imageNamed:@"profileframe"];
        _profileFrame.backgroundColor    = [UIColor clearColor];
        [self addSubview:_profileFrame];
        
        _profileImage                    = [[UIImageView alloc] initWithFrame:CGRectMake(0, _imageView.frame.size.height, 40, 35)];
        _profileImage.image              = [UIImage imageNamed:@"profileimage"];
        _profileImage.backgroundColor    = [UIColor clearColor];
        [self addSubview:_profileImage];
        
        _creatorTitleLabel              = [[UILabel alloc] initWithFrame:CGRectMake(_profileFrame.frame.size.width,
                                                                                    _imageView.frame.size.height,
                                                                                    frame.size.width - _profileFrame.frame.size.width,
                                                                                    35)];
        _creatorTitleLabel.font                     = [KRFontHelper getFont:KRBrandonMedium withSize:12];
        _creatorTitleLabel.textColor                = [UIColor blackColor];
        _creatorTitleLabel.backgroundColor          = [UIColor clearColor];
        _creatorTitleLabel.text                     = @"Julia Smith";
        [self addSubview:_creatorTitleLabel];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.2];
        
        [self addSubview:_deleteButton];
    }
    return self;
}

- (void)setDeleteIsHidden:(BOOL)deleteIsHidden {
    _deleteIsHidden = deleteIsHidden;
    _deleteButton.hidden = deleteIsHidden;
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
    if ([self.delegate respondsToSelector:@selector(kronicleBlockView:deleteKronicle:)]) {
        [self.delegate kronicleBlockView:self deleteKronicle:_kronicle];
    }
    
}

- (IBAction)editTapped:(id)sender {
    [self removeGestureRecognizer:_tapper];
    [self.delegate kronicleBlockView:self requestKronicle:_kronicle];
    
}


@end
