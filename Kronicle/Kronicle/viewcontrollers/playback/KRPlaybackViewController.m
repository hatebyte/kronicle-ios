//
//  KRPlaybackViewController.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRPlaybackViewController.h"

@interface KRPlaybackViewController () {
    
}

@end

@implementation KRPlaybackViewController

- (id)initWithKronicle:(Kronicle *)kronicle {
    self = [super initWithNibName:@"KRPlaybackViewController" bundle:nil];
    if (self) {
        self.kronicle = kronicle;
        
    }
    return self;
}
- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kKronicleReviewRequested object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    _bounds = [UIScreen mainScreen].bounds;
    
    CALayer *blackBackground                        = [CALayer layer];
    blackBackground.frame                           = CGRectMake(0, 0, 320, _bounds.size.height * .5);
    blackBackground.backgroundColor                 = [UIColor colorWithRed:.1f green:.1f blue:.1f alpha:0.9f].CGColor;
    [self.view.layer addSublayer:blackBackground];
    
    _globalClockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
    _globalClockLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:38];
    _globalClockLabel.textColor = [UIColor whiteColor];
    _globalClockLabel.backgroundColor = [UIColor clearColor];
    _globalClockLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_globalClockLabel];
    
    _subGlobalClockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                     _globalClockLabel.frame.origin.y + _globalClockLabel.frame.size.height+4,
                                                                     320,
                                                                     17)];
    _subGlobalClockLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    _subGlobalClockLabel.textColor = [UIColor whiteColor];
    _subGlobalClockLabel.backgroundColor = [UIColor clearColor];
    _subGlobalClockLabel.textAlignment = NSTextAlignmentCenter;
    _subGlobalClockLabel.text = @"until finished!";
    [self.view addSubview:_subGlobalClockLabel];

    _sview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height-20)];
    _sview.showsVerticalScrollIndicator = YES;
    _sview.showsHorizontalScrollIndicator = NO;
    _sview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sview];
    
    _kronicleManager = [[KRKronicleManager alloc] initWithKronicle:self.kronicle];
    _kronicleManager.delegate = self;
    
    _clockManager = [[KRClockManager alloc] initWithKronicle:self.kronicle];
    _clockManager.delegate = self;
    
    _mediaView = [[MediaView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _mediaView.delegate = self;
    [_sview addSubview:_mediaView];
    
    _scrollView = [[KRScrollView alloc] initWithFrame:CGRectMake(0, _mediaView.frame.origin.y + _mediaView.frame.size.height, 320, 310) andKronicle:self.kronicle];
    _scrollView.scrollDelegate = self;
    _scrollView.contentSize = CGSizeMake(320 * ([_kronicle.steps count]+1), [KRScrollView playbackHeight]);
   [_sview addSubview:_scrollView];
    
    _stepNavigation = [[KRStepNavigation alloc] initWithFrame:CGRectMake(0, _mediaView.frame.origin.y + _mediaView.frame.size.height-40, 320, 100)];
    _stepNavigation.delegate = self;
    [_sview addSubview:_stepNavigation];
    
    int y = _scrollView.frame.origin.y + _scrollView.frame.size.height;
    _stepListContainerView = [[KRStepListContainerView alloc] initWithFrame:CGRectMake(0, y, 320, 0) andSteps:_kronicle.steps];
    _stepListContainerView.delegate = self;
    [_sview addSubview:_stepListContainerView];

    y = _stepListContainerView.frame.origin.y + _stepListContainerView.frame.size.height;
    _circularGraphView = [[KRCircularKronicleGraph alloc] initWithFrame:CGRectMake(0, y, 320, 340) andKronicle:self.kronicle];
    [_sview addSubview:_circularGraphView];
    
    _sview.contentSize = CGSizeMake(_bounds.size.width, _circularGraphView.frame.origin.y + _circularGraphView.frame.size.height + 70);
    
    _backButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];

    [_backButton setBackgroundImage:[UIImage imageNamed:@"x-button"] forState:UIControlStateNormal];
    _backButton.backgroundColor                 = [UIColor clearColor];
    _backButton.frame                           = CGRectMake(0, 0, 40, 40);
    
    NSInteger itemsBUttonHeight = 42;
    _itemsButton = [[KRTextButton alloc] initWithFrame:CGRectMake(0,
                                                                  _sview.contentSize.height-(itemsBUttonHeight),
                                                                  121,
                                                                  itemsBUttonHeight)
                                               andType:KRTextButtonTypeHomeScreen
                                               andIcon:[UIImage imageNamed:@"itemshamburger"]];
    [_itemsButton setTitle:NSLocalizedString(@"View Items", @"View items this kronicle button") forState:UIControlStateNormal];
    [_itemsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_itemsButton setTitleColor:[KRColorHelper turquoise] forState:UIControlStateNormal];
    [_itemsButton addTarget:self action:@selector(viewItemsRequested:) forControlEvents:UIControlEventTouchUpInside];
    _itemsButton.titleEdgeInsets                    = UIEdgeInsetsMake(0, 14, 0, 0);
    _itemsButton.imageEdgeInsets                    = UIEdgeInsetsMake(0, 10, 0, 0);
    _itemsButton.backgroundColor                    = [UIColor whiteColor];
    _itemsButton.titleLabel.font                    = [KRFontHelper getFont:KRBrandonRegular withSize:18];
    [_sview addSubview:_itemsButton];   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewRequested) name:kKronicleReviewRequested object:nil];

    [self previewStep:0];
    [self setStep:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];
}

