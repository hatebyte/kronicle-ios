//
//  KRKronicleCell.h
//  Kronicle
//
//  Created by Scott on 6/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRKronicleCell.h"
#import "KRKronicle.h"

@interface KRKronicleCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, weak) KRKronicle *kronicle;

+ (CGFloat)returnHeight;

- (void)prepareForUseWithKronicle:(KRKronicle*)kronicle;
- (void)collapse;
- (void)expand;

@end
