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

@interface KRCategoriesViewController () <KRCategoriesCollectionViewCellDelegate>

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
- (void)buildSearchView
{
    float xmargin = 20.0f;
    float ymargin = 25.0f;
    float searchFieldHeight = 90.0f;
    _searchTextFieldControlView = [[KRSearchTextFieldControlView alloc] initWithFrame:CGRectMake(xmargin, ymargin, self.view.frame.size.width - (2 * xmargin), searchFieldHeight)];
    _searchTextFieldControlView.delegate = self;
    [self.view addSubview:_searchTextFieldControlView];
}

- (void)buildCollectionView
{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setItemSize:CGSizeMake(120, 120)];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _flowLayout.minimumInteritemSpacing = 0.0f;
    _flowLayout.minimumLineSpacing = 20.0f;
    
    _categoriesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_searchTextFieldControlView.x, _searchTextFieldControlView.y + (_searchTextFieldControlView.height / 2) + 10.0f, _searchTextFieldControlView.width, self.view.height - 1.5*_searchTextFieldControlView.height) collectionViewLayout:_flowLayout];
    _categoriesCollectionView.delegate = self;
    _categoriesCollectionView.dataSource = self;
    [_categoriesCollectionView registerClass:[KRCategoriesCollectionViewCell class] forCellWithReuseIdentifier:KRCollectionCellReuseIdentifier];
    [_categoriesCollectionView setCollectionViewLayout:_flowLayout];
    _categoriesCollectionView.bounces = YES;
    [_categoriesCollectionView setShowsHorizontalScrollIndicator:NO];
    [_categoriesCollectionView setShowsVerticalScrollIndicator:NO];
    _categoriesCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_categoriesCollectionView];
}

- (void)buildSearchWhiteBackground
{
    _searchResultsBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height)];
    _searchResultsBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchResultsBackground];
}

- (void)animateSearchViewIn
{
    [_searchResultsBackground setY:_searchTextFieldControlView.height + _searchTextFieldControlView.y + 5.0f];
    [UIView animateWithDuration:kCollectionViewAnimateTime delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_categoriesCollectionView setAlpha:0.0];
                     } completion:nil];
}

- (void)animateSearchViewOut
{
    [_searchResultsBackground setY:self.view.height];
    [UIView animateWithDuration:kCollectionViewAnimateTime delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_categoriesCollectionView setAlpha:1.0];
                     } completion:nil];
}

#pragma mark - init stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [KRColorHelper turquoise];
    
    _dataSource = @[
                    @"Cooking Time",
                    @"Pushups",
                    @"Category Name",
                    @"Mas Lolz",
                    @"Lol catz",
                    @"Dub Stepz"];
    
    [self buildSearchView];
    [self buildSearchWhiteBackground];
    [self buildCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [[KRHomeViewController current] closeNavigation];
//
//}
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uicollectionview delegate stuff

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KRCategoriesCollectionViewCell *cell = [_categoriesCollectionView dequeueReusableCellWithReuseIdentifier:KRCollectionCellReuseIdentifier forIndexPath:indexPath];
    cell.cellTitleLabel.text = [_dataSource objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}


#pragma mark - KRCategoriesCollectionViewCellDelegate delegate stuff
- (void)categorieCellHit:(KRCategoriesCollectionViewCell *)categoriesCollectionViewCell {
    KRListViewController *krlvc = [[KRListViewController alloc] initWithNibName:@"KRListViewController" bundle:nil];
    [self.navigationController pushViewController:krlvc animated:YES];
}


@end
























