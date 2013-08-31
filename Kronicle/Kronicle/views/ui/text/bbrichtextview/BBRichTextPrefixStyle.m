//
//  BBRichTextPrefixStyle.m
//  BBUIPreview
//
//  Created by Scott on 7/13/13.
//  Copyright (c) 2013 Scott. All rights reserved.
//

#import "BBRichTextPrefixStyle.h"

@interface BBRichTextPrefixStyle () {

}
@end

@implementation BBRichTextPrefixStyle


+ (BBRichTextPrefixStyle *)withTarget:(id)aTarget andSelector:(SEL)anAction {
	BBRichTextPrefixStyle *rtpf = [[BBRichTextPrefixStyle alloc] initWithTarget:aTarget forSelector:anAction];
	return rtpf;
}

- (id)initWithTarget:(id)aTarget forSelector:(SEL)anAction {
    if (self = [super init]) {
        self.target = aTarget;
        self.action = anAction;
        self.prefixes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addPrefix:(NSString *)prefix {
    [self.prefixes addObject:prefix];
}

@end
