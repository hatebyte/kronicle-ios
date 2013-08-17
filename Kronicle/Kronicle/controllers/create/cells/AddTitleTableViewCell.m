//
//  AddTitleTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/14/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddTitleTableViewCell.h"

@interface AddTitleTableViewCell () <UITextFieldDelegate> {
    @private
    UITextField *_inputField;
}

@end

@implementation AddTitleTableViewCell


+ (CGFloat)cellHeight {
    return 115.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                     = UITableViewCellSelectionStyleNone;
        self.type                               = KRFormFieldCellTypeTitle;
        
        int cellheight                          = [AddTitleTableViewCell cellHeight];
        int fieldheight                         = 67.f;
        _inputField                             = [[UITextField alloc] initWithFrame:CGRectMake(kPadding, cellheight - fieldheight, kPaddingWidth, fieldheight)];
        _inputField.font                        = [KRFontHelper getFont:KRBrandonLight withSize:48];
        _inputField.clearButtonMode             = UITextFieldViewModeWhileEditing;
        _inputField.textColor                   = [UIColor blackColor];
        _inputField.backgroundColor             = [UIColor whiteColor];
        _inputField.clipsToBounds               = YES;
        _inputField.delegate                    = self;
        [self.contentView addSubview:_inputField];
        
        KeyboardNavigationToolBar *toolbar = [[KeyboardNavigationToolBar alloc] initWithPreviousAndNext:YES :YES];
        toolbar.delegate = self;
        [toolbar setPreviousEnabled:NO];
        [_inputField setInputAccessoryView:toolbar];

        self.contentView.backgroundColor        = [UIColor clearColor];
        self.clipsToBounds                      = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForUseWithTitle:(NSString *)title {
    _inputField.text =(title.length < 1) ? @"Add Title" : title;
}

- (void)setAsFirstResponder {
    [_inputField becomeFirstResponder];
}

- (void)resignAsFirstResponder {
    [_inputField resignFirstResponder];
}

#pragma textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.delegate formFieldCellDidBecomeFirstResponder:self];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate formFieldCellDidResignFirstResponder:self];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

#pragma KeyboardNavigationToolBar delegate methods
- (void)customToolBar:(KeyboardNavigationToolBar*)toolbar buttonClicked:(KeyboardNavigationToolBarButton)selectedId {
    switch (selectedId) {
        case KeyboardNavigationToolBarPrevious:
            [_inputField resignFirstResponder];
            break;
        case KeyboardNavigationToolBarNext:
            [self.delegate formFieldCellDidRequestNextResponder:self];
            break;
        case KeyboardNavigationToolBarDone:
            [_inputField resignFirstResponder];
            break;
    }
}



@end
