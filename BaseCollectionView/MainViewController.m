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
    
    NSInteger rowCount = 5;
    
    for (int section = 0; section < sectionCount; section++) {
        
        NSMutableArray *innerArray = [[NSMutableArray alloc] init];
        
        for (int row = 0; row < rowCount; row++) {
            
            NSString *item = [NSString stringWithFormat:@"Section %d Item %d", section, row];
            [innerArray addObject:item];
        }
        
        [self.sectionsArray addObject:innerArray];
        
    }
    
}

- (void)setupCollectionView {
    
    // Set up cards
    [self.collectionView registerClass:[CardDeckCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    
    // Set up layout
    self.cardLayout = [[CardDeckLayout alloc] init];
    [self.cardLayout setItemSize:CGSizeMake(150.0f, 150.0f)];
    [self.cardLayout setCenterDelta:100];
    [self.cardLayout setRotationDelta:45];
    [self.collectionView setCollectionViewLayout:self.cardLayout];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    
    // Add pan handler to deal with touches
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

#pragma mark -
#pragma mark Interaction methods

-(void)didPan:(UIPanGestureRecognizer *)panRecognizer {
    
    // Handle touch events from the pan gesture recognizer
    
    CGPoint locationPoint = [panRecognizer locationInView:self.collectionView];
    
    // Deal with a new touch session
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
    
    // Handle an existing touch session to move the card
    if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.movingCellImage setCenter:locationPoint];
    }
    
    // Handle the end of the touch session
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {

        // Figure out where the card was 'dropped'
        NSInteger dropQuadrant = [self detectWhichQuadrantForDropCoordinates:locationPoint];
        
        // If it was dropped in the SAME quadrant, then pretend nothing ever happened
        NSIndexPath *originalIndexPath = [self.collectionView indexPathForCell:self.movingCell];
        
        if (dropQuadrant == originalIndexPath.section) {

            [self.movingCell setAlpha:1.0f];
            
        } else {
            
            // Move the dropped cell to the appropriate pile
            [self moveCellAtIndexPath:[self.collectionView indexPathForCell:self.movingCell] toQuadrant:dropQuadrant];
            
            // Clear the reference to the selected cell
            self.movingCell = nil;
            
        }
        
        // Remove the fake cell
        [self.movingCellImage removeFromSuperview];
        
    }
}

#pragma mark -
#pragma mark Movement methods

-(NSInteger)detectWhichQuadrantForDropCoordinates:(CGPoint)drop {
    
    float xBoundary = self.collectionView.bounds.size.width / 2;
    float yBoundary = self.collectionView.bounds.size.height / 2;
    
    CGRect topLeft = CGRectMake(0, 0, xBoundary, yBoundary);
    CGRect topRight = CGRectMake(xBoundary, 0, xBoundary, yBoundary);
    CGRect bottomLeft = CGRectMake(0, yBoundary, xBoundary, yBoundary);
    CGRect bottomRight = CGRectMake(xBoundary, yBoundary, xBoundary, yBoundary);
    
    if (CGRectContainsPoint(topLeft, drop)) {
        return 0;
    }
    
    if (CGRectContainsPoint(topRight, drop)) {
        return 1;
    }
    
    if (CGRectContainsPoint(bottomLeft, drop)) {
        return 2;
    }
    
    if (CGRectContainsPoint(bottomRight, drop)) {
        return 3;
    }
    
    return 4;
    
}

-(void)moveCellAtIndexPath:(NSIndexPath *)oldIndexPath toQuadrant:(NSInteger)quadrant {
    
    // Create new index path
    // Get current count of items in the recipient array
    NSMutableArray *recipientArray = [self.sectionsArray objectAtIndex:quadrant];
    NSInteger currentCount = [recipientArray count];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:currentCount inSection:quadrant];
    
    // Retrieve original item
    NSMutableArray *donorArray = [self.sectionsArray objectAtIndex:oldIndexPath.section];
    id itemToMove = [donorArray objectAtIndex:oldIndexPath.row];
    
    // Add itemToMove to the correct inner array
    [recipientArray addObject:itemToMove];
    
    // Remove original item from the donor array
    [donorArray removeObject:itemToMove];
    
    // Tell the layout which indexPath has been removed,
    // so it won't get returned
    [self.cardLayout setIndexPathOfUpdatedCard:oldIndexPath];
    
    [self.collectionView performBatchUpdates:^{
        
        [self.collectionView deleteItemsAtIndexPaths:@[oldIndexPath]];
        [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
        
    } completion:^(BOOL finished) {
        //
    }];

}

@end
