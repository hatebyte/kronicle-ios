//
//  KRUploadEngine.m
//  Kronicle
//
//  Created by hatebyte on 10/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRUploadEngine.h"
#import "APIRouter.h"
#import "Kronicle+Helper.h"
#import "Kronicle+JSON.h"
#import "Step+Helper.h"
#import "Step+JSON.h"

@interface KRUploadEngine () {
    dispatch_queue_t _concurrentQueue;
}

@end

@implementation KRUploadEngine

- (id)init {
    if(self = [super initWithHostName:@"www.google.com"]) {
        _concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)uploadKronicle:(Kronicle *)kronicle
        withCompletion:(void (^)(Kronicle *kronicle))successBlock
             onFailure:(void (^)(NSError *error, id erroredObject))failBlock
       withProgressKey:(NSString *)progressKey {
    
    NSString *requestString                 = [APIRouter current].kronicles;
    MKNetworkOperation *op                  = [self operationWithURLString:requestString params:[Kronicle toDictionary:kronicle] httpMethod:@"POST"];
    
    if (kronicle.fullCoverURL.length > 0) {
        dispatch_sync(_concurrentQueue, ^{
            NSData *imageData               = [NSData dataWithContentsOfFile:[kronicle fullCoverURL]];
            [op addData:imageData forKey:@"coverImageData" mimeType:@"image/jpeg" fileName:@"image.jpeg"];
        });
    }
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    [op setFreezable:YES];
    [op onUploadProgressChanged:^(double progress){
        [op onUploadProgressChanged:^(double progress){
            NSDictionary *dict              = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:progress] forKey:@"kronicleProgress"];
            [[NSNotificationCenter defaultCenter] postNotificationName:progressKey object:kronicle userInfo:dict];
        }];
    }];

    [op addCompletionHandler:^(MKNetworkOperation *completed) {
                    NSArray *responseJSON   = [completed responseJSON];
                    NSLog(@"uploadKronicle->repsonseJSON :: %@", responseJSON);
                    successBlock(kronicle);
                }
                errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
                    failBlock(error, kronicle);
                }];
    [self enqueueOperation:op];
}

- (void)uploadStep:(Step *)step
    withCompletion:(void (^)(Step *step))successBlock
         onFailure:(void (^)(NSError *error, id erroredObject))failBlock
   withProgressKey:(NSString *)progressKey {
    
    NSString *requestString                 = [[APIRouter current] stepsForKronicleById:step.parentKronicle.uuid];
    MKNetworkOperation *op                  = [self operationWithURLString:requestString params:[Step toDictionary:step] httpMethod:@"POST"];
        
    if (step.mediaUrl.length > 0) {
        dispatch_sync(_concurrentQueue, ^{
            NSData *imageData               = [NSData dataWithContentsOfFile:[step fullMediaURL]];
            [op addData:imageData forKey:@"mediaData" mimeType:@"image/jpeg" fileName:@"image.jpeg"];
        });
    }
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    [op setFreezable:YES];
    [op onUploadProgressChanged:^(double progress){
        NSDictionary *dict                  = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:progress] forKey:@"stepProgress"];
        [[NSNotificationCenter defaultCenter] postNotificationName:progressKey object:step userInfo:dict];
    }];

    [op addCompletionHandler:^(MKNetworkOperation *completed) {
                    NSArray *responseJSON = [completed responseJSON];
                    NSLog(@"uploadKronicle->repsonseJSON :: %@", responseJSON);
                    successBlock(step);
                }
                errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
                    failBlock(error, step);
                }];
    [self enqueueOperation:op];
}

@end
