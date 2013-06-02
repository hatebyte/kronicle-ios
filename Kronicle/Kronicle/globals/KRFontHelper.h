//
//  KRFontHelper.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    KRBrandonThin                   = 0,
    KRBrandonLight                  = 1,
    KRBrandonRegular                = 2,
    KRBrandonMedium                 = 3,
    KRBrandonBold                   = 4,
    KRBrandonBlack                  = 5,
    KRMinionProRegular              = 6,
};
typedef NSInteger KRFont;

enum {
    KRFontSizeSmall              = 12,
    KRFontSizeRegular            = 14,
    KRFontSizeMedium             = 18,
    KRFontSizeLarge              = 24,
    KRFontSizeHuge               = 36,
};
typedef NSInteger KRFontSize;

@interface KRFontHelper : NSObject

+ (UIFont*)getFont:(KRFont)font withSize:(KRFontSize)size;
+ (NSString*)getFontString:(KRFont)font;

@end
