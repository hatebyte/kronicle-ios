//
//  BBRichTextView.h
//  BBUIPreview
//
//  Created by Scott on 7/12/13.
//  Copyright (c) 2013 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBRichTextPrefixStyle.h"

typedef enum {
    BBRichTextAlignLeft,
    BBRichTextAlignRight,
    BBRichTextAlignCenter,
    BBRichTextAlignJustified,
    BBRichTextAlignNatural,
}BBRichTextAlignment;

@interface BBRichTextView : UIView

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *color;
@property(nonatomic, assign) CGFloat lineheight;
@property(nonatomic, assign) BOOL literalMode;
@property(nonatomic, assign) int padding;
@property(nonatomic, assign) BBRichTextAlignment alignment;

- (void)addPrefix:(BBRichTextPrefixStyle *)style;

@end
