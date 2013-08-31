//
//  KRTextButton.h
//  Kronicle
//
//  Created by Jabari Bell on 8/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

enum {
    KRTextButtonTypeHomeScreen
};
typedef NSUInteger KRTextButtonType;

#import <UIKit/UIKit.h>

@interface KRTextButton : UIButton

- (id)initWithFrame:(CGRect)frame andType:(KRTextButtonType)type andIcon:(UIImage*)image;

@end
