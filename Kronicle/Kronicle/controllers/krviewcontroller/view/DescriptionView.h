//
//  DescriptionView.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRStep.h"

@interface DescriptionView : UIView

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextView *description;
@property(nonatomic, weak) KRStep *step;

- (id)initWithFrame:(CGRect)frame andStep:(KRStep*)step;

@end
