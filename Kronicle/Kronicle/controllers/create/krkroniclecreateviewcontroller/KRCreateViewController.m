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


@interface KRCreateViewController () {
    @private
    CGRect _bounds;
    IBOutlet UITableView *_tableView;
    BOOL _inFirstCell;
    NSMutableArray *_kronicleSteps;
    UIButton *_cancelXButton;
    UIButton *_previewButton;
    int _buttonHeight;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _bounds = [UIScreen mainScreen].bounds;
    _buttonHeight = 42;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, _bounds.size.width, _bounds.size.height-20 )];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    

    _cancelXButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelXButton.backgroundColor = [KRColorHelper turquoise];
    [_cancelXButton setBackgroundImage:[UIImage imageNamed:@"close-x_40px"] forState:UIControlStateNormal];
    _cancelXButton.frame = CGRectMake(0, 0, 40, 40);
    [_cancelXButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelXButton];
  
    _previewButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.backgroundColor = [KRColorHelper orange];
    _previewButton.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:16];
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


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //                                 k.uuid : 51b0873fe3f8ae9d70000002
    //                                 k.uuid : 51b26719effe946507000002
    //                                 k.uuid : 51b26908effe946507000009
    [[KronicleEngine current] fetchKronicle:@"51b26719effe946507000002"
                             withCompletion:^(KRKronicle *kronicle) {
                                 _kronicle = kronicle;
                                 _kronicleSteps = [[NSMutableArray alloc] init];
                                 int stepsMinusFinish = kronicle.stepCount-1;
                                 NSLog(@"step count %d", kronicle.stepCount);
                                 if(stepsMinusFinish % 2 == 0) {
                                     for (int i = 0; i < stepsMinusFinish; i++) {
                                         int next = i+1;
                                         NSArray *inArray = [NSArray arrayWithObjects:[kronicle.steps objectAtIndex:i], [kronicle.steps objectAtIndex:next], nil];
                                         [_kronicleSteps addObject:inArray];
                                         i = next;
                                     }
                                     [_kronicleSteps addObject:[NSArray arrayWithObjects:@"addStep", nil]];
                                 } else {
                                     for (int i = 0; i < stepsMinusFinish; i++) {
                                         NSArray *inArray;
                                         int next = i+1;
                                         if (next < stepsMinusFinish) {
                                             inArray = [NSArray arrayWithObjects:[kronicle.steps objectAtIndex:i], [kronicle.steps objectAtIndex:next], nil];
                                         } else {
                                             inArray = [NSArray arrayWithObjects:[kronicle.steps objectAtIndex:i], @"addStep", nil];
                                         }
                                         i= next;
                                         [_kronicleSteps addObject:inArray];
                                     }
                                 }
                                 _previewButton.enabled = YES;
                                 [_tableView reloadData];
                             }
                                  onFailure:^(NSError *error) {
                                      NSLog(@"error : %@", error);
                                  }];
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
            height = [AddTitleTableViewCell cellHeight];
            break;
            
        case 1:
            height = [AddDescriptionTableViewCell cellHeight];
            break;
            
        default:
            height = [AddStepTableViewCell cellHeight];
            break;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _kronicleSteps.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            AddTitleTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            if (cell == nil) {
                cell = [[AddTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
            }
            [cell prepareForUseWithTitle:self.kronicle.title];
            return cell;
        }   break;
            
        case 1:{
            AddDescriptionTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
            if (!cell) {
                cell = [[AddDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescriptionCell"];
            }
            [cell prepareForUseWithDescription:_kronicle.description];
            return cell;
        }   break;
            
        default:{
            AddStepTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"StepCell"];
            if (!cell) {
                cell = [[AddStepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StepCell"];
            }
            
            
            
            [cell prepareForReuseWithArray: [_kronicleSteps objectAtIndex:indexPath.row-2] ];

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
    return viewer;
}

@end


































