//
//  KRViewListTypeViewController.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRViewListTypeViewController.h"
#import "StepsTableCellViewCell.h"
#import "KRColorHelper.h"

@interface KRViewListTypeViewController ()

@end

@implementation KRViewListTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle completion:(void (^)(int step))completion;
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _completion = completion;
        _kronicle = kronicle;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _bounds = [UIScreen mainScreen].bounds;

    _navView = [[KRKronicleNavView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, 47)];
    _navView.delegate = self;
    [self.view addSubview:_navView];
    
    _clock = [KRClock sharedClock];
    [_navView setTitleText:[_clock stringForTime]];
    [_navView setSubText:@"until next step"];
    [_navView hidePausePlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_kronicle.steps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StepsTableCellViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StepsTableCellViewCell"];
    if (cell == nil) {
        cell = [[StepsTableCellViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StepsTableCellViewCell"];
    }
    KRStep *k = (KRStep*)[_kronicle.steps objectAtIndex:indexPath.row];
    cell.titleLabel.text = k.title;
    cell.subLabel.text = [k stringTime];
    cell.kImage.image = [UIImage imageNamed:_kronicle.imageUrl];
    //cell.kImage.image = [UIImage imageNamed:@"ydstep1.png"];
    cell.number.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    if (self.currentStep == indexPath.row) {
        cell.frameimage.image = [UIImage imageNamed:@"hole-highlight"];
        cell.titleLabel.textColor = [KRColorHelper darkGrey];
    } else {
        cell.frameimage.image = [UIImage imageNamed:@"hole"];
        cell.titleLabel.textColor = [KRColorHelper lightGrey];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StepsTableCellViewCell *c = (StepsTableCellViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [c hit];
    _completion(indexPath.row);
}


#pragma navView

- (void)navViewBack:(KRKronicleNavView*)navView {
    _completion(self.currentStep);
}

- (void)navViewPlayPause:(KRKronicleNavView*)navView {
    //    NSLog(@"[_clock isPaused] : %d", [_clock isPaused]);
    if ([_clock isPaused]) {
        [_clock play];
    } else {
        [_clock pause];
    }
}

@end
