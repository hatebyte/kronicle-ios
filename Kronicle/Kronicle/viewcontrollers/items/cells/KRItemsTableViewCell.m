//
//  KRItemsTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/28/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRItemsTableViewCell.h"
#import "KRGlobals.h"

@interface KRItemsTableViewCell () <UITextFieldDelegate> {
    @private
    UIButton *_checkButton;
    UITextField *_itemTitle;
}

@end

@implementation KRItemsTableViewCell

+ (CGFloat)cellHeight {
    return 42;
}

- (id)initWithType:(KRItemsListType)type reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                    = UITableViewCellSelectionStyleNone;
        _itemType                              = type;
        
        _checkButton                           = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkButton.frame                     = CGRectMake(8, 0, [KRItemsTableViewCell cellHeight],[KRItemsTableViewCell cellHeight]);
        _checkButton.backgroundColor           = [UIColor clearColor];
        _checkButton.userInteractionEnabled    = NO;
        [_checkButton setImage:[UIImage imageNamed:@"item_unacquired"] forState:UIControlStateNormal];
        [self.contentView addSubview:_checkButton];
        
        _itemTitle                             = [[UITextField alloc] init];
        _itemTitle.font                        = [KRFontHelper getFont:KRBrandonLight withSize:30];
        _itemTitle.clearButtonMode             = UITextFieldViewModeWhileEditing;
        _itemTitle.textColor                   = [UIColor blackColor];
        _itemTitle.backgroundColor             = [UIColor clearColor];
        _itemTitle.clipsToBounds               = YES;
        _itemTitle.adjustsFontSizeToFitWidth   = YES;
        _itemTitle.delegate                    = self;
        _itemTitle.placeholder                 = @"Add Item";
        _itemTitle.enabled                     = (_itemType == KRItemsListUse) ? NO : YES;
        _itemTitle.userInteractionEnabled      = NO;
        _itemTitle.frame                       = CGRectMake((_checkButton.frame.size.width + _checkButton.frame.origin.x) + 4,
                                                            0,
                                                            320 - (_checkButton.frame.size.width + _checkButton.frame.origin.x + 20),
                                                            [KRItemsTableViewCell cellHeight]);
        [self.contentView addSubview:_itemTitle];
        
        self.backgroundColor                   = [UIColor whiteColor];
        self.contentView.backgroundColor       = [UIColor whiteColor];
        self.backgroundView.backgroundColor    = [UIColor whiteColor];
    }
    return self;
}

- (void)prepareForUseWith:(Item *)item {
    _item = item;
    if (item != nil) {
        _itemTitle.text = item.name;
        self.acquired = _item.hasBeenAcquired;
    } else {

    }
}

- (void)setAcquired:(BOOL)acquired {
    NSLog(@"_item.hasBeenAcquired : %d", _item.hasBeenAcquired);
    _item.hasBeenAcquired = acquired;
    NSLog(@"_item.hasBeenAcquired : %d", _item.hasBeenAcquired);
    if (_item.hasBeenAcquired) {
        _itemTitle.textColor                   = [KRColorHelper turquoise];
        [_checkButton setImage:[UIImage imageNamed:@"listitem_acquired"] forState:UIControlStateNormal];

    } else {
        _itemTitle.textColor                   = [UIColor blackColor];
        [_checkButton setImage:[UIImage imageNamed:@"listitem_unacquired"] forState:UIControlStateNormal];
    }
}

- (BOOL)acquired {
    return _item.hasBeenAcquired;
}

#pragma textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [self.delegate formFieldCellDidBecomeFirstResponder:self andShouldExpand:NO];
//    [self animateIn];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self.delegate formFieldCellDidResignFirstResponder:self andShouldContract:NO];
//    [self animateOut];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end
