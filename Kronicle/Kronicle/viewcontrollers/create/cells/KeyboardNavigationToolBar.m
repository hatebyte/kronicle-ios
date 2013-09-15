//
//  KeyboardNavigationToolBar.m
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KeyboardNavigationToolBar.h"

@implementation KeyboardNavigationToolBar
@synthesize delegate, currentSelectedTextboxIndex;

+ (CGFloat)height {
    return 216.f + 44.f;
}

- (id)initWithPreviousAndNext:(BOOL)prevEnabled :(BOOL)nextEnabled {
    if (self = [super init]) {
        [self setBarStyle:UIBarStyleBlackTranslucent];
        [self sizeToFit];
        
        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
        
        _tabNavigation = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
        _tabNavigation.segmentedControlStyle = UISegmentedControlStyleBar;
        [_tabNavigation setEnabled:prevEnabled forSegmentAtIndex:0];
        [_tabNavigation setEnabled:nextEnabled forSegmentAtIndex:1];
        _tabNavigation.momentary = YES;
        [_tabNavigation addTarget:self action:@selector(segmentedControlHandler:) forControlEvents:UIControlEventValueChanged];
        
        UIBarButtonItem *barSegment = [[UIBarButtonItem alloc] initWithCustomView:_tabNavigation];
        [itemsArray addObject:barSegment];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [itemsArray addObject:flexButton];
        
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
        [doneButton setTintColor:[UIColor colorWithRed:34.0/255.0 green:97.0/255.0 blue:221.0/255.0 alpha:1]];
        [itemsArray addObject:doneButton];
        
        self.items = itemsArray;
    }
    return self;
}

- (void)setPreviousEnabled:(BOOL)enabled {
    [_tabNavigation setEnabled:enabled forSegmentAtIndex:0];
}
- (void)setNextEnabled:(BOOL)enabled {
    [_tabNavigation setEnabled:enabled forSegmentAtIndex:1];
}

- (id)initWithDone {
    self = [super init];
    if (self) {
        [self setBarStyle:UIBarStyleBlackTranslucent];
        [self sizeToFit];
        
        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [itemsArray addObject:flexButton];
        
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
        [itemsArray addObject:doneButton];
        
        self.items = itemsArray;
    }
    return self;
}

/* Previous / Next segmented control changed value */
- (void)segmentedControlHandler:(id)sender {
    if (self.delegate){
        switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
            case 0:
                [self.delegate customToolBar:self buttonClicked:KeyboardNavigationToolBarPrevious];
                break;
            case 1:
                [self.delegate customToolBar:self buttonClicked:KeyboardNavigationToolBarNext];
                break;
            default:
                break;
        }
    }
}

- (void)userClickedDone:(id)sender {
    if (self.delegate){
        [self.delegate customToolBar:self buttonClicked:KeyboardNavigationToolBarDone];
    }
}

@end