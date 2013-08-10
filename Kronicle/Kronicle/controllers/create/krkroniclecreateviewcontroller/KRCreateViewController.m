//
//  krKronicleCreateViewController.m
//  Kronicle
//
//  Created by Scott on 6/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCreateViewController.h"
#import "KRStep.h"
#import "KRKronicleCell.h"
#import "KRCreateStepViewController.h"


@interface KRCreateViewController () {
    @private
    IBOutlet UITableView *_tableView;
    BOOL _inFirstCell;
}

@end


@implementation KRCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.kronicle = [[KRKronicle alloc] init];
        _inFirstCell = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotificationForDurationCreation:)
                                                 name:@"DurationCreation"
                                               object:nil];

}

- (void)receivedNotificationForDurationCreation:(NSNotification *) notification {
    
    NSDictionary *userInfo = notification.userInfo;
    int increments = (int)[userInfo objectForKey:@"increments"];
    
    NSLog(@"increments : %d", increments);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && _inFirstCell) {
        return [KRKronicleCell returnHeight];
    } else {
        return 46.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.kronicle.steps count] + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger addRow = (int)([self.kronicle.steps count] + 1);
    NSInteger submitRow = [self.kronicle.steps count] + 2;
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [_tableView dequeueReusableCellWithIdentifier:@"KronicleCell"];
        if (cell == nil) {
            cell = [[KRKronicleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KronicleCell"];
            [(KRKronicleCell*)cell prepareForUseWithKronicle:self.kronicle];
        }
    } else if (indexPath.row == addRow) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StepCell"];
    } else if (indexPath.row ==  submitRow) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StepCell"];
    } else {
        //KRStep *step = [[self.kronicle steps] objectAtIndex:indexPath.row-1];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StepCell"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        KRCreateStepViewController *stepCreateController = [[KRCreateStepViewController alloc] initWithNibName:@"KRCreateStepViewController" bundle:nil];
        [self.navigationController pushViewController:stepCreateController animated:YES];
    }
}

@end


































