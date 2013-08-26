//
//  KronicleBlockTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/25/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KronicleBlockTableViewCell.h"
#import "KronicleBlockView.h"
#import "KRGlobals.h"

@interface KronicleBlockTableViewCell () <KronicleBlockViewDelegate> {
@private
    __weak NSArray *_kroniclesArray;
    NSMutableArray *_blockArray;
}

@end

@implementation KronicleBlockTableViewCell


+ (CGFloat)cellHeight {
    return 200.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                     = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor        = [KRColorHelper grayLight];
    }
    return self;
}

- (void)prepareForReuseWithArray:(NSArray *)stepArray {
    _kroniclesArray = stepArray;
    int i = 0;
    KronicleBlockView *kronicleBlock;
    for (int i=0; i < [_blockArray count]; i++) {
        kronicleBlock = [_blockArray objectAtIndex:i];
        [kronicleBlock removeFromSuperview];
    }
    _blockArray = [[NSMutableArray alloc] init];
    
    i = 0;
    int size = [KronicleBlockView blockHeight] - kPadding;
    CGRect frame = CGRectMake(kPadding, 0, size, size+35);
    for (i = 0; i < _kroniclesArray.count; i++) {
        frame.origin = CGPointMake((kPadding - 1) + ((size + kPadding) * i), 0);
        id kronicle = [_kroniclesArray objectAtIndex:i];
        kronicleBlock = [[KronicleBlockView alloc] initWithFrame:frame andKronicle:kronicle];
        kronicleBlock.tag = i;
        kronicleBlock.delegate = self;
        [_blockArray addObject:kronicleBlock];
        [self.contentView addSubview:kronicleBlock];
    }
    
}

#pragma mark
- (void)kronicleBlockView:(KronicleBlockView *)kronicleBlockView deleteKronicle:(Kronicle *)kronicle {
    [self.delegate kronicleDeletionRequested:self forKronicle:kronicle];
}

- (void)kronicleBlockView:(KronicleBlockView *)kronicleBlockView requestKronicle:(Kronicle *)kronicle {
    [self.delegate kroniclePlaybackRequested:self forKronicle:kronicle];
}


@end
