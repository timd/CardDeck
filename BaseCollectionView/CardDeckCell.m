//
//  BaseCollectionViewCell.m
//  BaseCollectionView
//
//  Created by Tim on 16/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CardDeckCell.h"

@interface CardDeckCell ()
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@end

@implementation CardDeckCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CardDeckCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
}

-(void)prepareForReuse {
    [self.contentLabel setText:self.contentString];
}

@end
