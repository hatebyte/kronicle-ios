//
//  KRSwipeViewNavigation.m
//  Kronicle
//
//  Created by Scott on 8/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRSwipeViewNavigation.h"
#import <QuartzCore/QuartzCore.h>
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRNavigationTableViewCell.h"
#import "KRHomeViewController.h"

@interface KRSwipeViewNavigation () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate> {
    @private
    UISwipeGestureRecognizer *_swipeRecongizer;
    UITableView *_tableView;
    UIView *_whiteBar;
    NSArray *_tableData;
    UIButton *_hamburgerButton;
    CGRect _hiddenFrame;
    CGRect _exposedFrame;
    CGRect _bounds;
    CALayer *_backgroundLayer;
    UIButton *_hitButton;
}
@end


@implementation KRSwipeViewNavigation

+ (CGFloat)maxHeight {
    return [self cellHeight] * 6;
}

+ (CGFloat)cellHeight {
    return 44.f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bounds = [UIScreen mainScreen].bounds;
        
        
        _hiddenFrame = frame;
        _exposedFrame = CGRectMake(0, _bounds.size.height - [KRSwipeViewNavigation maxHeight], 320, [KRSwipeViewNavigation maxHeight]);
        
        _tableData = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Home", @"title",
                           @"home_thumbnail", @"thumbImage",
                           [NSValue valueWithPointer:@selector(home)], @"target",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"My Kronicles", @"title",
                           @"mykronicles_thumbnail", @"thumbImage",
                           [NSValue valueWithPointer:@selector(myKronicles)], @"target",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Create", @"title",
                           @"create_thumbnail", @"thumbImage",
                           [NSValue valueWithPointer:@selector(create)], @"target",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Discover", @"title",
                           @"discover_thumbnail", @"thumbImage",
                           [NSValue valueWithPointer:@selector(discover)], @"target",
                           nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Me", @"title",
                           @"me_thumbnail", @"thumbImage",
                           [NSValue valueWithPointer:@selector(me)], @"target",
                           nil],
                      nil];

        _whiteBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, _hiddenFrame.size.height)];
        _whiteBar.backgroundColor = [UIColor clearColor];
        [self addSubview:_whiteBar];

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, _exposedFrame.size.height)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        _hamburgerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hamburgerButton setImage:[UIImage imageNamed:@"hamburger_thumbnail"] forState:UIControlStateNormal];
        _hamburgerButton.frame = CGRectMake(320 - _hiddenFrame.size.height, 0, _hiddenFrame.size.height, _hiddenFrame.size.height);
        [_hamburgerButton addTarget:self action:@selector(toggleOpenClose) forControlEvents:UIControlEventTouchUpInside];
        _hamburgerButton.backgroundColor = [UIColor whiteColor];
        
        _titleLabel                         = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 44)];
        _titleLabel.font                    = [KRFontHelper getFont:KRBrandonLight withSize:28];
        _titleLabel.textColor               = [KRColorHelper turquoise];
        _titleLabel.backgroundColor         = [UIColor clearColor];
        _titleLabel.userInteractionEnabled  = NO;
        
        _hitButton                          = [UIButton buttonWithType:UIButtonTypeCustom];
        _hitButton.frame                    = CGRectMake(0, 0, 320, 44);
        [_hitButton addTarget:self action:@selector(toggleOpenClose) forControlEvents:UIControlEventTouchUpInside];
       [_hitButton setTitleColor:[KRColorHelper turquoise] forState:UIControlStateNormal];
        _hitButton.titleLabel.font          = [KRFontHelper getFont:KRBrandonLight withSize:28];
        _hitButton.backgroundColor          = [UIColor whiteColor];
        [self addSubview:_hitButton];
        [self addSubview:_titleLabel];
        [self addSubview:_hamburgerButton];
    }
    return self;
}

- (void)toggleOpenClose {
    if (self.isOpen) {
        [self animateOut];
    } else {
        [self animateIn];
    }
}

- (void)close {
    [self animateOut];
}

- (void)reposition {
    [self animateOut];
}

- (void)hide {
    self.isBelowScreen = YES;
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame                             = CGRectMake(_hiddenFrame.origin.x, _bounds.size.height, _hiddenFrame.size.width, _hiddenFrame.size.height);
                         _whiteBar.frame                        = CGRectMake(0, 0, 320, self.frame.size.height);
                         _hamburgerButton.frame                 = CGRectMake(320 - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
                     }
                     completion:^(BOOL fin){ }];
}

- (void)animateIn {
    self.isOpen = YES;
    self.isBelowScreen = NO;
    [_tableView reloadData];
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = _exposedFrame;
                         _whiteBar.frame = CGRectMake(0, self.frame.size.height - _hiddenFrame.size.height, 320, _hiddenFrame.size.height);
                         _hamburgerButton.frame = CGRectMake(320 - _hiddenFrame.size.height, self.frame.size.height - _hiddenFrame.size.height, _hiddenFrame.size.height, _hiddenFrame.size.height);
                         _titleLabel.frame                      = CGRectMake(10, self.frame.size.height - 44, 310, 44);
                         _hitButton.frame                       = CGRectMake(0, self.frame.size.height - 44, 320, 44);
                         _tableView.frame                       = CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height);
                     }
                     completion:^(BOOL fin){ }];
}

- (void)animateOut {
    self.isOpen = NO;
    self.isBelowScreen = NO;
    [_tableView reloadData];
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = _hiddenFrame;
                         _whiteBar.frame = CGRectMake(0, 0, 320, _hiddenFrame.size.height);
                         _hamburgerButton.frame = CGRectMake(320 - _hiddenFrame.size.height, 0, _hiddenFrame.size.height, _hiddenFrame.size.height);
                         _titleLabel.frame                      = CGRectMake(10, 0, 310, 44);
                         _hitButton.frame                       = CGRectMake(0, 0, 320, 44);
                         _tableView.frame                       = CGRectMake(0, 44, _tableView.frame.size.width, _tableView.frame.size.height);
                     }
                     completion:^(BOOL fin){ }];
}

#pragma UISwipeGestureRecognizer
-(void)swipeDetected:(UISwipeGestureRecognizer *)swipeRecognizer {
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [self animateIn];
    }
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [self animateOut];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}


#pragma tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KRSwipeViewNavigation cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KRNavigationTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"KRNavigationTableViewCell"];
    if (cell == nil) {
        cell = [[KRNavigationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KRNavigationTableViewCell"];
    }
    NSDictionary *data = [_tableData objectAtIndex:indexPath.row];
    [cell prepareForUseWithData:data isTableOpen:self.isOpen];
    
    if (indexPath.row < _tableData.count-1) {
        [cell addStroke];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [[KRHomeViewController current] home];
            break;
        case 1:
            [[KRHomeViewController current] mykronicles];
            break;
        case 2:
            [[KRHomeViewController current] create];
            break;
        case 3:
            [[KRHomeViewController current] discover];
            break;
        case 4:
            [[KRHomeViewController current] me];
            break;
    }
}


@end
