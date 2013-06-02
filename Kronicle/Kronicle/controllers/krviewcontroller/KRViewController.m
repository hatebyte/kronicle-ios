//
//  KRViewController.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRViewController.h"
#import "KRStep.h"
#import "DescriptionView.h"
#import "KRViewListTypeViewController.h"
#import "KRColorHelper.h"

#define kScrollViewNormal 320.f
#define kScrollViewUp 180.f

@interface KRViewController ()

@end

@implementation KRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.kronicle = kronicle;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bounds = [UIScreen mainScreen].bounds;
    _clock = [KRClock sharedClock];
    _clock.delegate = self;

    _navView = [[KRKronicleNavView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, 47)];
    _navView.delegate = self;
    [_navView setTitleText:@"00:00"];
    [self.view addSubview:_navView];
    
    _mediaViewA = [[MediaView alloc] initWithFrame:CGRectMake(0, _navView.frame.size.height, _bounds.size.width, _bounds.size.width)];
    [self.view addSubview:_mediaViewA];
    _mediaViewB = [[MediaView alloc] initWithFrame:_mediaViewA.frame];
    [self.view addSubview:_mediaViewB];
    [_mediaViewB setMediaPath:[(KRStep*)[self.kronicle.steps objectAtIndex:0] imageUrl] andType:MediaViewImage];
    
    _circleDiagram = [[KRDiagramView alloc] initWithFrame:CGRectMake((_bounds.size.width - 285) * .5,
                                                                     (_bounds.size.width - 285) * .5 + 47,
                                                                     285,
                                                                     285)];
    _circleDiagram.delegate = self;
    _circleDiagram.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.view addSubview:_circleDiagram];
    
    _totalbar = [[UIView alloc] initWithFrame:CGRectMake(0, _navView.frame.size.height, 320, 5)];
    _totalbar.backgroundColor = [UIColor whiteColor];
    _totalbar.alpha = .3f;
    [self.view addSubview:_totalbar];
    
    _progressbar = [[UIView alloc] initWithFrame:CGRectMake(0, _navView.frame.size.height, 0, 5)];
    _progressbar.backgroundColor = [KRColorHelper darkBlue];
    [self.view addSubview:_progressbar];

    _scrollView = [[KRSwipeUpScrollView alloc] initWithFrame:CGRectMake(0, _mediaViewB.frame.origin.y + _mediaViewB.frame.size.height, _bounds.size.width, [KRSwipeUpScrollView maxHeight])];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320 * [self.kronicle.steps count], [KRSwipeUpScrollView maxHeight]);
    _scrollView.delegate = self;
    for (int i = 0; i < [self.kronicle.steps count]; i++) {
        KRStep *s = [self.kronicle.steps objectAtIndex:i];
        DescriptionView *d = [[DescriptionView alloc] initWithFrame:CGRectMake(_bounds.size.width * i,
                                                                               0,
                                                                               _bounds.size.width,
                                                                               [KRSwipeUpScrollView maxHeight]) andStep:s];
        [_scrollView addSubview:d];
    }
    [self.view addSubview:_scrollView];
    
    _listViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    _listViewButton.frame = CGRectMake(_circleDiagram.frame.size.width + _circleDiagram.frame.origin.x - _listViewButton.frame.size.width,
                                       _circleDiagram.frame.size.height + _circleDiagram.frame.origin.y - _listViewButton.frame.size.height,
                                       _listViewButton.frame.size.width,
                                       _listViewButton.frame.size.height);
    [_listViewButton addTarget:self action:@selector(goToKronicleListView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_listViewButton];
    
    UIImageView *gradient = [[UIImageView alloc] initWithFrame:CGRectMake(0, _bounds.size.height-60, _bounds.size.width, 60)];
    gradient.image = [UIImage imageNamed:@"bottom-shadow"];
    [self.view addSubview:gradient];
    
    KRStep *s = [self.kronicle.steps objectAtIndex:0];
    _currentStep = 0;
    _circleDiagram.imagePath =s.circleUrl;

    [_clock calibrateForKronicle:[self.kronicle.steps count]];
    [_clock resetWithTime:s.time];
    [_clock play];
}

// sets the right picture/video
- (void)setActiveMedia:(KRStep*)step {
    [_mediaViewA setMediaPath:_mediaViewB.mediaPath andType:MediaViewImage];
    _mediaViewB.alpha = 0.f;
    [_mediaViewB setMediaPath:step.imageUrl andType:MediaViewImage];
    _circleDiagram.imagePath = step.circleUrl;
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _mediaViewB.alpha = 1.f;
                         _circleDiagram.alpha = 1.f;
                     }
                     completion:^(BOOL fin){
                         [_navView isCurrentStep:(_currentStep == _clock.index)];
                     }];

}

