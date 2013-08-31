//
//  KronicleBlockTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/25/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kronicle+Helper.h"

@class KronicleBlockTableViewCell;
@protocol KronicleBlockTableViewCellDelegate <NSObject>
@optional
- (void)kronicleDeletionRequested:(KronicleBlockTableViewCell *)kronicleBlockTableViewCell forKronicle:(Kronicle *)kronicle;

- (void)kroniclePlaybackRequested:(KronicleBlockTableViewCell *)kronicleBlockTableViewCell forKronicle:(Kronicle *)kronicle;

@end

@interface KronicleBlockTableViewCell : UITableViewCell

@property (nonatomic, weak) id <KronicleBlockTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL deleteIsHidden;

+ (CGFloat)cellHeight;

- (void)prepareForReuseWithArray:(NSArray *)stepArray;

@end


