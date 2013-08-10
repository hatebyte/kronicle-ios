//
//  KRGlobals.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/DDTTYLogger.h>

static const int ddLogLevel = LOG_LEVEL_INFO;

#define kdomain @"http://166.78.151.97:4711/"
#define kDEBUG 1


// MATH
#define degreesToRadians(x) (M_PI * x / 180.0)
#define degreesToRadiansMinus90(x) (M_PI * x / 180.0) - M_PI_2
#define radiansToDegrees(x) (x * 180 / M_PI)
