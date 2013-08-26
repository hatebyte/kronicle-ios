//
//  KRSearchTextFieldView.h
//  Kronicle
//
//  Created by Jabari Bell on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KRSearchTextFieldViewDelegate <NSObject>
@optional
- (void)animateControlButtonsIn;
- (void)animateControlButtonsOut;
- (void)animateSearchViewIn;
- (void)animateSearchViewOut;
@end

@interface KRSearchTextFieldView : UIView <UITextFieldDelegate>

@property(nonatomic, strong) id <KRSearchTextFieldViewDelegate> delegate;

@property(nonatomic, strong) UITextField *searchTextField;

@end
