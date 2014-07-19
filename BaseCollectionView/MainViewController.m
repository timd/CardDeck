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
@property (nonatomic, strong) CardDeckLayout *cardLayout;

@property (nonatomic, strong) CardDeckCell *movingCell;
@property (nonatomic, strong) UIImageView *movingCellImage;
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
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.collectionView addGestureRecognizer:panRecognizer];
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
    
    [cell.layer setCornerRadius:10.0f];
    [cell.layer setBorderWidth:3.0f];
    [cell.layer setBorderColor:[UIColor blueColor].CGColor];
    
    return cell;
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    CardDeckCell *cell = (CardDeckCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell.layer setBorderColor:[UIColor redColor].CGColor];
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    CardDeckCell *cell = (CardDeckCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell.layer setBorderColor:[UIColor blueColor].CGColor];
//}

-(void)didPan:(UIPanGestureRecognizer *)panRecognizer {
    
    CGPoint locationPoint = [panRecognizer locationInView:self.collectionView];
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // Get a reference to the cell that's being "moved"
        NSIndexPath *indexPathOfMovingCell = [self.collectionView indexPathForItemAtPoint:locationPoint];
        self.movingCell = (CardDeckCell *)[self.collectionView cellForItemAtIndexPath:indexPathOfMovingCell];
        
        // Get current rotation from the layout
        CATransform3D transform = self.movingCell.layer.transform;

        // Create image representation of the cell
        UIGraphicsBeginImageContext(self.movingCell.bounds.size);
        [self.movingCell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Create an imageView to hold the image
        self.movingCellImage = [[UIImageView alloc] initWithImage:cellImage];
        [self.movingCellImage setCenter:locationPoint];
        [self.movingCellImage setAlpha:0.75f];
        
        // Rotate it so that it matches the cell
        self.movingCellImage.layer.transform = transform;
        
        // Hide the cell that's being moved
        [self.movingCell setAlpha:0.0f];
        
        // Add the fake cell to the collection view
        [self.collectionView addSubview:self.movingCellImage];
        
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.movingCellImage setCenter:locationPoint];
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {

        // Make the cell reappear
        [self.movingCell setAlpha:1.0f];
        
        // Remove the fake cell
        [self.movingCellImage removeFromSuperview];
        
        // Clear the reference to the selected cell
        self.movingCell = nil;
    }
}


@end