- (IBAction)goToKronicleListView:(id)sender {
    KRViewListTypeViewController *listTypeViewController = [[KRViewListTypeViewController alloc] initWithNibName:@"KRViewListTypeViewController" andKronicle:self.kronicle completion:^(int step){
        if ([_clock isPaused]) {
            [_clock play];
            _navView.pauseButton.selected = NO;
        }
        _clock.index = step;
        [self jumpToStep:step andPlay:NO];
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    listTypeViewController.currentStep = _currentStep;
    [_clock pause];
    [listTypeViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:listTypeViewController animated:YES completion:^{}];
}

- (IBAction)togglePlayPause:(id)sender {}


#pragma SwipeScrollView 

- (void)scrollView:(KRSwipeUpScrollView*)scrollView swipedUpWithDistance:(int)distance {
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scrollView.frame = CGRectMake(0, kScrollViewUp, _bounds.size.width, [KRSwipeUpScrollView maxHeight]);
                         _listViewButton.frame = CGRectMake(_circleDiagram.frame.size.width + _circleDiagram.frame.origin.x - _listViewButton.frame.size.width,
                                                            _scrollView.frame.origin.y - (_listViewButton.frame.size.height + 10),
                                                            _listViewButton.frame.size.width,
                                                            _listViewButton.frame.size.height);
                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)scrollView:(KRSwipeUpScrollView*)scrollView swipedDownWithDistance:(int)distance {
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scrollView.frame = CGRectMake(0,
                                                        _mediaViewB.frame.origin.y + _mediaViewB.frame.size.height,
                                                        _bounds.size.width, [KRSwipeUpScrollView maxHeight]);
                         _listViewButton.frame = CGRectMake(_circleDiagram.frame.size.width + _circleDiagram.frame.origin.x - _listViewButton.frame.size.width,
                                                            _scrollView.frame.origin.y - (_listViewButton.frame.size.height + 10),
                                                            _listViewButton.frame.size.width,
                                                            _listViewButton.frame.size.height);

                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateScrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateScrollView];
}

// updates from pan position
- (void)updateScrollView {
    int index = _scrollView.contentOffset.x / _bounds.size.width;
    _currentStep = index;
//    [UIView animateWithDuration:.2
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _circleDiagram.alpha = 0.f;
//                     }
//                     completion:^(BOOL fin){
                         [self setActiveMedia:(KRStep*)[self.kronicle.steps objectAtIndex:_currentStep]];
//                     }];
}

// updates from suggested index
- (void)jumpToStep:(int)index andPlay:(BOOL)play{
    if(play) {
        [_navView isCurrentStep:YES];
    }
    if (_currentStep == index) return;
    CGRect frame = CGRectMake(_scrollView.frame.size.width * index,
                              _scrollView.frame.origin.y,
                              _scrollView.frame.size.width,
                              _scrollView.frame.size.height);
//    [UIView animateWithDuration:.2
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _circleDiagram.alpha = 0.f;
//                     }
//                     completion:^(BOOL fin){
                         [_scrollView scrollRectToVisible:frame animated:YES];
//                     }];
}


#pragma CircleDiagramView
- (void)diagramView:(KRDiagramView*)diagramView withDegree:(CGFloat)percent {
    int index = [self returnIndexForPercent:percent andIndex:0];
    
    _clock.index = index;
    KRStep *s = [self.kronicle.steps objectAtIndex:_clock.index];
    [_clock resetWithTime:s.time];
    if ([_clock isPaused]) [_clock play];
    [self jumpToStep:_clock.index andPlay:YES];
}

- (int)returnIndexForPercent:(CGFloat)percent andIndex:(int)index{
    CGFloat time = 0;
    for (int i=0;i<index; i++) {
        KRStep *s = [self.kronicle.steps objectAtIndex:i];
        time += s.time;
    }
    float timePercent = (time / self.kronicle.totalTime);
    if (timePercent < percent) {
        return [self returnIndexForPercent:percent andIndex:index+1];
    } else {
        return index-1;
    }
}


#pragma clock
- (void)clock:(KRClock*)clock updateWithTimeString:(NSString*)string andPercent:(CGFloat)percent {
    [_navView setTitleText:string];
    [_navView setSubText:@"until next step"];
    _progressbar.frame = CGRectMake(0, _navView.frame.size.height, 320 * percent, 5);
}

- (void)clockTimeOver:(KRClock*)clock {
    _clock.index += 1;
    KRStep *s = [self.kronicle.steps objectAtIndex:_clock.index];
    [_clock resetWithTime:s.time];
    [self jumpToStep:_clock.index andPlay:YES];
}

- (void)kronicleTimeOver:(KRClock*)clock {
    [_navView setTitleText:@"Finished!"];
    [_navView setSubText:@""];
    _currentStep = _clock.maxIndex;
}


#pragma navView

- (void)navViewBack:(KRKronicleNavView*)navView {
    [_clock pause];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navViewPlayPause:(KRKronicleNavView*)navView {
//    NSLog(@"[_clock isPaused] : %d", [_clock isPaused]);
    if ([_clock isPaused]) {
        [_clock play];
    } else {
        [_clock pause];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
