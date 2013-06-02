//
//  MediaView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "MediaView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MediaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
    }
    return self;
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setMediaPath:(NSString*)mediaPath andType:(MediaViewType)type {
    self.isVideo = NO;

    _mediaPath = mediaPath;
    [self stop];
    NSRange range = [_mediaPath rangeOfString:@".mov"];
    if (range.location != NSNotFound) {
        [self loadVideo];
    } else {
        _imageView.image = [UIImage imageNamed:mediaPath];
    }

}

- (void)loadVideo {
    self.isVideo = YES;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/crazy_train_1.mov", [[NSBundle mainBundle] resourcePath]]];
    if (_moviePlayer != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    } else {
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:nil];
        _moviePlayer.repeatMode = MPMovieRepeatModeOne;
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayer.useApplicationAudioSession = NO;
        //_moviePlayer.view.layer.masksToBounds = YES;
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        __block id loadStateObs = [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayer queue:nil usingBlock:^(NSNotification *notification){
            [self playbackLoadStateChanged:notification];
        }];
    }
    _moviePlayer.view.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
    _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    

    _moviePlayer.contentURL = url;
    [_moviePlayer play];
    //NSLog(@"video url:%@", [url absoluteString]);
}

-(void) playbackLoadStateChanged:(NSNotification *)note {
    if (_moviePlayer.loadState & MPMovieLoadStateStalled) {
        [_moviePlayer pause];
    } else if (_moviePlayer.loadState & (MPMovieLoadStatePlayable | MPMovieLoadStatePlaythroughOK)) {
        [_moviePlayer play];
        [self addSubview:_moviePlayer.view];
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
