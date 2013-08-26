//
//  KRDefaultButton.h
//  Kronicle
//
//  Created by Jabari Bell on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

enum {
    KRDefaultButtonTypeCancelSearch,
    KRDefaultButtonTypeControlSearch
};

typedef NSUInteger KRDefaultButtonType;

#import <UIKit/UIKit.h>

@interface KRDefaultButton : UIButton

- (id)initWithFrame:(CGRect)frame andType:(KRDefaultButtonType)type;
- (void)setButtonTitle:(NSString*)title;

@end
