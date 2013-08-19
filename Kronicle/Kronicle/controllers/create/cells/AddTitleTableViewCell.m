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

+ (CGFloat)cellHeightForStep { return 70.f; }
+ (CGFloat)cellHeightForKronicle { return 115.f; }
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                     = UITableViewCellSelectionStyleNone;
        self.type                               = KRFormFieldCellTypeTitle;
        
        _inputField                             = [[UITextField alloc] init];
        _inputField.font                        = [KRFontHelper getFont:KRBrandonLight withSize:48];
        _inputField.clearButtonMode             = UITextFieldViewModeWhileEditing;
        _inputField.textColor                   = [UIColor blackColor];
        _inputField.backgroundColor             = [UIColor whiteColor];
        _inputField.clipsToBounds               = YES;
        _inputField.adjustsFontSizeToFitWidth   = YES;
        _inputField.delegate                    = self;
        _inputField.placeholder                 = @"Add Title";
        [_inputField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
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

- (void)prepareForUseWithTitle:(NSString *)title andType:(AddTitleLocation)type {
    int fieldheight                         = 70.f;
    int y                                   =(type == AddTitleKronicle) ? ([AddTitleTableViewCell cellHeight] - fieldheight) : 0;
    _inputField.frame                       = CGRectMake(kPadding, y, kPaddingWidth, fieldheight);
    _inputField.text                        = title;
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
            //[_inputField resignFirstResponder];
            [self.delegate formFieldCellDidRequestNextResponder:self];
            break;
        case KeyboardNavigationToolBarDone:
            [_inputField resignFirstResponder];
            [self.delegate formFieldCellDone:self];
            break;
    }
}



@end
