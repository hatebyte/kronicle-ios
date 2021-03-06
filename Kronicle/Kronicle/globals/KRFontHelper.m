//
//  KRFontHelper.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRFontHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation KRFontHelper

+ (UIFont*)getFont:(KRFont)font withSize:(KRFontSize)size {
    return [UIFont fontWithName:[KRFontHelper getFontString:font] size:size];
}


//+ (NSFont*)getNSFont:(KRFont)font withSize:(KRFontSize)size {
//    return [NSFont fontWithName:@"Palatino-Roman" size:14.0];
//}



+ (NSString*)getFontString:(KRFont)font {
    NSString *fontName;
    switch (font) {
        case KRBrandonThin:
            fontName = @"BrandonGrotesque-Thin";
            break;
        case KRBrandonLight:
            fontName = @"BrandonGrotesque-Light";
            break;
        case KRBrandonRegular:
            fontName = @"BrandonGrotesque-Regular";
            break;
        case KRBrandonMedium:
            fontName = @"BrandonGrotesque-Medium";
            break;
        case KRBrandonBold:
            fontName = @"BrandonGrotesque-Bold";
            break;
        case KRBrandonBlack:
            fontName = @"BrandonGrotesque-Black";
            break;
        case KRMinionProRegular:
            fontName = @"MinionPro-Regular";
            break;
    }
    return fontName;
}

@end
