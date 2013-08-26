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
    
    UIView *_finishOverlay;
    UITextView *_description;
    UIButton *_shareButton;
    UIButton *_reviewButton;
}
@end

@implementation MediaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backgroundColor = [UIColor blackColor];
        
        _cellTapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _cellTapper.cancelsTouchesInView = NO;
        _cellTapper.delegate = self;
        [self addGestureRecognizer:_cellTapper];
        
        int width = 178;
        int height = 62;
        _pauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, width, height)];
        _pauseLabel.text = @"Paused";
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
        _pauseView.hidden = YES;
        _pauseView.alpha = 0;
        [_pauseView addSubview:pauseArrow];

        [self addSubview:_pauseView];
    }
    return self;
}

- (UIImage *)image {
    return _imageView.image;
}

- (IBAction)tapped:(id)sender {
    [self.delegate mediaViewScreenTapped:self];
}

- (void)togglePlayPause:(BOOL)isPaused {
    if (!isPaused) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)play {
    if (_moviePlayer != nil) {
        [_moviePlayer play];
    }
    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _pauseView.alpha = 0;
                     }
                     completion:^(BOOL fin){
                         _pauseView.hidden = YES;
                     }];
}

- (void)pause {
    if (_moviePlayer != nil) {
        [_moviePlayer pause];
    }
    _pauseView.hidden = NO;
    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _pauseView.alpha = 1;
                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)setMediaPath:(NSString*)mediaPath andType:(MediaViewType)type {
    if ([_mediaPath isEqualToString:mediaPath]) {
        return;
    }
    //[self animateOutFinishedOverlay];

    _transition =(type == MediaViewLeft) ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight;
    self.isVideo = NO;

    _mediaPath = mediaPath;
    [self stop];
    NSRange range = [_mediaPath rangeOfString:@".mov"];
    if (range.location != NSNotFound) {
        [self loadVideo];
    } else {
        //_imageView.image = [UIImage imageNamed:mediaPath];

        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", mediaPath]];
        NSLog(@"imagePath : %@",imagePath);
        _imageView.image = [UIImage imageWithContentsOfFile:imagePath];
//        [self addSubview:_imageView];
        [self transitionViewToStage:_imageView];

    }
    
}

- (void)transitionViewToStage:(UIView *)view {
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.7];
    [UIView setAnimationTransition:_transition forView:view cache:NO];
    [self addSubview:view];
    [UIView commitAnimations];
    
    [self addSubview:_pauseView];
    [self addGestureRecognizer:_cellTapper];
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

    _moviePlayer.contentURL = url;
    [_moviePlayer play];
}

-(void) playbackLoadStateChanged:(NSNotification *)note {
    if (_moviePlayer.loadState & MPMovieLoadStateStalled) {
        [_moviePlayer pause];
    } else if (_moviePlayer.loadState & (MPMovieLoadStatePlayable | MPMovieLoadStatePlaythroughOK)) {
        [_moviePlayer play];
        [self transitionViewToStage:_moviePlayer.view];
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
    [self setMediaPath:coverImageUrl andType:MediaViewRight];
    
    _finishOverlay                          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _finishOverlay.backgroundColor          = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.6f];
    _finishOverlay.alpha                    = 0.f;
    _finishOverlay.hidden                   = YES;
    
    _description                            = [[UITextView alloc] init];
    _description.font                       = [KRFontHelper getFont:KRBrandonLight withSize:46];
    _description.text                       = title;
    _description.scrollEnabled              = NO;
    _description.textColor                  = [UIColor whiteColor];
    _description.editable                   = NO;
    _description.backgroundColor            = [UIColor clearColor];
    CGSize descriptionSize                  = [_description sizeThatFits:CGSizeMake(320 - (2 * kPadding), 2000)];
    _description.frame                      = CGRectMake(kPadding, 50, descriptionSize.width, descriptionSize.height);
    [_finishOverlay addSubview:_description];
    
    NSInteger buttonHeight                                     = 40;
    _reviewButton                                              = [UIButton buttonWithType:UIButtonTypeCustom];
    _reviewButton.backgroundColor                              = [KRColorHelper turquoise];
    _reviewButton.titleLabel.font                              = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    _reviewButton.frame                                        = CGRectMake(kPadding, _description.frame.origin.y + _description.frame.size.height + 20, 80, buttonHeight);
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
    //    [_reviewButton addTarget:self action:@selector(review) forControlEvents:UIControlEventTouchUpInside];
    [_finishOverlay addSubview:_shareButton];
    
    [self addSubview:_finishOverlay];
    [self animateInFinishedOverlay];
}

- (void)animateInFinishedOverlay {
    _finishOverlay.hidden = NO;
    _finishOverlay.alpha = 0.f;
    [UIView animateWithDuration:.5
                          delay:.7f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _finishOverlay.alpha = 1.f;
                     }
                     completion:^(BOOL fin){
                     }];
    
}

- (void)animateOutFinishedOverlay {
    [UIView animateWithDuration:.5
                          delay:.7f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _finishOverlay.alpha = 0.f;
                     }
                     completion:^(BOOL fin){
                         _finishOverlay.hidden = YES;
                     }];
    
}

@end
















