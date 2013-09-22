//
//  Step+JSON.h
//  Kronicle
//
//  Created by Scott on 8/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step.h"

@interface Step (JSON)

+ (Step *)readFromJSONDictionary:(NSDictionary *)dict;
+ (NSDictionary *)toDictionary:(Step *)step;

@end
