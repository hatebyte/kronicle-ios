//
//  KroniclesList.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRSerializable.h"

@interface KRList : NSObject <KRSerializable>

@property (nonatomic, strong) NSMutableArray *kronicles;

@end