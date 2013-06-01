//
//  KRStep.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRSerializable.h"

@interface KRStep : NSObject <KRSerializable>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *parentKronicleId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, assign) NSUInteger indexInKronicle;

@end
