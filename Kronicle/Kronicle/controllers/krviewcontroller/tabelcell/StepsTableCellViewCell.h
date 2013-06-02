//
//  StepsTableCellViewCell.h
//  Kronicle
//
//  Created by Scott on 6/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KCellHeight 100.f

@interface StepsTableCellViewCell : UITableViewCell

//@property(nonatomic, strong)    UIIView *hightlight;
@property(nonatomic, strong)    UIImageView *frameimage;
@property(nonatomic, strong)    UIImageView *kImage;
@property(nonatomic, strong)    UILabel *titleLabel;
@property(nonatomic, strong)    UILabel *subLabel;
@property(nonatomic, strong)    UILabel *number;

- (void)hit;

@end
