//
//  KRBaseEditTableViewController.m
//  Kronicle
//
//  Created by Scott on 8/19/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRBaseEditTableViewController.h"
#import "AddTitleTableViewCell.h"
#import "AddDescriptionTableViewCell.h"
#import "AddItemsCell.h"
#import "AddStepTableViewCell.h"
#import "AddMediaTableViewCell.h"
#import "AddTimeCell.h"
#import "KRItemsViewController.h"

@interface KRBaseEditTableViewController ()

@end

@implementation KRBaseEditTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.automaticallyAdjustsScrollViewInsets                   = NO;
    _buttonHeight                                               = 35;
    
    _tableView                                                  = [[UITableView alloc] initWithFrame:CGRectMake(0,0, _bounds.size.width, _bounds.size.height)];
    _tableView.dataSource                                       = self;
    _tableView.delegate                                         = self;
    _tableView.separatorStyle                                   = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor                                  = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _cancelButton                                               = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame                                         = CGRectMake(0, 20, 40, 40);
    [_cancelButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)validate {}



- (void)viewListItems:(Kronicle *)kronicle {}
- (void)createListItems:(Kronicle *)kronicle{}

#pragma uitableview

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *viewer = [[UIView alloc] init];
    viewer.backgroundColor = [UIColor clearColor];
    viewer.userInteractionEnabled = NO;
    return viewer;
}

- (CGFloat)returnHeightForCellType:(KRFormFieldCellType)cellType {
    return 44.f;
}

- (void)positionTableViewCellInLieuOfKeyboard:(KRFormFieldCell*)cell {
    CGFloat cellBottomY = [self returnHeightForCellType:cell.type] + cell.frame.origin.y + 20;
    CGFloat keyboardY = _bounds.size.height - [KeyboardNavigationToolBar height];
    CGFloat offsetY =  cellBottomY - keyboardY;
    offsetY =(offsetY < 0) ? 0 : offsetY;
    CGPoint offset = CGPointMake(0, offsetY);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView setContentOffset:offset animated:YES];
    });
}

#pragma mark KRFormFieldCell delegate
- (void)formFieldCellDidRequestPreviousResponder:(KRFormFieldCell *)formFieldCell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:formFieldCell];
    switch (formFieldCell.type) {
        case KRFormFieldCellTypeAddTitle: {
//            indexPath =  [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        }   break;
        case KRFormFieldCellTypeAddDescription: {
            indexPath =  [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        }   break;
        case KRFormFieldCellTypeAddItems:
            break;
        case KRFormFieldCellTypeAddStep:
            break;
        case KRFormFieldCellTypeAddMedia:
            break;
        case KRFormFieldCellTypeAddTime:
            break;
    }
    [(KRFormFieldCell *)[_tableView cellForRowAtIndexPath:indexPath] setAsFirstResponder];
}

- (void)formFieldCellDidRequestNextResponder:(KRFormFieldCell *)formFieldCell {
    _tableIsExpanded = NO;
    NSIndexPath *indexPath = [_tableView indexPathForCell:formFieldCell];
    switch (formFieldCell.type) {
        case KRFormFieldCellTypeAddTitle: {
            indexPath =  [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        }   break;
        case KRFormFieldCellTypeAddDescription: {
//            indexPath =  [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        }   break;
        case KRFormFieldCellTypeAddItems:
            break;
        case KRFormFieldCellTypeAddStep:
            break;
        case KRFormFieldCellTypeAddMedia:
            break;
        case KRFormFieldCellTypeAddTime:
            break;
    }
    [(KRFormFieldCell *)[_tableView cellForRowAtIndexPath:indexPath] setAsFirstResponder];
}

- (void)formFieldCellDidBecomeFirstResponder:(KRFormFieldCell *)formFieldCell andShouldExpand:(BOOL)shouldExpand {
    _tableIsExpanded = shouldExpand;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    [self positionTableViewCellInLieuOfKeyboard:formFieldCell];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:formFieldCell];
    switch (formFieldCell.type) {
        case KRFormFieldCellTypeAddTitle: {
            indexPath =  [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        }   break;
        case KRFormFieldCellTypeAddDescription: {
            indexPath =  [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        }   break;
        case KRFormFieldCellTypeAddItems:
            break;
        case KRFormFieldCellTypeAddStep:
            break;
        case KRFormFieldCellTypeAddMedia:
            break;
        case KRFormFieldCellTypeAddTime:
            break;
    }
    [(KRFormFieldCell *)[_tableView cellForRowAtIndexPath:indexPath] animateOut];

}

- (void)formFieldCellDidResignFirstResponder:(KRFormFieldCell *)formFieldCell andShouldContract:(BOOL)shouldContract {
    _tableIsExpanded = NO;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    [self validate];
}

- (void)formFieldCellDone:(KRFormFieldCell *)formFieldCell {
    _tableIsExpanded = NO;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    [self validate];

//    dispatch_async(dispatch_get_main_queue(), ^{
//   //     [_tableView setContentOffset:CGPointZero animated:YES];
//    });
}

//- (KRFormFieldCell *)cellForIndexPath:(NSIndexPath *)indexPath {
//    
//}
@end
