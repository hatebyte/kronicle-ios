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

#define kScrollViewNormal 300.f
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
    self.view.backgroundColor = [UIColor blackColor];
    
    _bounds = [UIScreen mainScreen].bounds;
    
    _mediaViewA = [[MediaView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, _bounds.size.width)];
    [self.view addSubview:_mediaViewA];
    _mediaViewB = [[MediaView alloc] initWithFrame:_mediaViewA.frame];
    [self.view addSubview:_mediaViewB];
    [_mediaViewB setMediaPath:[(KRStep*)[self.kronicle.steps objectAtIndex:0] imageUrl] andType:MediaViewImage];
    
    _circleDiagram = [[KRDiagramView alloc] initWithFrame:CGRectMake((_bounds.size.width - 285) * .5,
                                                                     (_bounds.size.width - 285) * .5,
                                                                     285,
                                                                     285)];
    _circleDiagram.imagePath = @"circle-test";
    [self.view addSubview:_circleDiagram];
    
    
    _scrollView = [[KRSwipeUpScrollView alloc] initWithFrame:CGRectMake(0, kScrollViewNormal, _bounds.size.width, [KRSwipeUpScrollView maxHeight])];
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
}

- (void)setActiveMedia:(KRStep*)step {
    [_mediaViewA setMediaPath:_mediaViewB.mediaPath andType:MediaViewImage];
    _mediaViewB.alpha = 0.f;
    [_mediaViewB setMediaPath:step.imageUrl andType:MediaViewImage];
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _mediaViewB.alpha = 1.f;
                     }
                     completion:nil];

}

- (IBAction)gotToKronicleListView:(id)sender {}
- (IBAction)togglePlayPause:(id)sender {}


#pragma SwipeScrollView 


- (void)scrollView:(KRSwipeUpScrollView*)scrollView swipedUpWithDistance:(int)distance {
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scrollView.frame = CGRectMake(0, kScrollViewUp, _bounds.size.width, [KRSwipeUpScrollView maxHeight]);
                     }
                     completion:nil];
}

- (void)scrollView:(KRSwipeUpScrollView*)scrollView swipedDownWithDistance:(int)distance {
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scrollView.frame = CGRectMake(0, kScrollViewNormal, _bounds.size.width, [KRSwipeUpScrollView maxHeight]);
                     }
                     completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / _bounds.size.width;
    [self setActiveMedia:(KRStep*)[self.kronicle.steps objectAtIndex:index]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
