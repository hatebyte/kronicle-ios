//
//  KronicleEngine.h
//  Kronicle
//
//  Created by Scott on 7/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "KRList.h"
#import "KRKronicle.h"

@interface KronicleEngine : MKNetworkEngine

+ (KronicleEngine *)current;

- (void)allKroniclesWithCompletion:(void (^)(KRList *))successBlock onFailure:(void (^)(NSError *))failBlock;
- (void)fetchKronicle:(NSString *)kronicle withCompletion:(void (^)(KRKronicle *kronicle))successBlock onFailure:(void (^)(NSError *))failBlock;


- (void)postKronicle:(KRKronicle *)kronicle withCompletion:(void (^)(KRKronicle *kronicle))successBlock onFailure:(void (^)(NSError *))failBlock;

@end
