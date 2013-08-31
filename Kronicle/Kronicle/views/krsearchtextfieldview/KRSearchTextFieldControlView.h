//
//  KRSearchTextFieldControlView.h
//  Kronicle
//
//  Created by Jabari Bell on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRSearchTextFieldView.h"

@interface KRSearchTextFieldControlView : UIView <KRSearchTextFieldViewDelegate>

@property (strong, nonatomic) id <KRSearchTextFieldViewDelegate> delegate;

@end