- (IBAction)back:(id)sender {
    [_clockManager stop];
    _clockManager = nil;
    _kronicleManager = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewItemsRequested:(id)sender {
    [self viewListItems:_kronicle];
}

- (void)dealloc {
    [_mediaView stop];
    _mediaView = nil;
    
}

#pragma KRClockManager delegate
- (void)manager:(KRClockManager *)manager updateTimeWithString:(NSString *)timeString
   andStepRatio:(CGFloat)stepRatio
 andGlobalRatio:(CGFloat)globalRatio {
    
    [_scrollView updateCurrentStepClock:timeString withRatio:stepRatio];
    [_stepListContainerView updateCurrentStepWithRatio:stepRatio];
    [_circularGraphView updateForCurrentStep:_kronicleManager.currentStepIndex andRatio:globalRatio andTimeCompleted:(globalRatio * _kronicle.totalTime)];
    _globalClockLabel.text = [KRClockManager stringTimeForInt:(_kronicle.totalTime - (globalRatio * _kronicle.totalTime))];
}

- (void)manager:(KRClockManager *)manager stepComplete:(int)stepIndex {
    [self setStep:stepIndex + 1];
}

- (void)manager:(KRClockManager *)manager pauseForInfiniteWait:(NSInteger)stepIndex
  withStepRatio:(CGFloat)stepRatio
 andGlobalRatio:(CGFloat)globalRatio {
    
    [_circularGraphView updateForCurrentStep:_kronicleManager.currentStepIndex andRatio:globalRatio andTimeCompleted:(globalRatio * _kronicle.totalTime)];
    [_stepNavigation updateForInfiniteWait];
    [_mediaView hideResume];
}

- (void)pausedByPreview {
    [_mediaView showResume];
}

- (void)pausedByUser {
    [_mediaView showResume];
}

- (void)unPaused {
    [_mediaView hideResume];
}

#pragma KRKronicleManager delegate
- (void)manager:(KRKronicleManager *)manager updateUIForStep:(Step*)step {
    [_clockManager setTimeForCurrentStep:step.indexInKronicle];
    [_stepListContainerView setCurrentStep:step.indexInKronicle];
    [_scrollView setCurrentStep:step.indexInKronicle];
    [_mediaView setMediaPath:step.mediaUrl];
    [self relayoutForPlayback];
 
    [UIView animateWithDuration:.5
                          delay:.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _sview.contentOffset = CGPointZero;
                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)manager:(KRKronicleManager *)manager previewUIForStep:(Step*)step {
    if (_kronicleManager.currentStepIndex == _kronicleManager.previewStepIndex) {
        [_stepNavigation animateNavbarOut];
        
        if (_clockManager.isPausedByUser) {
            [_clockManager pauseForUser];
        } else if (_clockManager.isPausedByInfiniteWait) {
            
        } else {
            [_clockManager unpause];
        }

    } else {
        [_stepNavigation animateNavbarIn];
        [_clockManager pauseForPreview];
    }
    
    [_scrollView scrollToPage:step.indexInKronicle];
    [_mediaView setMediaPath:step.mediaUrl];
    [_stepNavigation setAsLastStep:(_kronicleManager.previewStepIndex >= _kronicle.stepCount-1)];
    [self relayoutForPlayback];
}

- (void)kronicleComplete:(KRKronicleManager *)manager {
    [_clockManager resetForLastStep];
    [_circularGraphView updateForFinished];
    [_stepNavigation updateForFinished];

    [_mediaView updateForFinishedWithImage:_kronicle.coverUrl andTitle:_kronicle.title];
    [self relayoutForFinished];
}


#pragma KRStepNavigator delegate
- (void)controls:(KRStepNavigation *)controls navigationRequested:(KRStepNavigationRequest)type {
    switch (type) {
        case KRStepNavigationRequestForward:
            [self previewStep:_kronicleManager.previewStepIndex + 1];
            break;
        case KRStepNavigationRequestBackward:
            [self previewStep:_kronicleManager.previewStepIndex - 1];
            break;
        case KRStepNavigationRequestResume:
            [self previewStep:_kronicleManager.currentStepIndex];
            break;
        case KRStepNavigationRequestSkip:
            [self setStep:_kronicleManager.previewStepIndex];
            break;
        case KRStepNavigationRequestStartOver:
            [self setStep:0];
            break;
        case KRStepNavigationRequestGoBack:
            [self previewStep:_kronicleManager.currentStepIndex];
            break;
        case KRStepNavigationResumeAfterInfiniteWait:
            _clockManager.isPausedByInfiniteWait = NO;
            [self setStep:_kronicleManager.currentStepIndex + 1];
            break;
    }
}


#pragma KRScrollView delegate
- (void)scrollView:(KRScrollView *)scrollView pageToIndex:(NSInteger)stepIndex {
    if (stepIndex == _kronicle.stepCount) {
        [_kronicleManager setStep:_kronicle.stepCount];
    } else {
        [_kronicleManager setPreviewStep:stepIndex];
    }
}

#pragma KRStepListView delegate
- (void)stepListContainerView:(KRStepListContainerView*)stepListContainerView selectedByIndex:(NSInteger)stepIndex {
    [self setStep:stepIndex];
}

#pragma MediaView delegate
- (void)mediaViewScreenTapped:(MediaView *)mediaView {
    if (_clockManager.isPausedByPreview) {
        if (_clockManager.isPausedByInfiniteWait) {
            [_mediaView hideResume];
            [self previewStep:_kronicleManager.currentStepIndex];
        } else {
            [_clockManager unpause];
            [self previewStep:_kronicleManager.currentStepIndex];
        }
    } else {
        if (_clockManager.isPausedByUser) {
            [_clockManager unpause];
        } else {
            [_clockManager pauseForUser];
        }
    }
}

- (void)mediaViewSwipedLeft {
    [self previewStep:_kronicleManager.previewStepIndex + 1];
}

- (void)mediaViewSwipedRight {
    [self previewStep:_kronicleManager.previewStepIndex - 1];
}

#pragma private methods
- (void)previewStep:(NSInteger)step {
    [_kronicleManager setPreviewStep:step];

}

- (void)setStep:(NSInteger)step {
    [_kronicleManager setStep:step];
    [_kronicleManager setPreviewStep:step];
}


#pragma mark finished expand/contract
- (void)relayoutForPlayback {
    if (_stepListContainerView.hidden==NO) {
        return;
    }
    [_mediaView animateOutFinishedOverlay];
    _stepListContainerView.hidden = NO;
    _circularGraphView.hidden = NO;
    [_sview addSubview:_stepNavigation];
    [_sview addSubview:_stepListContainerView];
    [_sview addSubview:_circularGraphView];
    
    [UIView animateWithDuration:.5
                          delay:.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _stepListContainerView.alpha       = 1.f;
                         _circularGraphView.alpha           = 1.f;
                         _sview.contentSize = CGSizeMake(_bounds.size.width, _circularGraphView.frame.origin.y + _circularGraphView.frame.size.height + 70);
                         _itemsButton.frame = CGRectMake(_bounds.size.width - 70, _bounds.size.height-(_itemsButton.frame.size.height+20), 70, _itemsButton.frame.size.height);
                         self.view.backgroundColor        = [UIColor whiteColor];
                     }
                     completion:^(BOOL fin){
                     }];

}

- (void)relayoutForFinished {
    [_scrollView updateForFinished];
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x,
                                   _scrollView.frame.origin.y,
                                   320,
                                   [KRScrollView finishedHeight]);
    [_sview addSubview:_scrollView];
    [_sview addSubview:_stepNavigation];

    [UIView animateWithDuration:.5
                          delay:.2f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _stepListContainerView.alpha       = 0.f;
                         _circularGraphView.alpha           = 0.f;
                         _sview.contentSize = CGSizeMake(_bounds.size.width, _scrollView.frame.origin.y + _scrollView.frame.size.height);
                         _itemsButton.frame = CGRectMake(_bounds.size.width - 70, _bounds.size.height, 70, _itemsButton.frame.size.height);
                         self.view.backgroundColor        = [KRColorHelper grayLight];
                     }
                     completion:^(BOOL fin){
                         _stepListContainerView.hidden = YES;
                         _circularGraphView.hidden = YES;
                     }];
}


#pragma finishbuttons
- (void)reviewRequested {
    KRReviewViewController *kronicleReview = [[KRReviewViewController alloc] initWithKronicle:_kronicle];
    [self.navigationController pushViewController:kronicleReview animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end















