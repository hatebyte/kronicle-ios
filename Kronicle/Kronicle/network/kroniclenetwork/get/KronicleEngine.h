//
//  KronicleEngine.h
//  Kronicle
//
//  Created by Scott on 7/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "Kronicle.h"
#import "Step.h"

@interface KronicleEngine : MKNetworkEngine

@property (nonatomic, strong) NSMutableArray *currentGetOperations;

+ (KronicleEngine *)current;

// GET
- (void)allKroniclesWithCompletion:(void (^)(NSArray *))successBlock onFailure:(void (^)(NSError *))failBlock;
- (void)fetchKronicle:(NSString *)uuid withCompletion:(void (^)(NSDictionary *dict))successBlock onFailure:(void (^)(NSError *))failBlock;
- (void)fetchStepsForKronicleUUID:(NSString *)uuid withCompletion:(void (^)(NSDictionary *dict))successBlock onFailure:(void (^)(NSError *))failBlock;


// CANCEl currentGets
- (void)cancelCurrentOperations;


@end
