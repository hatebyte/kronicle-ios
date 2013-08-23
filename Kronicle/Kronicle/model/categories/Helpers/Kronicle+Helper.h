//
//  Kronicle+Helper.h
//  Kronicle
//
//  Created by Scott on 8/22/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Kronicle.h"

#define NO_LOCAL_KRONICLE                   @"NO_LOCAL_KRONICLE"
#define NO_LOCAL_KRONICLES                  @"NO_LOCAL_KRONICLES"

@interface Kronicle (Helper)

@property(nonatomic, readonly) NSArray *items;
@property(nonatomic, readonly) NSArray *steps;
@property(nonatomic, readonly) NSInteger stepCount;
@property(nonatomic, readonly) NSInteger totalTime;
@property(nonatomic, readonly) NSInteger rating;

+ (void)getLocaleKronicles:(void (^)(NSArray *kronicles))successBlock
                 onFailure:(void (^)(NSDictionary *dict))failBlock;

+ (void)getRemoteKronicles:(void (^)(NSArray *kronicles))successBlock
                 onFailure:(void (^)(NSError *error))failBlock;

+ (void)getLocaleKronicleWithUuid:(NSString *)uuid
                      withSuccess:(void (^)(Kronicle *kronicle))successBlock
                        onFailure:(void (^)(NSDictionary *error))failBlock ;

+ (void)getRemoteKronicleWithUuid:(NSString *)uuid
                      withSuccess:(void (^)(Kronicle *kronicle))successBlock
                        onFailure:(void (^)(NSError *error))failBlock ;

+ (void)populateLocalKronicleWithRemoteSteps:(Kronicle *)kronicle
                                 withSuccess:(void (^)(Kronicle *kronicle))successBlock
                                   onFailure:(void (^)(NSDictionary *dict))failBlock;


@end
