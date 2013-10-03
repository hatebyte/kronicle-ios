//
//  KRAPIStore.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRList.h"
#import "KRKronicle.h"

@interface KRAPIStore : NSObject

+ (KRAPIStore *)sharedStore;

- (void)fetchAllKroniclesWithCompletion:(void (^)(KRList *k, NSError *err))block;
- (void)fetchKronicle:(NSString *)kronicle withCompletion:(void (^)(KRKronicle *kronicle, NSError *err))block;

@end