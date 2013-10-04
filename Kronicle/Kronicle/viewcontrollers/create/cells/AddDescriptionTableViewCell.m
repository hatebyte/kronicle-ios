//
//  AddDescriptionTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddDescriptionTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface AddDescriptionTableViewCell () <UITextViewDelegate> {
    @private
    UITextView *_textArea;
    UIImageView *_hamburgerImageView;
    UILabel *_addItemsLabel;
    UILabel *_placeholderLabel;
    UIButton *_addItemCatcher;
    UIButton *_clearTextViewButton;
    AddTitleLocation _screenType;
    CALayer *_whiteBackground;
}

@end

@implementation AddDescriptionTableViewCell

+ (CGFloat)cellHeightKronicle {
    return 32.f;
}

+ (CGFloat)cellHeightStep {
    return 60.f;
}

+ (CGFloat)cellHeightExpanded {
    return 154.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                     = UITableViewCellSelectionStyleNone;
        self.type                               = KRFormFieldCellTypeAddDescription;

        _whiteBackground                        = [CALayer layer];
        _whiteBackground.backgroundColor        = [UIColor whiteColor].CGColor;
        [self.contentView.layer addSublayer:_whiteBackground];

        _textArea                               = [[UITextView alloc] initWithFrame:CGRectMake(kPadding-8, 0, kPaddingWidth, 32)];
        _textArea.font                          = [KRFontHelper getFont:KRMinionProRegular withSize:20];
        _textArea.delegate                      = self;
        _textArea.scrollEnabled                 = YES;
        _textArea.textColor                     = [UIColor blackColor];
        _textArea.backgroundColor               = [UIColor clearColor];
        [self.contentView addSubview:_textArea];

        KeyboardNavigationToolBar *toolbar = [[KeyboardNavigationToolBar alloc] initWithPreviousAndNext:YES :YES];
        toolbar.delegate = self;
        [toolbar setNextEnabled:NO];
        [_textArea setInputAccessoryView:toolbar];

        _placeholderLabel                       = [[UILabel alloc] initWithFrame: CGRectMake(_textArea.frame.origin.x + 8,
                                                                                             _textArea.frame.origin.y + 7,
                                                                                             _textArea.frame.size.width,
                                                                                             30)];
        _placeholderLabel.font                  = [KRFontHelper getFont:KRMinionProRegular withSize:20];
        _placeholderLabel.textColor             = [UIColor blackColor];
        _placeholderLabel.text                  = @"Add description";
        _placeholderLabel.backgroundColor       = [UIColor clearColor];
        _placeholderLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:_placeholderLabel];

        _clearTextViewButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearTextViewButton setImage:[UIImage imageNamed:@"close-x"] forState:UIControlStateNormal];
        [_clearTextViewButton addTarget:self action:@selector(clearTextArea) forControlEvents:UIControlEventTouchUpInside];
        _clearTextViewButton.hidden             = YES;
        [self.contentView addSubview:_clearTextViewButton];
        
        NSInteger h                             =(_screenType == AddTitleKronicle) ? 32 : 100;
        _textArea.frame                         = CGRectMake(kPadding-8, 0, kPaddingWidth, h);
        _clearTextViewButton.frame              = CGRectMake((_textArea.frame.origin.x + _textArea.frame.size.width) - 30,
                                                             (_textArea.frame.origin.y + _textArea.frame.size.height) - 30,
                                                             30,
                                                             30);
        _whiteBackground.backgroundColor        = [UIColor whiteColor].CGColor;
        _whiteBackground.frame                  = CGRectMake(kPadding,
                                                             _textArea.frame.origin.y,
                                                             320-(kPadding * 2),
                                                             h);

        self.contentView.backgroundColor        = [UIColor whiteColor];
        self.backgroundView.backgroundColor     = [UIColor whiteColor];
        self.backgroundColor                    = [UIColor whiteColor];
        self.clipsToBounds                      = YES;
    }
    return self;
}

