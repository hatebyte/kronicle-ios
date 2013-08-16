//
//  BBRichTextPrefixStyle.h
//  BBUIPreview
//
//  Created by Scott on 7/13/13.
//  Copyright (c) 2013 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBRichTextPrefixStyle : NSObject

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) NSMutableArray *prefixes;

+ (BBRichTextPrefixStyle *)withTarget:(id)aTarget andSelector:(SEL)anAction;

- (id)initWithTarget:(id)aTarget forSelector:(SEL)anAction;
- (void)addPrefix:(NSString *)tag;

@end
