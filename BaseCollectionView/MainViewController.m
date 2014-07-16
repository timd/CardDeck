//
//  ViewController.m
//  BaseCollectionView
//
//  Created by Tim on 16/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "BaseCollectionViewCell.h"
#import "CollectionViewFlowLayout.h"

@interface MainViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) CollectionViewFlowLayout *flowLayout;
@end

@implementation MainViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupData];
    
    [self setupCollectionView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Setup methods

- (void)setupData {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:50];
    for (int count = 0; count < 50; count++) {
        [tempArray addObject:[NSString stringWithFormat:@"Item %d", count]];
    }
    
    self.dataArray = tempArray;
}

- (void)setupCollectionView {
    [self.collectionView registerClass:[BaseCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    
    self.flowLayout = [[CollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(100.0f, 100.0f)];
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
}

#pragma mark - UICollectionView methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = (BaseCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    cell.contentString = [self.dataArray objectAtIndex:indexPath.row];
    [cell prepareForReuse];
    
    return cell;
}

@end
