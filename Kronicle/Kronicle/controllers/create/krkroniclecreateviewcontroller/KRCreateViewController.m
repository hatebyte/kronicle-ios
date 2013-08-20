//
//  krKronicleCreateViewController.m
//  Kronicle
//
//  Created by Scott on 6/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCreateViewController.h"
#import "KRStep.h"
#import "KRCreateStepViewController.h"
#import "KRHomeViewController.h"
#import "KRNavigationViewController.h"
#import "KRStep.h"
#import "AddTitleTableViewCell.h"
#import "AddDescriptionTableViewCell.h"
#import "AddStepTableViewCell.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRSwipeViewNavigation.h"
#import "KronicleEngine.h"
#import "KRGlobals.h"
#import "KRPlaybackViewController.h"
#import "AddItemsCell.h"
#import "KRItemsViewController.h"


@interface KRCreateViewController () <AddItemsCellDelegate, AddStepTableViewCellDelegate> {
    @private
    CGRect _bounds;
    UITableView *_tableView;
    NSMutableArray *_kronicleSteps;
    UIButton *_cancelXButton;
    UIButton *_previewButton;
    int _buttonHeight;
    BOOL _tableIsExpanded;
}

@end


@implementation KRCreateViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _bounds = [UIScreen mainScreen].bounds;
    _buttonHeight = 35;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, _bounds.size.width, _bounds.size.height-20 )];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
