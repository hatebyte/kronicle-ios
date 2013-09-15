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
@protocol KeyboardNavigationToolBarDelegate <UIToolbarDelegate>
- (void)customToolBar:(KeyboardNavigationToolBar*)toolbar buttonClicked:(KeyboardNavigationToolBarButton)selectedId;
@end

@interface KeyboardNavigationToolBar : UIToolbar {
    @private
    NSUInteger currentSelectedTextboxIndex;
    UISegmentedControl *_tabNavigation;
}

@property (nonatomic, weak) id<KeyboardNavigationToolBarDelegate> delegate;
@property (nonatomic) NSUInteger currentSelectedTextboxIndex;

+ (CGFloat)height;

- (id)initWithPreviousAndNext:(BOOL)prevEnabled :(BOOL)nextEnabled;
- (id)initWithDone;
- (void)setPreviousEnabled:(BOOL)enabled;
- (void)setNextEnabled:(BOOL)enabled;

@end
