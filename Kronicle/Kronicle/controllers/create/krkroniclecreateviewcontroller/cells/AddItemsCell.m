//
//  AddItemsCell.m
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddItemsCell.h"

@interface AddItemsCell () {
    @private
    UIImageView *_hamburgerImageView;
    UILabel *_addItemsLabel;
    UIButton *_addItemCatcher;
    UIButton *_clearTextViewButton;
}

@end

@implementation AddItemsCell

+ (CGFloat)cellHeight { return 46.f; }

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                         = UITableViewCellSelectionStyleNone;
        self.type                                   = KRFormFieldCellTypeAddItems;
        
        _hamburgerImageView                         = [[UIImageView alloc] init];
        _hamburgerImageView.image                   = [UIImage imageNamed:@"hamburger_50px"];
        _hamburgerImageView.frame                   = CGRectMake(kPadding,
                                                                 kPadding,
                                                                 15,
                                                                 15);
        [self.contentView addSubview:_hamburgerImageView];
        
        _addItemCatcher                             = [UIButton buttonWithType:UIButtonTypeCustom];
        _addItemCatcher.frame                       = CGRectMake(kPadding,
                                                                 0,
                                                                 120,
                                                                 45);
        _addItemCatcher.titleLabel.font             = [KRFontHelper getFont:KRBrandonRegular withSize:16];
        _addItemCatcher.backgroundColor             = [UIColor clearColor];
        [_addItemCatcher setTitleColor:[KRColorHelper turquoise] forState:UIControlStateNormal];
        [_addItemCatcher setTitle:@"Add Items" forState:UIControlStateNormal];
        [_addItemCatcher addTarget:self action:@selector(addItems:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addItemCatcher];
        
        self.contentView.backgroundColor            = [UIColor clearColor];

    }
    return self;
}

- (IBAction)addItems:(id)sender {
    [((id<AddItemsCellDelegate>)self.delegate) addListItemsRequested:self];
}

@end
