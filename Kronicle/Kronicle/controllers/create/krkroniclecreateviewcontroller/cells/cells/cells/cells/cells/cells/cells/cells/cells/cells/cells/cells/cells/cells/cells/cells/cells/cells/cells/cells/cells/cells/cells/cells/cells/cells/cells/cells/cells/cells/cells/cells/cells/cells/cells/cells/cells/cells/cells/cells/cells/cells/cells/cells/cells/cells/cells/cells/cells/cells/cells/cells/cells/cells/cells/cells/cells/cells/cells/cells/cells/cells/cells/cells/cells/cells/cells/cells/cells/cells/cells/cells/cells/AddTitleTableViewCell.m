//
//  AddTitleTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/14/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddTitleTableViewCell.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRGlobals.h"

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        int cellheight = [AddTitleTableViewCell cellHeight];
        int fieldheight = 55.f;
        _inputField = [[UITextField alloc] initWithFrame:CGRectMake(kPadding-4, cellheight - fieldheight, kPaddingWidth, fieldheight)];
        _inputField.font = [KRFontHelper getFont:KRBrandonLight withSize:50];
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.textColor = [UIColor blackColor];
        _inputField.backgroundColor = [UIColor whiteColor];
        _inputField.delegate = self;
        [self.contentView addSubview:_inputField];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
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

@end
