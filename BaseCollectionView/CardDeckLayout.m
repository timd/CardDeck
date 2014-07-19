//
//  CardDeckLayout.m
//  CardDeck
//
//  Created by Tim on 18/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CardDeckLayout.h"

@interface CardDeckLayout ()
@property (nonatomic, strong) NSMutableArray *attributesArray;
@property (nonatomic, strong) NSMutableArray *previousAttributesArray;
@end

@implementation CardDeckLayout

-(instancetype)init {
    if (self = [super init]) {
        self.attributesArray = [[NSMutableArray alloc] init];
        self.previousAttributesArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)prepareLayout {

    // Clear out any old attributes, then make a copy of any
    // preexisting ones
    [self.previousAttributesArray removeAllObjects];
    [self.previousAttributesArray addObjectsFromArray:self.attributesArray];
    [self.attributesArray removeAllObjects];
    
    // Prepare stuff
    NSInteger numberOfSections = [self.collectionView numberOfSections];

    // Prepare coordinates for the section centers
    float leftCentreX = self.collectionView.bounds.size.width / 4;
    float rightCentreX = leftCentreX * 3;
    float topCentreY = self.collectionView.bounds.size.height / 4;
    float bottomCenterY = topCentreY * 3;
    
    CGPoint topLeft = CGPointMake(leftCentreX, topCentreY);
    CGPoint topRight = CGPointMake(rightCentreX, topCentreY);
    CGPoint bottomLeft = CGPointMake(leftCentreX, bottomCenterY);
    CGPoint bottomRight = CGPointMake(rightCentreX, bottomCenterY);
    
    // Work through the sections and create attributes for each element
    for (int section = 0; section < numberOfSections; section++) {
        
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        
        for (int itemCount = 0; itemCount < numberOfItemsInSection; itemCount++) {
            
            UICollectionViewLayoutAttributes *attributes = nil;
            NSIndexPath *indexPathForItem = [NSIndexPath indexPathForItem:itemCount inSection:section];
            
            // Check if there are existing center and rotation attributes for this item,
            // and use these preexisting ones if they already exist
            NSInteger indexOfMatchingAttributes = [self.previousAttributesArray indexOfObjectPassingTest:^BOOL(UICollectionViewLayoutAttributes *attrs, NSUInteger idx, BOOL *stop) {
                NSComparisonResult comparison = [attrs.indexPath compare:indexPathForItem];
                return (comparison == NSOrderedSame);
            }];
            
            if (indexOfMatchingAttributes == NSNotFound) {

                // There aren't any prexisting attributes, so we need to
                // calculate them from scratch
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPathForItem];
                
                // now calculate center
                switch (indexPathForItem.section) {
                    case 0:
                        attributes.center = [self offsetCenterFromOriginal:topLeft];
                        break;
                        
                    case 1:
                        attributes.center = [self offsetCenterFromOriginal:topRight];
                        break;
                        
                    case 2:
                        attributes.center = [self offsetCenterFromOriginal:bottomLeft];
                        break;
                        
                    case 3:
                        attributes.center = [self offsetCenterFromOriginal:bottomRight];
                        break;
                        
                    default:
                        break;
                }
                
                // Calculate rotation
                attributes.transform3D = CATransform3DMakeRotation([self rotationAngle], 0.0, 0.0, 1.0);
                
                // Set zIndex
                attributes.zIndex = itemCount;
                
                // set item size
                attributes.size = self.itemSize;

            } else {
                
                // Can recycle the existing ones!
                attributes = [self.previousAttributesArray objectAtIndex:indexOfMatchingAttributes];
                
            }
            
            [self.attributesArray addObject:attributes];
            
        }
    }
    
}

-(CGSize)collectionViewContentSize {
    // Content size is the same as the collection view
    return self.collectionView.frame.size;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // Return all attributes, as all elements are visible
    // because the collection view doesn't scroll
    return self.attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Find and return the attributes object with the corresponding indexPath
    NSInteger index = [self.attributesArray indexOfObjectPassingTest:^BOOL(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        NSComparisonResult comparisonResult = [attributes.indexPath compare:indexPath];
        return (comparisonResult == NSOrderedSame);
    }];
    
    return [self.attributesArray objectAtIndex:index];
}

-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
}

#pragma mark -
#pragma mark Centering methods

-(CGPoint)offsetCenterFromOriginal:(CGPoint)originalCenter {
    
    float originalX = originalCenter.x;
    float originalY = originalCenter.y;
    
    float newX;
    float newY;
    
    // Calculate jitter for X
    int posOrNeg = arc4random() % 1;
    
    if (posOrNeg == 1) {
        newX = originalX + (arc4random() % self.centerDelta);
    } else {
        newX = originalX - (arc4random() % self.centerDelta);
    }

    // Calculate jitter for Y
    posOrNeg = arc4random() % 1;
    
    if (posOrNeg == 1) {
        newY = originalY + (arc4random() % self.centerDelta);
    } else {
        newY = originalY - (arc4random() % self.centerDelta);
    }

    return CGPointMake(newX, newY);
    
}

-(float)rotationAngle {
    
    // Calculate jitter for Y
    int posOrNeg = arc4random() % 2;
    
    float rotationAngle = 0.0f;

    int randomFactor = (arc4random() % self.rotationDelta);
    
    if (posOrNeg == 1) {
        rotationAngle = randomFactor;
    } else {
        rotationAngle = -randomFactor;
    }
    
    return rotationAngle / 180.0f;
    
}

@end
