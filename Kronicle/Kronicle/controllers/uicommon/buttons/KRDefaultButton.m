//
//  KRDefaultButton.m
//  Kronicle
//
//  Created by Jabari Bell on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRDefaultButton.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"

@implementation KRDefaultButton

#pragma mark - public stuffs
- (void)setButtonTitle:(NSString*)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
}

#pragma mark - build stuffs

- (void)buildSearchCancelButton
{
    self.backgroundColor = [KRColorHelper grayDark];
    [[self titleLabel] setFont:[KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeLarge-3]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *title = @"Cancel";
    [self setButtonTitle:title];
}

- (void)buildSearchControlButton
{
    self.backgroundColor = [KRColorHelper turquoiseLight];
    [[self titleLabel] setFont:[KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeLarge-3]];
    [self setTitleColor:[KRColorHelper grayDark] forState:UIControlStateNormal];
}

#pragma mark - init stuff

- (id)initWithFrame:(CGRect)frame andType:(KRDefaultButtonType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        switch (type) {
            case KRDefaultButtonTypeCancelSearch:
                [self buildSearchCancelButton];
                break;
            
            case KRDefaultButtonTypeControlSearch:
                [self buildSearchControlButton];
                break;
                
            default:
                break;
        }
    }
    return self;
}

@end
