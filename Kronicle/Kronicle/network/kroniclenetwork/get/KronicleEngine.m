//
//  KronicleEngine.m
//  Kronicle
//
//  Created by Scott on 7/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KronicleEngine.h"
#import "APIRouter.h"
#import "Kronicle+Helper.h"
#import "Kronicle+JSON.h"
#import "Step+Helper.h"
#import "Step+JSON.h"



@interface KronicleEngine () {
    dispatch_queue_t _concurrentQueue;
}

@end

@implementation KronicleEngine

+ (KronicleEngine *)current {
    static KronicleEngine *current = nil;
    if (current == nil) {
        current = [[super allocWithZone:nil] initWithHostName:@"www.google.com"];
        current.currentGetOperations = [[NSMutableArray alloc] init];
    }
    return current;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self current];
}

- (void)allKroniclesWithCompletion:(void (^)(NSArray *))successBlock onFailure:(void (^)(NSError *))failBlock {
    NSString *requestString = [APIRouter current].kronicles;
    MKNetworkOperation *op = [self operationWithURLString:requestString params:nil httpMethod:@"GET"];
    [self enqueueOperation:op withResponseJSONSuccessBlock:^(NSDictionary *dict) {
        successBlock((NSArray *)dict);
    } onFailure:failBlock];
}

- (void)fetchKronicle:(NSString *)uuid withCompletion:(void (^)(NSDictionary *dict))successBlock onFailure:(void (^)(NSError *error))failBlock  {
    NSString *requestString = [[APIRouter current] kronicleById:uuid];
    MKNetworkOperation *op = [self operationWithURLString:requestString params:nil httpMethod:@"GET"];
    
    [self enqueueOperation:op withResponseJSONSuccessBlock:^(NSDictionary *dict) {
        successBlock(dict);
        
    } onFailure:failBlock];
    
}

- (void)fetchStepsForKronicleUUID:(NSString *)uuid withCompletion:(void (^)(NSDictionary *dict))successBlock onFailure:(void (^)(NSError *))failBlock {
    NSString *requestString = [[APIRouter current] stepsForKronicleById:uuid];
    DLog(@"requestString :%@", requestString);
    MKNetworkOperation *op = [self operationWithURLString:requestString params:nil httpMethod:@"GET"];

    [self enqueueOperation:op withResponseJSONSuccessBlock:^(NSDictionary *dict) {
        successBlock(dict);
    } onFailure:failBlock];
}



- (void) enqueueOperation:(MKNetworkOperation *)op withResponseJSONSuccessBlock:(void (^)(id jsonResponse))successBlock
               onFailure:(void (^)(NSError *))failBlock {
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    [op setFreezable:YES];
    [[KronicleEngine current].currentGetOperations addObject:op];
    
    [self addCompletionBlock:^(MKNetworkOperation *completed) {
        [[KronicleEngine current].currentGetOperations removeObject:op];
        NSArray *responseJSON = [completed responseJSON];
        successBlock(responseJSON);
        
    } andError:^(NSError *error){
        [[KronicleEngine current].currentGetOperations removeObject:op];
        failBlock(error);
    
    } toOperation:op];
        
    [self enqueueOperation:op];
}


- (void)addCompletionBlock:(MKNKResponseBlock)completionBlock andError:(MKNKErrorBlock)errorBlock toOperation:(MKNetworkOperation *)op {
    [op addCompletionHandler:completionBlock
                errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        errorBlock(error);
    }];
}


- (void)cancelCurrentOperations {
    for (MKNetworkOperation *operation in [KronicleEngine current].currentGetOperations) {
        [operation cancel];
    }
}

@end


















