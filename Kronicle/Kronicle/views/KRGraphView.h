//
//  KRGraphView.h
//  Kronicle
//
//  Created by Jabari Bell on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRGraphView : UIView

@property(nonatomic, assign) BOOL isCurrentStep;

- (void)showDisplayForRatio:(CGFloat)ratio;
- (void)showDisplayWithReset:(BOOL)shouldReset;
- (void)showPreview;
- (void)reset;
- (void)removeRunLoop;

@end
