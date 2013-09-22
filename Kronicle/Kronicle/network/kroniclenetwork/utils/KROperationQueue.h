//
//  KROperationQueue.h
//  Kronicle
//
//  Created by hatebyte on 9/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kronicle+Helper.h"

@interface KROperationQueue : NSObject

@property(nonatomic, weak) Kronicle *kronicle;
@property(nonatomic, strong) NSArray *operations;

- (id)initWithKronicle:(Kronicle *)kronicle;

@end
