//
//  ContentWithLabelView.m
//  Kronicle
//
//  Created by Scott on 8/18/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "ContentWithLabelView.h"
#import "KRGlobals.h"

@interface ContentWithLabelView () {
    @private
    UILabel *_contentValueLabel;
    UIButton *_contentValueButton;
}

@end

@implementation ContentWithLabelView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andImage:(UIImage *)image {
    self = [self initWithFrame:frame];
    if (self) {
        [_contentValueButton setImage:image forState:UIControlStateNormal];
        _contentValueLabel.text                         = title;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTextValue:(NSString *)textValue {
    self = [self initWithFrame:frame];
    if (self) {
        [_contentValueButton setTitle:textValue forState:UIControlStateNormal];
        [_contentValueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _contentValueButton.titleLabel.font             = [KRFontHelper getFont:KRBrandonRegular withSize:42];
        _contentValueButton.titleLabel.textAlignment    = UITextAlignmentCenter;
        
        _contentValueLabel.text                         = title;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        _contentValueButton                             = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentValueButton.frame                       = CGRectMake((frame.size.width-60) * .5, 10, 60, 45);
        _contentValueButton.backgroundColor             = [UIColor clearColor];

        _contentValueLabel                              = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                                                    (_contentValueButton.frame.origin.y + _contentValueButton.frame.size.height) - 4,
                                                                                                    frame.size.width,
                                                                                                    20)];
        _contentValueLabel.backgroundColor              = [UIColor clearColor];
        _contentValueLabel.font                         = [KRFontHelper getFont:KRBrandonRegular withSize:17];
        _contentValueLabel.textColor                    = [UIColor whiteColor];
        _contentValueLabel.textAlignment                = UITextAlignmentCenter;
        [self addSubview:_contentValueButton];
        [self addSubview:_contentValueLabel];
        
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addTarget:(id)target withSelector:(SEL)selector {
    [_contentValueButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTextValue:(NSString *)textValue {
    _textValue = textValue;
    [_contentValueButton setTitle:_textValue forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
