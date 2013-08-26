//
//  ContentWithLabelView.h
//  Kronicle
//
//  Created by Scott on 8/18/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentWithLabelView : UIView

@property(nonatomic, strong) NSString *textValue;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andImage:(UIImage *)image;
- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTextValue:(NSString *)textValue;
- (void)addTarget:(id)target withSelector:(SEL)selector;
- (void)removeTargets;

@end