- (NSString *)value {
    return _textArea.text;
}

- (void)prepareForUseWithDescription:(NSString *)description andType:(AddTitleLocation)type {
    if (description.length >= 1) {
        _placeholderLabel.hidden = YES;
        _textArea.text                          = description;
    } else {
        _placeholderLabel.hidden = NO;
    }
    _screenType                                 = type;
}

- (void)animateIn {
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _textArea.frame                         = CGRectMake(kPadding-8, 0, kPaddingWidth, 135);
                         _clearTextViewButton.frame              = CGRectMake((_textArea.frame.origin.x + _textArea.frame.size.width) - 30,
                                                                              (_textArea.frame.origin.y + _textArea.frame.size.height) - 30,
                                                                              30,
                                                                              30);
                         _whiteBackground.frame                  = CGRectMake(kPadding,
                                                                              _textArea.frame.origin.y,
                                                                              320-(kPadding * 2),
                                                                              135);
                         _whiteBackground.backgroundColor        = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.05f].CGColor;
                     }
                     completion:^(BOOL fin){}];
}

- (void)animateOut {
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         NSInteger h                             =(_screenType == AddTitleKronicle) ? 32 : 100;
                         _textArea.frame                         = CGRectMake(kPadding-8, 0, kPaddingWidth, h);
                         _clearTextViewButton.frame              = CGRectMake((_textArea.frame.origin.x + _textArea.frame.size.width) - 30,
                                                                              (_textArea.frame.origin.y + _textArea.frame.size.height) - 30,
                                                                              30,
                                                                              30);
                         _whiteBackground.backgroundColor        = [UIColor whiteColor].CGColor;
                         _whiteBackground.frame                  = CGRectMake(kPadding,
                                                                              _textArea.frame.origin.y,
                                                                              320-(kPadding * 2),
                                                                              h);
                     }
                     completion:^(BOOL fin){}];
}


- (void)setAsFirstResponder {
    if (_textArea.editable) {}
    [_textArea performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];

    [self animateIn];
}

- (void)resignAsFirstResponder {
    _clearTextViewButton.hidden = YES;
    [_textArea resignFirstResponder];
    [self animateOut];
}


- (void)clearTextArea {
    _textArea.text = @"";
    _placeholderLabel.hidden = NO;
    _clearTextViewButton.hidden = YES;
    [self setAsFirstResponder];
}

#pragma UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self.delegate formFieldCellDidBecomeFirstResponder:self andShouldExpand:YES];
    [self animateIn];
    
    if ( textView.text.length > 0) {
        _placeholderLabel.hidden = YES;
        _clearTextViewButton.hidden = NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.delegate formFieldCellDidResignFirstResponder:self andShouldContract:YES];
    [self animateOut];
    if ( textView.text.length > 0) {
        _placeholderLabel.hidden = YES;
        _clearTextViewButton.hidden = YES;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location > 0 || text.length != 0) {
        _placeholderLabel.hidden = YES;
        _clearTextViewButton.hidden = NO;
    } else {
        _placeholderLabel.hidden = NO;
        _clearTextViewButton.hidden = YES;
    }
    return YES;
}

#pragma KeyboardNavigationToolBar delegate methods
- (void)customToolBar:(KeyboardNavigationToolBar*)toolbar buttonClicked:(KeyboardNavigationToolBarButton)selectedId {
    switch (selectedId) {
        case KeyboardNavigationToolBarPrevious:
            [self animateOut];
            [self.delegate formFieldCellDidRequestPreviousResponder:self];
            break;
        case KeyboardNavigationToolBarNext:
            [_textArea resignFirstResponder];
            [self.delegate formFieldCellDone:self];
            break;
        case KeyboardNavigationToolBarDone:
            [_textArea resignFirstResponder];
            [self animateOut];
            [self.delegate formFieldCellDone:self];
            break;
    }
}

@end
