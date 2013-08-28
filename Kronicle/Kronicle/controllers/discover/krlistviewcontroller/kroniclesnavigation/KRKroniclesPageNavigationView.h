//
//  KRKroniclesPageNavigationView.h
//  Kronicle
//
//  Created by Scott on 8/27/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KroniclesPageNavigationOne,
    KroniclesPageNavigationTwo,
    KroniclesPageNavigationThree,
} KroniclesPageNavigationItem;

@class KRKroniclesPageNavigationView;
@protocol KRKroniclesPageNavigationViewDelegate <NSObject>
- (void)kroniclesPageNavigationView:KRKroniclesPageNavigationView didSelect:(KroniclesPageNavigationItem)item;
@end

@interface KRKroniclesPageNavigationView : UIView

@property(nonatomic, assign) BOOL preventHit;
@property(nonatomic, weak) id <KRKroniclesPageNavigationViewDelegate> delegate;

+ (UIButton *)getItemButtonWithTitle:(NSString *)title;
+ (CGFloat)getWidthForString:(NSString *)text;

- (id)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titles;

@end
