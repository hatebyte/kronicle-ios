//
//  AddDescriptionTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddDescriptionTableViewCell.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRGlobals.h"

@interface AddDescriptionTableViewCell () <UITextViewDelegate> {
    @private
    UITextView *_textArea;
    UIImageView *_hamburgerImageView;
    UILabel *_addItemsLabel;
    UIButton *_addItemCatcher;
}

@end

@implementation AddDescriptionTableViewCell

+ (CGFloat)cellHeight {
    return 80.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                 = UITableViewCellSelectionStyleNone;
        _textArea                           = [[UITextView alloc] initWithFrame:CGRectMake(kPadding-8, 4, kPaddingWidth, 32)];
        _textArea.font                      = [KRFontHelper getFont:KRMinionProRegular withSize:20];
        _textArea.delegate                  = self;
        _textArea.textColor                 = [UIColor blackColor];
        _textArea.backgroundColor           = [UIColor clearColor];
        [self.contentView addSubview:_textArea];

        
        _hamburgerImageView                 = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding,
                                                                                            _textArea.frame.size.height + _textArea.frame.origin.y + kPadding,
                                                                                            15,
                                                                                            15)];
        _hamburgerImageView.image           = [UIImage imageNamed:@"hamburger_50px"];
        [self.contentView addSubview:_hamburgerImageView];
        
        _addItemCatcher                     = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addItemCatcher setTitleColor:[KRColorHelper turquoise] forState:UIControlStateNormal];
        [_addItemCatcher setTitle:@"Add Items" forState:UIControlStateNormal];
        _addItemCatcher.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:16];
        _addItemCatcher.backgroundColor     = [UIColor clearColor];
        _addItemCatcher.frame               = CGRectMake(kPadding,
                                                         _textArea.frame.size.height + _textArea.frame.origin.y,
                                                         120,
                                                         45);
        [_addItemCatcher addTarget:self action:@selector(addItems:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addItemCatcher];

        self.contentView.backgroundColor    = [UIColor clearColor];
    }
    return self;
}

- (IBAction)addItems:(id)sender {
    NSLog(@"addItems");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForUseWithDescription:(NSString *)description {
    _textArea.text =(description.length < 1) ? @"Add description" : description;
}


@end
