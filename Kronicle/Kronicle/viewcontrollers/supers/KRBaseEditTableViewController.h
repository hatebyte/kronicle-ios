//
//  KRBaseEditTableViewController.h
//  Kronicle
//
//  Created by Scott on 8/19/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRKronicleBaseViewController.h"
#import "KRFormFieldCell.h"

@interface KRBaseEditTableViewController : KRKronicleBaseViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, KRFormFieldCellDelegate> {
    @protected
    UITableView *_tableView;
    UIButton *_cancelButton;
    int _buttonHeight;
    BOOL _tableIsExpanded;
}


- (CGFloat)returnHeightForCellType:(KRFormFieldCellType)cellType;
- (void)validate;

@end
