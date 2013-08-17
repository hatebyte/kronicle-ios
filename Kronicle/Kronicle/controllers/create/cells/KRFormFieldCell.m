//
//  KRFormFieldCell.m
//  Kronicle
//
//  Created by Scott on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRFormFieldCell.h"

@implementation KRFormFieldCell

+ (CGFloat)cellHeight { return 0.f; }

- (void)setAsFirstResponder {}
- (void)resignAsFirstResponder {}

#pragma BBCustomToobar delegate methods
- (void)customToolBar:(KeyboardNavigationToolBar*)toolbar buttonClicked:(KeyboardNavigationToolBarButton)selectedId {}


@end
