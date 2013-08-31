//
//  KronicleBlockView.h
//  Kronicle
//
//  Created by Scott on 8/25/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "StepBlockView.h"
#import "Kronicle+Helper.h"

@class KronicleBlockView;
@protocol KronicleBlockViewDelegate <NSObject>
@optional
- (void)kronicleBlockView:(KronicleBlockView *)kronicleBlockView deleteKronicle:(Kronicle *)kronicle;

- (void)kronicleBlockView:(KronicleBlockView *)kronicleBlockView requestKronicle:(Kronicle *)kronicle;
@end

@interface KronicleBlockView : UIView


@property (nonatomic, weak) id <KronicleBlockViewDelegate> delegate;
@property (nonatomic, assign) BOOL deleteIsHidden;

+ (CGFloat)blockHeight;

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle;

@end
