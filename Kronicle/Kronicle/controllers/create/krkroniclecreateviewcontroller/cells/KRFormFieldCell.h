//
//  KRFormFieldCell.h
//  Kronicle
//
//  Created by Scott on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRFormFieldCell;
@protocol KRFormFieldCellDelegate <NSObject>

- (void)formFieldCellDidBecomeFirstResponder:(KRFormFieldCell *)formFieldCell;
- (void)formFieldCellDidResignFirstResponder:(KRFormFieldCell *)formFieldCell;

@end

@interface KRFormFieldCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, weak) id <KRFormFieldCellDelegate> delgate;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL isEnabled;

+ (CGFloat)cellHeight;

- (void)setAsFirstResponder;
- (void)resignAsFirstResponder;
- (BOOL)wasEdited;

@end
