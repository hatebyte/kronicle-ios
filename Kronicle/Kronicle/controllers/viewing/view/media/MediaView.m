//
//  MediaView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "MediaView.h"
#import <QuartzCore/QuartzCore.h>
#import "KRFontHelper.h"

@interface MediaView () <UIGestureRecognizerDelegate> {
    @private
    UIViewAnimationTransition _transition;
    UILabel *_pauseLabel;
    UIView *_pauseView;
    UITapGestureRecognizer *_cellTapper;
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
        [_moviePlayer pause];
        [UIView animateWithDuration:.4f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _pauseView.alpha = 0;
                         }
                         completion:^(BOOL fin){
                             _pauseView.hidden = YES;
                         }];
    } else {
        [_moviePlayer play];
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
    
}

- (void)setMediaPath:(NSString*)mediaPath andType:(MediaViewType)type {
    if ([_mediaPath isEqualToString:mediaPath]) {
        return;
    }
    
    _transition =(type == MediaViewLeft) ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight;
    self.isVideo = NO;

    _mediaPath = mediaPath;
    [self stop];
    NSRange range = [_mediaPath rangeOfString:@".mov"];
    if (range.location != NSNotFound) {
        [self loadVideo];
    } else {
        _imageView.image = [UIImage imageNamed:mediaPath];
//        [self addSubview:_imageView];
        [self transitionViewToStage:_imageView];

    }
}

- (void)transitionViewToStage:(UIView *)view {
//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration: 0.7];
//    [UIView setAnimationTransition:_transition forView:view cache:NO];
    [self addSubview:view];
//    [UIView commitAnimations];
    
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
        
        __block id loadStateObs = [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayer queue:nil usingBlock:^(NSNotification *notification){
            [self playbackLoadStateChanged:notification];
        }];
        NSLog(@"loadStateObs : %@",loadStateObs);
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

- (void)pause {
    if (_moviePlayer == nil) return;
    [_moviePlayer pause];
}
- (void)play {
    if (_moviePlayer == nil) return;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
