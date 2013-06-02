//
//  KRAPIStore.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRAPIStore.h"
#import "KRNetworkConnection.h"

//#define kdomain @"http://localhost:4711/"
//#define kdomain @"http://172.20.10.3:4711/"
//#define kdomain @"http://10.10.21.110:4711/"
#define kdomain @"http://10.10.21.86:4711/"

@implementation KRAPIStore

+ (KRAPIStore *)sharedStore {
    static KRAPIStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[KRAPIStore alloc] init];
    return feedStore;
}

- (void)fetchAllKroniclesWithCompletion:(void (^)(KRList *k, NSError *err))block {
    NSString *requestString = [NSString stringWithFormat:@"%@kronicles/", kdomain ];
    NSURL *url = [NSURL URLWithString:requestString];
    
    // Set up the connection as normal
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    KRNetworkConnection *connection = [[KRNetworkConnection alloc] initWithRequest:req];
    // set array from protocol
    KRList *k = [[KRList alloc] init];
    [connection setKRootObject:k];
    [connection setCompletionBlock:block];
    [connection start];
}

- (void)fetchKronicle:(NSString *)kronicle withCompletion:(void (^)(KRKronicle *kronicle, NSError *err))block {
    NSString *requestString = [NSString stringWithFormat:@"%@kronicles/%@", kdomain, kronicle];
    NSURL *url = [NSURL URLWithString:requestString];
    
    // Set up the connection as normal
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    KRNetworkConnection *connection = [[KRNetworkConnection alloc] initWithRequest:req];
    // set Kronicle from protocol
    
    KRKronicle *k = [[KRKronicle alloc] init];
    [connection setKRootObject:k];
    [connection setCompletionBlock:block];
    [connection start];
}


@end