//    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"close-x_40px"] forState:UIControlStateNormal];
//    _cancelXButton       = [UIButton buttonWithType:UIButtonTypeCustom];
//    _cancelXButton.backgroundColor = [KRColorHelper turquoise];
//    [_cancelXButton setBackgroundImage:[UIImage imageNamed:@"close-x_40px"] forState:UIControlStateNormal];
//    _cancelXButton.frame = CGRectMake(0, 0, 40, 40);
//    [_cancelXButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_cancelXButton];
  
    _previewButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.backgroundColor = [KRColorHelper orange];
    _previewButton.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    [_previewButton setTitle:@"Preview" forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _previewButton.frame = CGRectMake(_bounds.size.width - (141 + kPadding), _bounds.size.height-(_buttonHeight+20), 141, _buttonHeight);
    [_previewButton addTarget:self action:@selector(previewKronicle:) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.enabled = NO;
    [self.view addSubview:_previewButton];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotificationForDurationCreation:)
                                                 name:@"DurationCreation"
                                               object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    [[KronicleEngine current] fetchKronicle:@"5212239cb0747df172000002"
//                             withCompletion:^(KRKronicle *kronicle) {
//                                 
//                                 _kronicle = kronicle;
//                                 _kronicleSteps = [[NSMutableArray alloc] init];
//                                 int stepsMinusFinish = kronicle.stepCount;
//                                 NSLog(@"step count %d", kronicle.stepCount);
//                                 if(stepsMinusFinish % 2 == 0) {
//                                     for (int i = 0; i < stepsMinusFinish; i++) {
//                                         int next = i + 1;
//                                         NSArray *inArray = [NSArray arrayWithObjects:[kronicle.steps objectAtIndex:i], [kronicle.steps objectAtIndex:next], nil];
//                                         [_kronicleSteps addObject:inArray];
//                                         i = next;
//                                     }
//                                     [_kronicleSteps addObject:[NSArray arrayWithObjects:@"addStep", nil]];
//                                 } else {
//                                     for (int i = 0; i < stepsMinusFinish; i++) {
//                                         NSArray *inArray;
//                                         int next = i + 1;
//                                         if (next < stepsMinusFinish) {
//                                             inArray = [NSArray arrayWithObjects:[kronicle.steps objectAtIndex:i], [kronicle.steps objectAtIndex:next], nil];
//                                         } else {
//                                             inArray = [NSArray arrayWithObjects:[kronicle.steps objectAtIndex:i], @"addStep", nil];
//                                         }
//                                         i= next;
//                                         [_kronicleSteps addObject:inArray];
//                                     }
//                                 }
//                                 _previewButton.enabled = YES;
//                                 [_tableView reloadData];
//                             }
//                                  onFailure:^(NSError *error) {
//                                      NSLog(@"error : %@", error);
//                                  }];

     _kronicle = [[KRKronicle alloc] init];
     _kronicleSteps = [[NSMutableArray alloc] init];
     [_kronicleSteps addObject:[NSArray arrayWithObjects:@"addStep", nil]];
    //                                 _previewButton.enabled = YES;
    //                                 [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)previewKronicle:(id)sender {
    KRPlaybackViewController *playbackViewController = [[KRPlaybackViewController alloc] initWithKronicle:self.kronicle andViewingState:KRKronicleViewingStatePreview];
    [self.navigationController pushViewController:playbackViewController animated:YES];
}



#pragma tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = [AddTitleTableViewCell cellHeightForKronicle];
            break;
        case 1:
            if (_tableIsExpanded) {
                height = [AddDescriptionTableViewCell cellHeightExpanded];
            } else {
                height = [AddDescriptionTableViewCell cellHeightKronicle];
            }
            break;
        case 2:
            height = [AddItemsCell cellHeight];
            break;
        case 3:
        default:
            height = [AddStepTableViewCell cellHeight];
            break;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _kronicleSteps.count + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            AddTitleTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            if (cell == nil) {
                cell = [[AddTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
            }
            [cell prepareForUseWithTitle:self.kronicle.title andType:AddTitleKronicle];
            [(AddTitleTableViewCell *)cell setDelegate:self];
            return cell;
        }   break;
            
        case 1:{
            AddDescriptionTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
            if (!cell) {
                cell = [[AddDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescriptionCell"];
            }
            [cell prepareForUseWithDescription:_kronicle.description andType:AddTitleKronicle];
            [(AddDescriptionTableViewCell *)cell setDelegate:self];
            return cell;
        }   break;
        case 2:{
            AddItemsCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"AddItems"];
            if (!cell) {
                cell = [[AddItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddItems"];
            }
            [(AddItemsCell *)cell setDelegate:self];
            return cell;
        }   break;
        case 3:
        default:{
            AddStepTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"StepCell"];
            if (!cell) {
                cell = [[AddStepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StepCell"];
            }
            [cell prepareForReuseWithArray: [_kronicleSteps objectAtIndex:indexPath.row-3] ];
            [(AddStepTableViewCell *)cell setDelegate:self];
            return cell;
        }   break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (_buttonHeight + 20);
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *viewer = [[UIView alloc] init];
    viewer.backgroundColor = [UIColor clearColor];
    viewer.userInteractionEnabled = NO;
    return viewer;
}
- (CGFloat)returnHeightForCellType:(KRFormFieldCellType)cellType {
    CGFloat height = 0;
    
    switch (cellType) {
        case KRFormFieldCellTypeAddTitle:
            height = [AddTitleTableViewCell cellHeight];
            break;
        case KRFormFieldCellTypeAddDescription: {
            if (_tableIsExpanded) {
                height = [AddDescriptionTableViewCell cellHeightExpanded];
            } else {
                height = [AddDescriptionTableViewCell cellHeightKronicle];
            }
        }   break;
        case KRFormFieldCellTypeAddItems:
            height = [AddItemsCell cellHeight];
            break;
        default:
            height = 0;
            break;
    }
    return height;
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
    switch (formFieldCell.type) {
        case KRFormFieldCellTypeAddTitle: {
        }   break;
        case KRFormFieldCellTypeAddDescription: {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [(AddTitleTableViewCell *)[_tableView cellForRowAtIndexPath:ip] setAsFirstResponder];
        }   break;
        case KRFormFieldCellTypeAddItems: {
        }   break;
        case KRFormFieldCellTypeAddStep:{
        }   break;

    }
}

- (void)formFieldCellDidRequestNextResponder:(KRFormFieldCell *)formFieldCell {
    _tableIsExpanded = NO;
    switch (formFieldCell.type) {
        case KRFormFieldCellTypeAddTitle: {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
            [(AddDescriptionTableViewCell *)[_tableView cellForRowAtIndexPath:ip] setAsFirstResponder];
        }   break;
        case KRFormFieldCellTypeAddDescription: {
        }   break;
        case KRFormFieldCellTypeAddItems: {
        }   break;
        case KRFormFieldCellTypeAddStep:{
        }   break;
    }
}

- (void)formFieldCellDidBecomeFirstResponder:(KRFormFieldCell *)formFieldCell andShouldExpand:(BOOL)shouldExpand {
    _tableIsExpanded = shouldExpand;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    switch (formFieldCell.type) {
        case KRFormFieldCellTypeAddTitle: {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
           [(KRFormFieldCell*)[_tableView cellForRowAtIndexPath:ip] resignAsFirstResponder];
        }   break;
        case KRFormFieldCellTypeAddDescription: {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [(KRFormFieldCell*)[_tableView cellForRowAtIndexPath:ip] resignAsFirstResponder];
        }   break;
        case KRFormFieldCellTypeAddItems: {
        
        }   break;
        case KRFormFieldCellTypeAddStep:{
        
        }   break;
    }
    
    [self positionTableViewCellInLieuOfKeyboard:formFieldCell];
}

- (void)formFieldCellDidResignFirstResponder:(KRFormFieldCell *)formFieldCell andShouldContract:(BOOL)shouldContract {
//    _tableIsExpanded = NO;
//    [_tableView beginUpdates];
//    [_tableView endUpdates];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_tableView setContentOffset:CGPointZero animated:YES];
//    });
}

- (void)formFieldCellDone:(KRFormFieldCell *)formFieldCell {
    _tableIsExpanded = NO;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView setContentOffset:CGPointZero animated:YES];
    });
}

#pragma mark AddStepTableViewCell delegate
- (void)stepDeletionRequested:(AddStepTableViewCell *)addStepTableViewCell forStep:(KRStep *)step {
    NSLog(@"stepDeletionRequested");
}

- (void)stepEditingRequested:(AddStepTableViewCell *)addStepTableViewCell forStep:(KRStep *)step {
    KRCreateStepViewController *createStepViewController = [[KRCreateStepViewController alloc] initWithStep:step];
    [self.navigationController pushViewController:createStepViewController animated:YES];
}

- (void)addStepRequested:(AddStepTableViewCell *)addStepTableViewCell {
    KRCreateStepViewController *createStepViewController = [[KRCreateStepViewController alloc] initWithStep:[[KRStep alloc] init]];
    [self.navigationController pushViewController:createStepViewController animated:YES];
}

#pragma mark AddDescriptionTableViewCell delegate
- (void)addListItemsRequested:(AddDescriptionTableViewCell *)addDescriptionTableViewCell {
    KRItemsViewController *itemsViewController = [[KRItemsViewController alloc] initWithNibName:@"KRItemsViewController" bundle:nil];
    [itemsViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController presentModalViewController:itemsViewController animated:YES];
}


@end


































