//
//  MediaView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "MediaView.h"
#import <QuartzCore/QuartzCore.h>
#import "KRGlobals.h"

@interface MediaView () <UIGestureRecognizerDelegate> {
    @private
    UIViewAnimationTransition _transition;
    UILabel *_pauseLabel;
    UIView *_pauseView;
    UITapGestureRecognizer *_cellTapper;
    UISwipeGestureRecognizer *_cellLeftSwipper;
    UISwipeGestureRecognizer *_cellRightSwipper;
    
    UIView *_finishOverlay;
    UITextView *_titleLabel;
    UIButton *_shareButton;
    UIButton *_reviewButton;
}
@end

@implementation MediaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        _cellTapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _cellTapper.cancelsTouchesInView = NO;
        _cellTapper.delegate = self;
        
        _cellLeftSwipper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
        [_cellLeftSwipper setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        
        _cellRightSwipper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
        [_cellRightSwipper setDirection:(UISwipeGestureRecognizerDirectionRight)];

        int width = 200;
        int height = 62;
        _pauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, width, height)];
        _pauseLabel.text = @"Resume";
        _pauseLabel.textColor = [UIColor whiteColor];
        _pauseLabel.backgroundColor = [UIColor clearColor];
        _pauseLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:35];
        _pauseLabel.textAlignment = UITextAlignmentLeft;
        
        _pauseView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - width) * .5, (self.frame.size.height - height) * .5, width, height)];
        _pauseView.backgroundColor = [UIColor clearColor];
        
        CALayer *layer = [CALayer layer];
        [layer setBackgroundColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f] CGColor]];
        layer.frame = CGRectMake(0, 0,_pauseView.frame.size.width, _pauseView.frame.size.height);
        layer.cornerRadius = 30;
        [_pauseView.layer addSublayer:layer];
        [_pauseView addSubview:_pauseLabel];
        
        UIImageView *pauseArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pauseTriangle"]];
        pauseArrow.frame = CGRectMake((_pauseView.frame.size.width - 40),
                                      (_pauseView.frame.size.height - 22) * .5, 19, 22);
        _pauseView.alpha = 0;
        [_pauseView addSubview:pauseArrow];
        
        [self addSubview:_pauseView];
        [self addGestureRecognizer:_cellTapper];
        [self addGestureRecognizer:_cellRightSwipper];
        [self addGestureRecognizer:_cellLeftSwipper];

    }
    return self;
}

- (void)readdRecognizers {
    [self addSubview:_pauseView];
    [self addGestureRecognizer:_cellTapper];
    [self addGestureRecognizer:_cellRightSwipper];
    [self addGestureRecognizer:_cellLeftSwipper];
}

- (UIImage *)image {
    return _imageView.image;
}

-(void)swipeDetected:(UISwipeGestureRecognizer *)swipeRecognizer {
    
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
            [self.delegate mediaViewSwipedLeft];
    }
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.delegate mediaViewSwipedRight];
    }
}

- (IBAction)tapped:(id)sender {
    [self.delegate mediaViewScreenTapped:self];
}

- (void)hideResume {
    [UIView animateWithDuration:.4f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _pauseView.alpha = 0;
                     }
                     completion:^(BOOL fin){
                         
                     }];
}

- (void)showResume {
    [UIView animateWithDuration:.7f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _pauseView.alpha = 1;
                     }
                     completion:^(BOOL fin){
                         
                     }];
}

- (void)setMediaPath:(NSString*)mediaPath  {
    if ([_mediaPath isEqualToString:mediaPath]) {
        return;
    }

    _transition = UIViewAnimationTransitionNone;
    self.isVideo = NO;

    _mediaPath = mediaPath;
    [self stop];
    NSRange range = [_mediaPath rangeOfString:@".mov"];
    if (range.location != NSNotFound) {

        [self loadVideo];
    } else {
        __block UIImageView *imageViewCopy  = [[UIImageView alloc] initWithFrame:_imageView.frame];
        self.backgroundColor                = [UIColor blackColor];
        [self addSubview:_imageView];
        [self addSubview:imageViewCopy];
        [self readdRecognizers];
        
        
        imageViewCopy.image                 = _imageView.image;

        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", mediaPath]];
        _imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        
         
        [UIView animateWithDuration:.7f
                              delay:0.2f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             imageViewCopy.alpha = 0;
                         }
                         completion:^(BOOL fin){
                             [imageViewCopy removeFromSuperview];
                             imageViewCopy = nil;
                        }];
    }
    
}

- (void)loadVideo {
    self.isVideo = YES;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], _mediaPath]];
    if (_moviePlayer != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    } else {
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:nil];
        _moviePlayer.repeatMode = MPMovieRepeatModeOne;
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayer.useApplicationAudioSession = NO;
        _moviePlayer.view.layer.masksToBounds = YES;
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayer queue:nil usingBlock:^(NSNotification *notification){
            [self playbackLoadStateChanged:notification];
        }];
    }
    _moviePlayer.view.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
    _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    _moviePlayer.view.userInteractionEnabled = NO;
    [self addSubview:_moviePlayer.view];
    [self readdRecognizers];
    
    
    _moviePlayer.contentURL = url;
    [_moviePlayer play];
}

