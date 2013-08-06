//
//  KronicleEngine.m
//  Kronicle
//
//  Created by Scott on 7/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KronicleEngine.h"
#import "APIRouter.h"

#define kdomain @"http://166.78.151.97:4711/"  


@interface KronicleEngine ()
@end

@implementation KronicleEngine

+ (KronicleEngine *)current {
    static KronicleEngine *current = nil;
    if (current == nil) {
        current = [[super allocWithZone:nil] initWithHostName:@"www.google.com"];
        [current registerOperationSubclass:[MKNetworkOperation class]];
    }
    return current;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self current];
}

- (void)allKroniclesWithCompletion:(void (^)(KRList *))successBlock onFailure:(void (^)(NSError *))failBlock {
    NSString *requestString = [APIRouter current].kronicles;
    MKNetworkOperation *op = [self operationWithURLString:requestString params:nil httpMethod:@"GET"];
    [self enqueueOperation:op withResponseJSONSuccessBlock:^(NSDictionary *dict) {
        KRList *klist = [[KRList alloc] init];
        [klist readFromJSONDictionary:dict];
        successBlock(klist);
    } onFailure:failBlock];
}

- (void)fetchKronicle:(NSString *)kronicle withCompletion:(void (^)(KRKronicle *kronicle))successBlock onFailure:(void (^)(NSError *))failBlock  {
    //@{@"mybrabbles":@1}
    NSString *requestString = [NSString stringWithFormat:@"%@%@", [APIRouter current].kronicles, kronicle];
    MKNetworkOperation *op = [self operationWithURLString:requestString params:nil httpMethod:@"GET"];
    
    [self enqueueOperation:op withResponseJSONSuccessBlock:^(NSDictionary *dict) {
        KRKronicle *kronicle = [[KRKronicle alloc] init];
        [kronicle readFromJSONDictionary:dict];
        successBlock(kronicle);
    } onFailure:failBlock];
}

- (void)postKronicle:(KRKronicle *)kronicle withCompletion:(void (^)(KRKronicle *kronicle))successBlock onFailure:(void (^)(NSError *))failBlock {
    //NSString *requestString = [APIRouter current].kronicles;
    
    // kronicle turn to JSON;
    //MKNetworkOperation *op = [self operationWithURLString:requestString params:@{@"kronicle":} httpMethod:@"POST"];

}

- (void) enqueueOperation:(MKNetworkOperation *)op withResponseJSONSuccessBlock:(void (^)(id jsonResponse))successBlock
               onFailure:(void (^)(NSError *))failBlock {
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [self addCompletionBlock:^(MKNetworkOperation *completed) {
        NSArray *responseJSON = [completed responseJSON];
        successBlock(responseJSON);
    } andError:^(NSError *error){
        failBlock(error);
    } toOperation:op];
    
    [self enqueueOperation:op];
}


- (void)addCompletionBlock:(MKNKResponseBlock)completionBlock andError:(MKNKErrorBlock)errorBlock toOperation:(MKNetworkOperation *)op {
    [op addCompletionHandler:completionBlock errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        errorBlock(error);
    }];
}



@end


















