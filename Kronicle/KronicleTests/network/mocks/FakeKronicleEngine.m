//
//  FakeKronicleEngine.m
//  Kronicle
//
//  Created by hatebyte on 10/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "FakeKronicleEngine.h"

@implementation FakeKronicleEngine

- (void)uploadStep:(Step *)step
    withCompletion:(void (^)(Step *step))successBlock
         onFailure:(void (^)(NSError *error, id erroredObject))failBlock
   withProgressKey:(NSString *)progressKey {
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:.5f] forKey:@"stepProgress"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KronicleUploadQueueProgress" object:step userInfo:dict];
    
    if (self.failAtStep) {
        failBlock(nil, step);
    } else {
        if (self.failAtSecondStep) {
            self.failAtStep = YES;
        }
        successBlock(step);
    }
    
}

- (void)uploadKronicle:(Kronicle *)kronicle
        withCompletion:(void (^)(Kronicle *kronicle))successBlock
             onFailure:(void (^)(NSError *error, id erroredObject))failBlock
       withProgressKey:(NSString *)progressKey {
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:.5f] forKey:@"kronicleProgress"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KronicleUploadQueueProgress" object:kronicle userInfo:dict];
    
    if (self.failForKronicle) {
        failBlock(nil, kronicle);
    } else {
        successBlock(kronicle);
    }
    
}

@end
