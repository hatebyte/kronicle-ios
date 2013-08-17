//
//  AddDescriptionTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddDescriptionTableViewCell.h"

@interface AddDescriptionTableViewCell () <UITextViewDelegate> {
    @private
    UITextView *_textArea;
    UIImageView *_hamburgerImageView;
    UILabel *_addItemsLabel;
    UILabel *_placeholderLabel;
    UIButton *_addItemCatcher;
    UIButton *_clearTextViewButton;
}

@end

@implementation AddDescriptionTableViewCell

+ (CGFloat)cellHeight {
    return 80.f;
}

+ (CGFloat)cellHeightExpanded {
    return 200.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                     = UITableViewCellSelectionStyleNone;
        self.type                               = KRFormFieldCellTypeDescription;

        _textArea                               = [[UITextView alloc] initWithFrame:CGRectMake(kPadding-8, 0, kPaddingWidth, 32)];
        _textArea.font                          = [KRFontHelper getFont:KRMinionProRegular withSize:20];
        _textArea.delegate                      = self;
        _textArea.scrollEnabled                 = YES;
        _textArea.textColor                     = [UIColor blackColor];
        _textArea.backgroundColor               = [UIColor whiteColor];
        [self.contentView addSubview:_textArea];

        KeyboardNavigationToolBar *toolbar = [[KeyboardNavigationToolBar alloc] initWithPreviousAndNext:YES :YES];
        toolbar.delegate = self;
        [toolbar setNextEnabled:NO];
        [_textArea setInputAccessoryView:toolbar];

        _placeholderLabel                       = [[UILabel alloc] initWithFrame:CGRectMake(_textArea.frame.origin.x + 8,
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
        [self.contentView addSubview:_clearTextViewButton];
        _clearTextViewButton.hidden             = YES;

        _hamburgerImageView                     = [[UIImageView alloc] init];
        _hamburgerImageView.image               = [UIImage imageNamed:@"hamburger_50px"];
        [self.contentView addSubview:_hamburgerImageView];
        
        _addItemCatcher                         = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addItemCatcher setTitleColor:[KRColorHelper turquoise] forState:UIControlStateNormal];
        [_addItemCatcher setTitle:@"Add Items" forState:UIControlStateNormal];
        _addItemCatcher.titleLabel.font         = [KRFontHelper getFont:KRBrandonRegular withSize:16];
        _addItemCatcher.backgroundColor         = [UIColor clearColor];
        
        [self positionItemUnderTextView];

        [_addItemCatcher addTarget:self action:@selector(addItems:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addItemCatcher];

        self.contentView.backgroundColor        = [UIColor clearColor];
    }
    return self;
}

- (void)positionItemUnderTextView {
    _clearTextViewButton.frame                  = CGRectMake((_textArea.frame.origin.x + _textArea.frame.size.width) - 30,
                                                             (_textArea.frame.origin.y + _textArea.frame.size.height) - 30,
                                                             30,
                                                            30);
    _hamburgerImageView.frame                   = CGRectMake(kPadding,
                                                             _textArea.frame.size.height + _textArea.frame.origin.y + kPadding + 3,
                                                             15,
                                                             15);
    _addItemCatcher.frame                       = CGRectMake(kPadding,
                                                             _textArea.frame.size.height + _textArea.frame.origin.y + 3,
                                                             120,
                                                             45);

}

- (IBAction)addItems:(id)sender {
    [((id<AddDescriptionTableViewCellDelegate>)self.delegate) addListItemsRequested:self];
}

- (void)prepareForUseWithDescription:(NSString *)description {
    if (description.length >= 1) {
        _placeholderLabel.hidden = YES;
        _textArea.text = description;
    } else {
        _placeholderLabel.hidden = NO;
    }
}

- (void)setAsFirstResponder {
    if (_textArea.editable) {
    }
    [_textArea performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
}

- (void)resignAsFirstResponder {
    _clearTextViewButton.hidden = YES;
    [_textArea resignFirstResponder];
}


- (void)clearTextArea {
    _textArea.text = @"";
    _placeholderLabel.hidden = NO;
    _clearTextViewButton.hidden = YES;
    [self setAsFirstResponder];
}

#pragma UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self.delegate formFieldCellDidBecomeFirstResponderWithExpansion:self];
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _textArea.frame                = CGRectMake(_textArea.frame.origin.x,
                                                                     _textArea.frame.origin.y,
                                                                     _textArea.frame.size.width,
                                                                     135);
                         [self positionItemUnderTextView];
                     }
                     completion:^(BOOL fin){}];

    if ( textView.text.length > 0) {
        _placeholderLabel.hidden = YES;
        _clearTextViewButton.hidden = NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.delegate formFieldCellDidResignFirstResponder:self];
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _textArea.frame = CGRectMake(_textArea.frame.origin.x,
                                                      _textArea.frame.origin.y,
                                                      _textArea.frame.size.width,
                                                      32);
                         [self positionItemUnderTextView];
                     }
                     completion:^(BOOL fin){}];

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
            [self.delegate formFieldCellDidRequestPreviousResponder:self];
            break;
        case KeyboardNavigationToolBarNext:
            [_textArea resignFirstResponder];
            break;
        case KeyboardNavigationToolBarDone:
            [_textArea resignFirstResponder];
            break;
    }
}

@end