-(void) playbackLoadStateChanged:(NSNotification *)note {
    if (_moviePlayer.loadState & MPMovieLoadStateStalled) {
        [_moviePlayer pause];
    } else if (_moviePlayer.loadState & (MPMovieLoadStatePlayable | MPMovieLoadStatePlaythroughOK)) {
        [_moviePlayer play];
    }
}

- (void)playbackFinished:(NSNotification*)note {
    _moviePlayer.currentPlaybackTime = 0;
    [_moviePlayer play];
}

- (void)stop {
    if (_moviePlayer == nil) return;
    
    [_moviePlayer stop];
    [_moviePlayer setFullscreen:NO animated:YES];
    [_moviePlayer.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:_moviePlayer];
    _moviePlayer = nil;
}

- (void)updateForFinishedWithImage:(NSString *)coverImageUrl andTitle:(NSString *)title {
    [self setMediaPath:coverImageUrl];
    [self hideResume];
    
    
    NSInteger buttonHeight                                     = 40;
   
    _finishOverlay                          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _finishOverlay.backgroundColor          = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.6f];
    _finishOverlay.alpha                    = 0.f;
    _finishOverlay.hidden                   = YES;
    
    NSMutableParagraphStyle *paragraphStyle         = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple               = 42.f;
    paragraphStyle.maximumLineHeight                = 42.f;
    paragraphStyle.minimumLineHeight                = 42.f;
    
    //        NSFont *font = [KRFontHelper getFont:KRBrandonMedium withSize:16];
    NSString *string                     = title; //@"This is a long title for a kronicle";
    NSDictionary *attribute              = @{ NSParagraphStyleAttributeName : paragraphStyle, };
    _titleLabel                          = [[UITextView alloc] initWithFrame:CGRectMake(kPadding, 54, 300, 50)];
    _titleLabel.attributedText           = [[NSAttributedString alloc] initWithString:string attributes:attribute];
    //_title.text                        = descriptionString;
    _titleLabel.font                     = [KRFontHelper getFont:KRBrandonLight withSize:46];
    _titleLabel.textColor                = [UIColor whiteColor];
    _titleLabel.backgroundColor          = [UIColor clearColor];
    _titleLabel.editable                 = NO;
    _titleLabel.layer.shadowColor        = [[UIColor blackColor] CGColor];
    _titleLabel.layer.shadowOffset       = CGSizeMake(.7f, .7f);
    _titleLabel.layer.shadowOpacity      = .7f;
    _titleLabel.layer.shadowRadius       = .7f;
    _titleLabel.backgroundColor          = [UIColor clearColor];
    CGSize titleSize                     = [_titleLabel sizeThatFits:CGSizeMake(320 - (2 * kPadding), 2000)];
    _titleLabel.frame                    = CGRectMake(kPadding-8,
                                                      (_finishOverlay.frame.size.height - (titleSize.height + buttonHeight + 20)) * .5,
                                                      _titleLabel.frame.size.width,
                                                      titleSize.height);
    [_finishOverlay addSubview:_titleLabel];
    
    _reviewButton                                              = [UIButton buttonWithType:UIButtonTypeCustom];
    _reviewButton.backgroundColor                              = [KRColorHelper turquoise];
    _reviewButton.titleLabel.font                              = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    _reviewButton.frame                                        = CGRectMake(kPadding, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 20, 80, buttonHeight);
    [_reviewButton setTitle:NSLocalizedString(@"Review", @"finished screen review button") forState:UIControlStateNormal];
    [_reviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [_shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [_finishOverlay addSubview:_reviewButton];
    
    _shareButton                                              = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.backgroundColor                              = [KRColorHelper turquoise];
    _shareButton.titleLabel.font                              = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    _shareButton.frame                                        = CGRectMake(kPadding + _reviewButton.frame.origin.x + _reviewButton.frame.size.width,
                                                                            _reviewButton.frame.origin.y,
                                                                            _reviewButton.frame.size.width,
                                                                            _reviewButton.frame.size.height);
    [_shareButton setTitle:NSLocalizedString(@"Share", @"finished screen share button") forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reviewButton addTarget:self action:@selector(review) forControlEvents:UIControlEventTouchUpInside];
    [_finishOverlay addSubview:_shareButton];
    
    [self addSubview:_finishOverlay];
    [self animateInFinishedOverlay];
    
    [self readdRecognizers];
    
    


}

- (void)animateInFinishedOverlay {
    _finishOverlay.hidden = NO;
    _finishOverlay.alpha = 0.f;    
    [UIView animateWithDuration:1.f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _finishOverlay.alpha = 1.f;
                     }
                     completion:^(BOOL fin){
                         
                     }];
}

- (void)animateOutFinishedOverlay {
    [self addSubview:_finishOverlay];
    [UIView animateWithDuration:1.f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _finishOverlay.alpha = 0.f;
                     }
                     completion:^(BOOL fin){
                         _finishOverlay.hidden = YES;
                     }];
}

- (void)review {
    [[NSNotificationCenter defaultCenter] postNotificationName:kKronicleReviewRequested object:nil];
}

#pragma gesture regocognizers delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

@end
















