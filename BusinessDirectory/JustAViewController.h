//
//  JustAViewController.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 17/07/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JustAViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *mainArray;
    __weak IBOutlet UICollectionView *collectionView;
}

@end
