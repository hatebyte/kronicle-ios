//
//  KRCategoriesViewController.m
//  Kronicle
//
//  Created by Jabari Bell on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCategoriesViewController.h"
#import "KRListViewController.h"
#import "KronicleEngine.h"
#import "KRGlobals.h"
#import "KRHomeViewController.h"
#import "KRNavigationViewController.h"
#import "KRColorHelper.h"
#import "KRSearchTextFieldControlView.h"
#import "UIView+GCLibrary.h"
#import "KRCategoriesCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "KronicleBlockTableViewCell.h"
#import "Kronicle+Helper.h"
#import "KRKronicleStartViewController.h"
#import "KRReviewViewController.h"

@interface KRCategoriesViewController () <KRCategoriesCollectionViewCellDelegate, KronicleBlockTableViewCellDelegate> {
    @private
    NSArray *_kroniclesModuloed;
}

@property(strong, nonatomic) KRSearchTextFieldControlView *searchTextFieldControlView;
@property(strong, nonatomic) UICollectionView *categoriesCollectionView;
@property(strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property(strong, nonatomic) UIView *searchResultsBackground;

@end

@implementation KRCategoriesViewController {
    NSArray *_dataSource;
}

NSString *const KRCollectionCellReuseIdentifier = @"KRCollectionCellReuseIdentifier";
float const kCollectionViewAnimateTime = 0.2f;

#pragma mark - view building
- (void)buildSearchView {
    float xmargin = 20.0f;
    float ymargin = 25.0f;
    float searchFieldHeight = 90.0f;
    _searchTextFieldControlView = [[KRSearchTextFieldControlView alloc] initWithFrame:CGRectMake(xmargin, ymargin, self.view.frame.size.width - (2 * xmargin), searchFieldHeight)];
    _searchTextFieldControlView.delegate = self;
    [self.view addSubview:_searchTextFieldControlView];
}

- (void)buildCollectionView {
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setItemSize:CGSizeMake(120, 120)];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _flowLayout.minimumInteritemSpacing = 10.0f;
    _flowLayout.minimumLineSpacing = 10.0f;
    
    NSInteger w = _searchTextFieldControlView.width - 15;
    _categoriesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(((320 -  w) * .5) - 3,
                                                                                   _searchTextFieldControlView.y + (_searchTextFieldControlView.height / 2) + 25.0f,
                                                                                   w,
                                                                                   self.view.height - 1.5*_searchTextFieldControlView.height) collectionViewLayout:_flowLayout];
    _categoriesCollectionView.delegate = self;
    _categoriesCollectionView.dataSource = self;
    _categoriesCollectionView.bounces = YES;
    [_categoriesCollectionView registerClass:[KRCategoriesCollectionViewCell class] forCellWithReuseIdentifier:KRCollectionCellReuseIdentifier];
    [_categoriesCollectionView setCollectionViewLayout:_flowLayout];
    [_categoriesCollectionView setShowsHorizontalScrollIndicator:NO];
    [_categoriesCollectionView setShowsVerticalScrollIndicator:NO];
    _categoriesCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_categoriesCollectionView];
}

- (void)buildSearchWhiteBackground {
    _searchResultsBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height)];
    _searchResultsBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchResultsBackground];
}

- (void)animateSearchViewIn {
    [_searchResultsBackground setY:_searchTextFieldControlView.height + _searchTextFieldControlView.y + 5.0f];
    [UIView animateWithDuration:kCollectionViewAnimateTime delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_categoriesCollectionView setAlpha:0.0];
                     } completion:nil];
}

- (void)animateSearchViewOut {
    [_searchResultsBackground setY:self.view.height];
    [UIView animateWithDuration:kCollectionViewAnimateTime delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_categoriesCollectionView setAlpha:1.0];
                     } completion:nil];
}

#pragma mark - init stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [KRColorHelper turquoise];
    
    _dataSource = @[
                    @"culinary",
                    @"exercise",
                    @"beauty",
                    @"music",
                    @"diy",
                    @"art"];
    
    [self buildSearchView];
    [self buildSearchWhiteBackground];
    [self buildCollectionView];
    
    _tableView.frame = CGRectMake(0,0,_searchResultsBackground.frame.size.width, _searchResultsBackground.frame.size.height-314);
    _tableView.backgroundColor        = [KRColorHelper grayLight];

    [_searchResultsBackground addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Kronicle getLocaleKronicles:^(NSArray *kronicles) {
        _kroniclesModuloed = [Kronicle moduloKronicleList:kronicles];
        [_tableView reloadData];
    }
                       onFailure:^(NSDictionary *error) {
                           NSLog(@"Listview getLocal Failed, retriving remote");
                           if ([[error objectForKey:@"error"] isEqualToString:NO_LOCAL_KRONICLES]) {
                               [Kronicle getRemoteKronicles:^(NSArray *kronicles) {
                                   _kroniclesModuloed = [Kronicle moduloKronicleList:kronicles];
                                   [_tableView reloadData];
                               }
                                                  onFailure:^(NSError *error) {
                                                      NSLog(@"Cant get remote kronicle : %@", error);
                                                  }];
                           }
                       }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
    [(KRNavigationViewController *)self.navigationController setNavigationTitle:@"Discover"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - uicollectionview delegate stuff
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KRCategoriesCollectionViewCell *cell = [_categoriesCollectionView dequeueReusableCellWithReuseIdentifier:KRCollectionCellReuseIdentifier forIndexPath:indexPath];
    cell.cellTitleLabel.text = [_dataSource objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[_dataSource objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}



#pragma mark - KRCategoriesCollectionViewCellDelegate delegate stuff
- (void)categorieCellHit:(KRCategoriesCollectionViewCell *)categoriesCollectionViewCell {
    KRListViewController *krlvc = [[KRListViewController alloc] initWithCategoryName:categoriesCollectionViewCell.cellTitleLabel.text];
    [self.navigationController pushViewController:krlvc animated:YES];
}



#pragma tableview
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewer = [[UIView alloc] init];
    viewer.backgroundColor = [UIColor clearColor];
    viewer.userInteractionEnabled = NO;
    return viewer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KronicleBlockTableViewCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_kroniclesModuloed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KronicleBlockTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"KronicleCell"];
    if (!cell) {
        cell = [[KronicleBlockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KronicleCell"];
    }
    [cell prepareForReuseWithArray: [_kroniclesModuloed objectAtIndex:indexPath.row] ];
    cell.delegate = self;
    return cell;
}



#pragma kronicleblocktableviewcell
- (void)kroniclePlaybackRequested:(KronicleBlockTableViewCell *)kronicleBlockTableViewCell forKronicle:(Kronicle *)kronicle {
    if (kronicle.steps.count > 0) {
        [self navigateToKronicle:kronicle];
    } else {
        [Kronicle populateLocalKronicleWithRemoteSteps:kronicle
                                           withSuccess:^(Kronicle *k) {
                                               [self navigateToKronicle:k];
                                           }
                                             onFailure:^(NSDictionary *error) {
                                             }];
    }
}

- (void)navigateToKronicle:(Kronicle*)kronicle {
    [self animateSearchViewOut];
    
    KRKronicleStartViewController *kronicleStartViewController = [[KRKronicleStartViewController alloc] initWithNibName:@"KRKronicleStartViewController" andKronicle:kronicle];
    [self.navigationController pushViewController:kronicleStartViewController animated:YES];
    
//    KRReviewViewController *kronicleReview = [[KRReviewViewController alloc] initWithKronicle:kronicle];
//    [self.navigationController pushViewController:kronicleReview animated:YES];
//    
}


@end
























