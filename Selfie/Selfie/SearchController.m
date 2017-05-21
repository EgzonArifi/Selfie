//
//  SearchController.m
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "SearchController.h"
#import "CandidateCell.h"
#import "CandidateModel.h"
#import "YCameraViewController.h"

@interface SearchController ()<UISearchBarDelegate>

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) UISearchBar *searchBar;
@property(strong, nonatomic) NSArray *candidates;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSearchBar];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CandidateCell" bundle:nil]
          forCellWithReuseIdentifier:@"CandidateCell"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}
- (instancetype)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    
    self = [storyboard instantiateViewControllerWithIdentifier:@"SearchController"];
    
    if(self) {
        
    }
    return  self;
}

#pragma mark - Search
- (void)addSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.5, 20)];
    self.searchBar.placeholder = NSLocalizedString(@"Kërko", nil);
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    UITextField *textField = [self.searchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [CandidateModel searchCandidate:searchText results:^(NSArray *candidatesArray) {
        self.candidates = candidatesArray;
        [self.collectionView reloadData];
    }];
}

#pragma mark - CollectionView Delegate and Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.candidates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CandidateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CandidateCell"
                                                                    forIndexPath:indexPath];
    [cell configureCell:self.candidates[indexPath.row]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 2.5, 5, 2.5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController presentViewController:[[YCameraViewController alloc] init]
                                            animated:YES
                                          completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width/2.1, self.collectionView.frame.size.width/2.1);
}

@end
