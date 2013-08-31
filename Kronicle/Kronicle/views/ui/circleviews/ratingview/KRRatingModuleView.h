//
//  KRRatingModuleView.h
//  Kronicle
//
//  Created by Scott on 8/29/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KRRatingModuleBlock,
    KRRatingModuleStart,
} KRRatingModuleStyle;

@interface KRRatingModuleView : UIView

- (id)initWithPoint:(CGPoint)point andStyle:(KRRatingModuleStyle)style andRating:(CGFloat)rating;
- (void)setRating:(CGFloat)rating;


@end
