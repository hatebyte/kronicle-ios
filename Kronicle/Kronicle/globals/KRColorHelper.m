//
//  KRColorHelper.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRColorHelper.h"

@implementation KRColorHelper

+ (UIColor*)blueLight {
    return [UIColor colorWithRed:.36f green:.82f blue:.87f alpha:1];
}

+ (UIColor*)blueDark {
    return [UIColor colorWithRed:.14f green:.68f blue:.75f alpha:1];
}

+ (UIColor*)grayLight {
    return [UIColor colorWithRed:.91f green:.91f blue:.91f alpha:1];
}

+ (UIColor*)grayMedium {
    return [UIColor colorWithRed:.61f green:.61f blue:.61f alpha:1];
}
+ (UIColor*)grayDark {
    return [UIColor colorWithRed:.32f green:.32f blue:.32f alpha:1];
}

+ (UIColor*)orange {
    return [UIColor colorWithRed:241/255.0f green:163/255.0f blue:37/255.0f alpha:1.0f];  
}

+ (UIColor*)orangeTransparent {
    return [UIColor colorWithRed:241/255.0f green:163/255.0f blue:37/255.0f alpha:.3f]; 
}

+ (UIColor*)turquoise {
    return [UIColor colorWithRed:64/255.0f green:188/255.0f blue:178/255.0f alpha:1.0f]; //40BCB2
}

+ (UIColor*)turquoiseLight {
    return [UIColor colorWithRed:117/255.0f green:204/255.0f blue:197/255.0f alpha:1.0f]; //75CCC5
}

+ (UIColor*)turquoiseDark {
    return [UIColor colorWithRed:50/255.0f green:131/255.0f blue:124/255.0f alpha:1.0f]; //32837C
}

+ (UIColor*)turquoiseTransparent {
    return [UIColor colorWithRed:64/255.0f green:188/255.0f blue:178/255.0f alpha:.30f]; //40BCB2
}


@end
