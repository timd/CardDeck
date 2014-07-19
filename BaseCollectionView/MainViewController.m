//
//  ViewController.m
//  BaseCollectionView
//
//  Created by Tim on 16/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "CardDeckCell.h"
#import "CollectionViewFlowLayout.h"
#import "CardDeckLayout.h"

@interface MainViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) CollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) CardDeckLayout *cardLayout;
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
    
    NSInteger sectionCount = 4;
    self.sectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionCount];
    
    NSInteger rowCount = 25;
    
    for (int section = 0; section < sectionCount; section++) {
        
        NSMutableArray *innerArray = [[NSMutableArray alloc] initWithCapacity:rowCount];
        
        for (int row = 0; row < rowCount; row++) {
            
            NSString *item = [NSString stringWithFormat:@"Section %d Item %d", section, row];
            [innerArray addObject:item];
        }
        
        [self.sectionsArray addObject:innerArray];
        
    }
    
}

- (void)setupCollectionView {
    [self.collectionView registerClass:[CardDeckCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    
    self.cardLayout = [[CardDeckLayout alloc] init];
    [self.cardLayout setItemSize:CGSizeMake(150.0f, 150.0f)];
    [self.cardLayout setCenterDelta:100];
    [self.cardLayout setRotationDelta:45];
    [self.collectionView setCollectionViewLayout:self.cardLayout];
    
//    self.flowLayout = [[CollectionViewFlowLayout alloc] init];
//    [self.flowLayout setItemSize:CGSizeMake(100.0f, 100.0f)];
//    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
}

#pragma mark - UICollectionView methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sectionsArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSMutableArray *innerArray = [self.sectionsArray objectAtIndex:section];
    return [innerArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardDeckCell *cell = (CardDeckCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    NSMutableArray *innerArray = [self.sectionsArray objectAtIndex:indexPath.section];
    
    cell.contentString = [innerArray objectAtIndex:indexPath.row];
    
    [cell prepareForReuse];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardDeckCell *cell = (CardDeckCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor redColor]];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardDeckCell *cell = (CardDeckCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor blueColor]];
}

@end
