//
//  KRFormFieldCell.h
//  Kronicle
//
//  Created by Scott on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRGlobals.h"
#import "KeyboardNavigationToolBar.h"

typedef enum {
    KRFormFieldCellTypeTitle,
    KRFormFieldCellTypeDescription
} KRFormFieldCellType;


@class KRFormFieldCell;
@protocol KRFormFieldCellDelegate <NSObject>

- (void)formFieldCellDidBecomeFirstResponder:(KRFormFieldCell *)formFieldCell;
- (void)formFieldCellDidResignFirstResponder:(KRFormFieldCell *)formFieldCell;
- (void)formFieldCellDidRequestPreviousResponder:(KRFormFieldCell *)formFieldCell;
- (void)formFieldCellDidRequestNextResponder:(KRFormFieldCell *)formFieldCell;

@end

@interface KRFormFieldCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate, KeyboardNavigationToolBarDelegate>

@property (nonatomic, weak) id <KRFormFieldCellDelegate> delegate;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) KRFormFieldCellType type;

+ (CGFloat)cellHeight;

- (void)setAsFirstResponder;
- (void)resignAsFirstResponder;

@end
