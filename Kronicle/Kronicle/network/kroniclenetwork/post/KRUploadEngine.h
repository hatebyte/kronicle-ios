//
//  KRUploadEngine.h
//  Kronicle
//
//  Created by hatebyte on 10/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "Kronicle.h"
#import "Step.h"

@interface KRUploadEngine : MKNetworkEngine

- (void)uploadKronicle:(Kronicle *)kronicle
        withCompletion:(void (^)(Kronicle *kronicle))successBlock
             onFailure:(void (^)(NSError *error, id erroredObject))failBlock
       withProgressKey:(NSString *)progressKey;

- (void)uploadStep:(Step *)step
    withCompletion:(void (^)(Step *step))successBlock
         onFailure:(void (^)(NSError *error, id erroredObject))failBlock
   withProgressKey:(NSString *)progressKey;

@end
