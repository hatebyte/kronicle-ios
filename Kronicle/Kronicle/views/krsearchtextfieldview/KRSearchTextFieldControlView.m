//
//  KRSearchTextFieldControlView.m
//  Kronicle
//
//  Created by Jabari Bell on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRSearchTextFieldControlView.h"
#import "KRDefaultButton.h"
#import "UIView+GCLibrary.h"

@interface KRSearchTextFieldControlView()

@property(nonatomic, strong) KRSearchTextFieldView *searchTextFieldView;
@property(nonatomic, strong) KRDefaultButton *kroniclesButton;
@property(nonatomic, strong) KRDefaultButton *peopleButton;

@end

@implementation KRSearchTextFieldControlView

#pragma mark - delegate stuff

- (void)animateControlButtonsIn
{
    [_kroniclesButton setY:self.frame.size.height / 2];
    [_peopleButton setY:self.frame.size.height / 2];
    [self.delegate animateSearchViewIn];
}

- (void)animateControlButtonsOut
{
    [_kroniclesButton setY:0];
    [_peopleButton setY:0];
    [self.delegate animateSearchViewOut];
}

#pragma mark - init stuff

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _kroniclesButton = [[KRDefaultButton alloc] initWithFrame:CGRectMake(0, 0, (frame.size.width / 2) - 1, frame.size.height / 2) andType:KRDefaultButtonTypeControlSearch];
        [_kroniclesButton setButtonTitle:@"Kronicles"];
        [self addSubview:_kroniclesButton];
        
        _peopleButton = [[KRDefaultButton alloc] initWithFrame:CGRectMake((frame.size.width / 2) + 1, 0, (frame.size.width / 2) - 1, frame.size.height / 2) andType:KRDefaultButtonTypeControlSearch];
        [_peopleButton setButtonTitle:@"People"];
        [self addSubview:_peopleButton];
        
        _searchTextFieldView = [[KRSearchTextFieldView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height / 2)];
        _searchTextFieldView.delegate = self;
        [self addSubview:_searchTextFieldView];
    }
    return self;
}

@end
