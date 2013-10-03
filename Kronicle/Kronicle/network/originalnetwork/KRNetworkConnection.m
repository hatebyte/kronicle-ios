//
//  KRNetworkConnection.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRNetworkConnection.h"

@implementation KRNetworkConnection

static NSMutableArray *sharedConnectionList = nil;

- (id)initWithRequest:(NSURLRequest*)request {
    self = [super init];
    if(self) {
        [self setRequest:request];
    }
    return self;
}

- (void)start {
    
    _container = [[NSMutableData alloc] init];
    _internalConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    
    if (!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    id rootObject = nil;
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:_container
                                                      options:0
                                                        error:nil];
    
    [[self kRootObject] readFromJSONDictionary:d];
    
    rootObject = [self kRootObject];
    if (self.completionBlock) {
        self.completionBlock(rootObject, nil);
    }
    
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    if ([self completionBlock]) {
        [self completionBlock](nil, error);
    }
    
    [sharedConnectionList removeObject:self];
}

@end
