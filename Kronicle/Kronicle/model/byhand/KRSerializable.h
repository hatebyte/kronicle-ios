//
//  KRSerializable.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KRSerializable <NSObject>

- (void)readFromJSONDictionary:(NSDictionary *)d;
//- (NSData *)writeToJSONData;

@end

