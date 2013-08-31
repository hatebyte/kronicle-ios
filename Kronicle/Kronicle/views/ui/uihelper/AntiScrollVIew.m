//
//  AntiScrollVIew.m
//  Kronicle
//
//  Created by Scott on 8/30/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AntiScrollVIew.h"
#import "TouchCircleCreatorView.h"

@implementation AntiScrollVIew

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint pointOfContact = [gestureRecognizer locationInView:self];
    
    if([[self hitTest:pointOfContact withEvent:nil] isKindOfClass:[TouchCircleCreatorView class]]) {
        return NO;
    }
    
    return YES;
}
@end
