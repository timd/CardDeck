//
//  CardDeckLayout.h
//  CardDeck
//
//  Created by Tim on 18/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDeckLayout : UICollectionViewLayout

@property (nonatomic) CGSize itemSize;
@property (nonatomic) int centerDelta;
@property (nonatomic) int rotationDelta;
@property (nonatomic) NSIndexPath *indexPathOfUpdatedCard;
@end                                           
