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
//#import "KRViewListTypeViewController.h"
#import "KRColorHelper.h"


#import "KRGlobals.h"
#import "KRClockManager.h"
#import "KRKronicleManager.h"
#import "KRStepNavigation.h"
#import "KRScrollView.h"
#import "KRGraphView.h"
#import "KRStepListContainerView.h"
#import "MediaView.h"
#import "KRCircularKronicleGraph.h"


#define kScrollViewNormal 320.f
#define kScrollViewUp 180.f

@interface KRViewController () <KRClockManagerDelegate,
                                KRKronicleManagerDelegate,
                                KRStepNavigationDelegate,
                                KRScrollViewDelegate,
                                KRStepListContainerViewDelegate> {
    @private
    CGRect _bounds;
    UIScrollView *_sview;
    UIButton *_backButton;
    KRKronicleManager *_kronicleManager;
    KRClockManager *_clockManager;
    KRStepNavigation *_stepNavigation;
    KRScrollView *_scrollView;
    KRGraphView *_graphView;
    KRStepListContainerView *_stepListContainerView;
    MediaView *_mediaView;
    KRCircularKronicleGraph *_circularGraphView;
}

@end

@implementation KRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.kronicle = kronicle;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    _bounds = [UIScreen mainScreen].bounds;
    _sview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height-20)];
    _sview.showsVerticalScrollIndicator = YES;
    _sview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_sview];
    
    _kronicleManager = [[KRKronicleManager alloc] initWithKronicle:self.kronicle];
    _kronicleManager.delegate = self;
    
    _clockManager = [[KRClockManager alloc] initWithKronicle:self.kronicle];
    _clockManager.delegate = self;
    
    _mediaView = [[MediaView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [_sview addSubview:_mediaView];

    _backButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"x-button"] forState:UIControlStateNormal];
    _backButton.frame = CGRectMake(5, 5, 26, 26);
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_sview addSubview:_backButton];
    
    _graphView = [[KRGraphView alloc] initWithFrame:CGRectMake(0, _mediaView.frame.origin.y + _mediaView.frame.size.height, 320, 80)];
    [_sview addSubview:_graphView];

    _scrollView = [[KRScrollView alloc] initWithFrame:CGRectMake(0, _graphView.frame.origin.y, 320, 310) andKronicle:self.kronicle];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320 * [self.kronicle.steps count], _scrollView.frame.size.height);
    _scrollView.scrollDelegate = self;
    [_sview addSubview:_scrollView];
    
    _stepNavigation = [[KRStepNavigation alloc] initWithFrame:CGRectMake(0, _graphView.frame.origin.y-40, 320, 100)];
    _stepNavigation.delegate = self;
    [_sview addSubview:_stepNavigation];
    
    int y = _scrollView.frame.origin.y + _scrollView.frame.size.height;
    _stepListContainerView = [[KRStepListContainerView alloc] initWithFrame:CGRectMake(0, y, 320, 0) andSteps:_kronicle.steps];
    _stepListContainerView.delegate = self;
    [_sview addSubview:_stepListContainerView];

    y = _stepListContainerView.frame.origin.y + _stepListContainerView.frame.size.height;
    _circularGraphView = [[KRCircularKronicleGraph alloc] initWithFrame:CGRectMake(0, y, 320, 320) andKronicle:self.kronicle];
    [_sview addSubview:_circularGraphView];
    
    _sview.contentSize = CGSizeMake(_bounds.size.width, _circularGraphView.frame.origin.y + _circularGraphView.frame.size.height + 70);
    [self setStep:0];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_mediaView stop];
    _mediaView = nil;

}

#pragma KRClockManager delegate
- (void)manager:(KRClockManager *)manager updateTimeWithString:(NSString *)timeString
   andStepRatio:(CGFloat)stepRatio
 andGlobalRatio:(CGFloat)globalRatio {
    [_scrollView updateCurrentStepClock:timeString];
    [_graphView showDisplayForRatio:stepRatio];
    [_stepListContainerView updateCurrentStepWithRatio:stepRatio];
    
    [_circularGraphView updateForCurrentStep:_kronicleManager.currentStepIndex andRatio:globalRatio];
}

- (void)manager:(KRClockManager *)manager stepComplete:(int)stepIndex {
    [self setStep:stepIndex + 1];
}


