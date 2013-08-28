//
//  KRKroniclesPageNavigationView.m
//  Kronicle
//
//  Created by Scott on 8/27/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKroniclesPageNavigationView.h"
#import "KRGlobals.h"
#import <QuartzCore/QuartzCore.h>

@interface KRKroniclesPageNavigationView () {
    @private
    UIButton *_item1;
    UIButton *_item2;
    UIButton *_item3;
    UIImageView *_carrotView;
}

@end

@implementation KRKroniclesPageNavigationView

+ (UIButton *)getItemButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:18];
    return button;
}

+ (CGFloat)getWidthForString:(NSString *)text {
    return [text sizeWithFont:[KRFontHelper getFont:KRBrandonLight withSize:18]].width;
}

- (id)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor                      = [KRColorHelper turquoiseDark];
        self.clipsToBounds                        = NO;

        _item1 = [KRKroniclesPageNavigationView getItemButtonWithTitle:[titles objectAtIndex:0]];
        [_item1 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        _item1.tag = KroniclesPageNavigationOne;
        
        _item2 = [KRKroniclesPageNavigationView getItemButtonWithTitle:[titles objectAtIndex:1]];
        [_item2 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        _item2.tag = KroniclesPageNavigationTwo;
        
        _item3 = [KRKroniclesPageNavigationView getItemButtonWithTitle:[titles objectAtIndex:2]];
        [_item3 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        _item3.tag = KroniclesPageNavigationThree;
        
        
        NSInteger buttonHeight = 55;
        NSInteger buttonWidth = [KRKroniclesPageNavigationView getWidthForString:_item1.titleLabel.text] + (2 * kPadding);
        _item1.frame = CGRectMake(kPadding, frame.size.height - buttonHeight, buttonWidth, buttonHeight);
        
        buttonWidth = [KRKroniclesPageNavigationView getWidthForString:_item2.titleLabel.text] + (2 * kPadding);
        _item3.frame = CGRectMake(frame.size.width - (buttonWidth + kPadding), frame.size.height - buttonHeight, buttonWidth, buttonHeight);
        
        buttonWidth = [KRKroniclesPageNavigationView getWidthForString:_item3.titleLabel.text] + (2 * kPadding);
        NSInteger inbtweenDist = (_item3.frame.origin.x)-(_item1.frame.origin.x + _item1.frame.size.width);
        _item2.frame = CGRectMake(((inbtweenDist - buttonWidth) * .5) + (_item1.frame.origin.x + _item1.frame.size.width),
                                  frame.size.height - buttonHeight,
                                  buttonWidth,
                                  buttonHeight);
        
        [self addSubview:_item1];
        [self addSubview:_item2];
        [self addSubview:_item3];
        
        _carrotView             = [[UIImageView alloc] initWithFrame:CGRectMake(-10, frame.size.height, 11, 5)];
        _carrotView.image       = [UIImage imageNamed:@"tinyrturqoisecarrot"];
        [self addSubview:_carrotView];
        
        [self animateUnderButton:_item1];

    }
    return self;
}

- (void)selectButton:(id)sender {
    if (_preventHit) {
        return;
    }
    
    _preventHit = YES;
    UIButton *hitButton = sender;
    [self animateUnderButton:hitButton];
    
    [self.delegate kroniclesPageNavigationView:self didSelect:hitButton.tag];
}

- (void)animateUnderButton:(UIButton*)button {
    [UIView animateWithDuration:.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _carrotView.alpha = 1.f;
                         _carrotView.center = CGPointMake(button.center.x, _carrotView.center.y);
                     }
                     completion:^(BOOL fin){
                         
                     }];
}

@end













