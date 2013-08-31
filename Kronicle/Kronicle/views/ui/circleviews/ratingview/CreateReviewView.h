//
//  CreateReviewView.h
//  Kronicle
//
//  Created by Scott on 8/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CreateReviewViewShow,
    CreateReviewViewCreate
} CreateReviewViewType;

@class CreateReviewView;
@protocol CreateReviewViewDelegate <NSObject>
- (void)createReviewView:(CreateReviewView *)createReviewView finishedWithValue:(NSInteger)value;
@end


@interface CreateReviewView : UIView

@property(nonatomic, weak) id <CreateReviewViewDelegate> delegate;
@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) CGFloat percent;
@property(nonatomic, assign) int value;
@property(nonatomic, strong) UIColor *strokeColorBackground;
@property(nonatomic, strong) UIColor *strokeColor;

+ (CGFloat)size;

- (id)initWithFrame:(CGRect)frame andType:(CreateReviewViewType)type;
- (void)setReviewWithValue:(CGFloat)value;

@end
