//
//  KeyboardNavigationToolBar.h
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KeyboardNavigationToolBarNext,
    KeyboardNavigationToolBarPrevious,
    KeyboardNavigationToolBarDone
} KeyboardNavigationToolBarButton;

@class KeyboardNavigationToolBar;
@protocol KeyboardNavigationToolBarDelegate
- (void)customToolBar:(KeyboardNavigationToolBar*)toolbar buttonClicked:(KeyboardNavigationToolBarButton)selectedId;
@end

@interface KeyboardNavigationToolBar : UIToolbar {
    @private
    id<KeyboardNavigationToolBarDelegate> delegate;
    NSUInteger currentSelectedTextboxIndex;
    UISegmentedControl *_tabNavigation;
}

@property (nonatomic, strong) id<KeyboardNavigationToolBarDelegate> delegate;
@property (nonatomic) NSUInteger currentSelectedTextboxIndex;

+ (CGFloat)height;

- (id)initWithPreviousAndNext:(BOOL)prevEnabled :(BOOL)nextEnabled;
- (id)initWithDone;
- (void)setPreviousEnabled:(BOOL)enabled;
- (void)setNextEnabled:(BOOL)enabled;

@end
