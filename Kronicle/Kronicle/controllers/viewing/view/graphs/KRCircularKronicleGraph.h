//
//  KRCircularKronicleGraph.h
//  Kronicle
//
//  Created by Scott on 8/8/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kronicle+Helper.h"

@interface KRCircularKronicleGraph : UIView

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle;
- (void)updateForCurrentStep:(int)step andRatio:(CGFloat)ratio andTimeCompleted:(int)totalCompleted;
- (void)updateForLastStep;

@end
