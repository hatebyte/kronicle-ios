//
//  KronicleEngine.m
//  Kronicle
//
//  Created by Scott on 7/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KronicleEngine.h"
#import "APIRouter.h"
#import "ManagedContextController.h"
#import "Kronicle+JSON.h"
#import "Step+JSON.h"



@interface KronicleEngine () {
    @private
}
@end

@implementation KronicleEngine

+ (KronicleEngine *)current {
    static KronicleEngine *current = nil;
    if (current == nil) {
        current = [[super allocWithZone:nil] initWithHostName:@"www.google.com"];
        current.currentOperations = [[NSMutableArray alloc] init];
        [current registerOperationSubclass:[MKNetworkOperation class]];
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
//        KRList *klist = [[KRList alloc] init];
//        [klist readFromJSONDictionary:dict];
        successBlock((NSArray *)dict);
    } onFailure:failBlock];
}

- (void)fetchKronicle:(NSString *)uuid withCompletion:(void (^)(NSDictionary *dict))successBlock onFailure:(void (^)(NSError *error))failBlock  {
    //@{@"mybrabbles":@1}
    NSString *requestString = [[APIRouter current] kronicleById:uuid];
    MKNetworkOperation *op = [self operationWithURLString:requestString params:nil httpMethod:@"GET"];
    
    [self enqueueOperation:op withResponseJSONSuccessBlock:^(NSDictionary *dict) {
        
        successBlock(dict);
        
        
    } onFailure:failBlock];
    
}

- (void)fetchStepsForKronicleUUID:(NSString *)uuid withCompletion:(void (^)(NSDictionary *dict))successBlock onFailure:(void (^)(NSError *))failBlock {
    NSString *requestString = [[APIRouter current] stepsForKronicleById:uuid];
    MKNetworkOperation *op = [self operationWithURLString:requestString params:nil httpMethod:@"GET"];

    [self enqueueOperation:op withResponseJSONSuccessBlock:^(NSDictionary *dict) {
        successBlock(dict);
    } onFailure:failBlock];
}


- (MKNetworkOperation *)uploadKronicle:(Kronicle *)kronicle withCompletion:(void (^)(Kronicle *kronicle))successBlock onFailure:(void (^)(NSError *))failBlock {
    NSString *requestString = [APIRouter current].kronicles;
    
    MKNetworkOperation *op = [self operationWithURLString:requestString params:[Kronicle toDictionary:kronicle] httpMethod:@"POST"];
    //    [op addData:brabble.mediaResource.thumbnailImage forKey:@"imageUrl" mimeType:@"image/jpeg" fileName:@"image.jpeg"];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    return op;
    
}

- (MKNetworkOperation *)uploadStep:(Step *)step withCompletion:(void (^)(Step *step))successBlock onFailure:(void (^)(NSError *))failBlock {
    NSString *requestString = [[APIRouter current] stepsForKronicleById:step.parentKronicle.uuid];
    
    MKNetworkOperation *op = [self operationWithURLString:requestString params:[Step toDictionary:step] httpMethod:@"POST"];
//    [op addData:brabble.mediaResource.thumbnailImage forKey:@"imageUrl" mimeType:@"image/jpeg" fileName:@"image.jpeg"];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    return op;
}

- (void) enqueueOperation:(MKNetworkOperation *)op withResponseJSONSuccessBlock:(void (^)(id jsonResponse))successBlock
               onFailure:(void (^)(NSError *))failBlock {
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    [[KronicleEngine current].currentOperations addObject:op];
    
    [self addCompletionBlock:^(MKNetworkOperation *completed) {
        [[KronicleEngine current].currentOperations removeObject:op];
        NSArray *responseJSON = [completed responseJSON];
        successBlock(responseJSON);
    } andError:^(NSError *error){
        [[KronicleEngine current].currentOperations removeObject:op];
        failBlock(error);
    } toOperation:op];
    
    [self enqueueOperation:op];
}


- (void)addCompletionBlock:(MKNKResponseBlock)completionBlock andError:(MKNKErrorBlock)errorBlock toOperation:(MKNetworkOperation *)op {
    [op addCompletionHandler:completionBlock errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        errorBlock(error);
    }];
}


- (void)cancelCurrentOperations {
    for (MKNetworkOperation *operation in [KronicleEngine current].currentOperations) {
        [operation cancel];
    }
}

@end


