#pragma KRKronicleManager delegate
- (void)manager:(KRKronicleManager *)manager updateUIForStep:(KRStep*)step {
    if (_kronicleManager.currentStepIndex == _kronicleManager.previewStepIndex) {
        [_stepNavigation animateNavbarOut];
    }
    
    [_clockManager setTimeForStep:step.indexInKronicle];
    [_stepListContainerView adjustStepListForCurrentStep:step.indexInKronicle];
    [_scrollView setCurrentStep:step.indexInKronicle];
    
    if (_kronicleManager.requestedDirection == KronicleManagerLeft) {
        [_mediaView setMediaPath:step.imageUrl andType:MediaViewLeft];
    } else {
        [_mediaView setMediaPath:step.imageUrl andType:MediaViewRight];
    }
}

- (void)manager:(KRKronicleManager *)manager previewUIForStep:(KRStep*)step {
    if (_kronicleManager.currentStepIndex == _kronicleManager.previewStepIndex) {
        [_stepNavigation animateNavbarOut];
        [_graphView showDisplayWithReset:NO];
    } else {
        [_stepNavigation animateNavbarIn];
        [_graphView showPreview:(_kronicleManager.currentStepIndex > step.indexInKronicle)];
    }
    [_scrollView scrollToPage:step.indexInKronicle];

    if (_kronicleManager.requestedDirection == KronicleManagerLeft) {
        [_mediaView setMediaPath:step.imageUrl andType:MediaViewLeft];
    } else {
        [_mediaView setMediaPath:step.imageUrl andType:MediaViewRight];
    }
}

- (void)kronicleComplete:(KRKronicleManager *)manager {
    [_graphView updateForLastStep];
    [_scrollView updateForLastStep];
    [_stepListContainerView updateForLastStep];
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
    }
}


#pragma KRSwipeUpScrollView delegate
- (void)scrollView:(KRScrollView *)scrollView pageToIndex:(int)stepIndex {
    [_kronicleManager setPreviewStep:stepIndex];
}


#pragma KRStepListView delegate
- (void)stepListContainerView:(KRStepListContainerView*)stepListContainerView selectedByIndex:(int)stepIndex {
    [self setStep:stepIndex];
}

#pragma private methods
- (void)previewStep:(int)step {
    [_kronicleManager setPreviewStep:step];
}

- (void)setStep:(int)step {
    [_graphView showDisplayWithReset:YES];
    [_kronicleManager setStep:step];
    [_kronicleManager setPreviewStep:step];
}

- (IBAction)togglePlayPause:(id)sender {

}




//// sets the right picture/video
//- (void)setActiveMedia:(KRStep*)step {
//    if ([_mediaViewB isVideo] || [_mediaViewA isVideo]) {
//        [_mediaViewB setMediaPath:step.imageUrl andType:MediaViewImage];
//        _circleDiagram.imagePath = step.circleUrl;
//        [_navView isCurrentStep:(_currentStep == _clock.index)];
//    } else {
//        [_mediaViewA setMediaPath:_mediaViewB.mediaPath andType:MediaViewImage];
//        //[_mediaViewB setMediaPath:@"crazy_train_1.mov" andType:MediaViewImage];
//
//        _mediaViewB.alpha = 0.f;
//        [_mediaViewB setMediaPath:step.imageUrl andType:MediaViewImage];
//        _circleDiagram.imagePath = step.circleUrl;
//        [UIView animateWithDuration:.2
//                              delay:0.0
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             _mediaViewB.alpha = 1.f;
//                             _circleDiagram.alpha = 1.f;
//                         }
//                         completion:^(BOOL fin){
//                             [_navView isCurrentStep:(_currentStep == _clock.index)];
//                         }];
//    }
//}

//#pragma CircleDiagramView
//- (void)diagramView:(KRDiagramView*)diagramView withDegree:(CGFloat)percent {
//    int index = [self returnIndexForPercent:percent andIndex:0];
//    
//    _clock.index = index;
//    KRStep *s = [self.kronicle.steps objectAtIndex:_clock.index];
//    [_clock resetWithTime:s.time];
//    if ([_clock isPaused]) [_clock play];
//    [self jumpToStep:_clock.index andPlay:YES];
//}
//
//- (int)returnIndexForPercent:(CGFloat)percent andIndex:(int)index{
//    CGFloat time = 0;
//    for (int i=0;i<index; i++) {
//        KRStep *s = [self.kronicle.steps objectAtIndex:i];
//        time += s.time;
//    }
//    float timePercent = (time / self.kronicle.totalTime);
//    if (timePercent < percent) {
//        return [self returnIndexForPercent:percent andIndex:index+1];
//    } else {
//        return index-1;
//    }
//}
//
//


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
