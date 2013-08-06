//
//  KRGraphView.m
//  Kronicle
//
//  Created by Jabari Bell on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRGraphView.h"
#import "KRColorHelper.h"

@interface KRGraphView()
@property(strong, atomic) UIView *progressBarView;
@end

@implementation KRGraphView

#pragma mark - Public Methods

- (void)showDisplayForRatio:(CGFloat)ratio
{
    BOOL isHorizontal = self.frame.size.width > self.frame.size.height;
    CGRect newProgressFrame = isHorizontal ? CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width * ratio, self.frame.size.height) : CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height * ratio);
    self.frame = newProgressFrame;
}

- (void)showPreviousDisplay
{
   //not sure what we're supposed to do here
}

#pragma mark - Init Stuff

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [KRColorHelper orange];
        _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 0, frame.size.height)];
        _progressBarView.backgroundColor = [KRColorHelper turquoise];
        [self addSubview:_progressBarView];
    }
    return self;
}

@end
