//
//  UIHelper.m
//  Kronicle
//
//  Created by Scott on 8/30/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "UIHelper.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"

@implementation UIHelper

+ (UITextField *)titleTextField {
    UITextField *titleTextField                = [[UITextField alloc] init];
    titleTextField.font                        = [KRFontHelper getFont:KRBrandonLight withSize:48];
    titleTextField.clearButtonMode             = UITextFieldViewModeWhileEditing;
    titleTextField.textColor                   = [UIColor blackColor];
    titleTextField.backgroundColor             = [UIColor clearColor];
    titleTextField.clipsToBounds               = YES;
    titleTextField.adjustsFontSizeToFitWidth   = YES;
    titleTextField.placeholder                 = @"Add Title";
    [titleTextField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    return titleTextField;
}

+ (UILabel *)blackLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = [KRFontHelper getFont:KRBrandonRegular withSize:20];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end
