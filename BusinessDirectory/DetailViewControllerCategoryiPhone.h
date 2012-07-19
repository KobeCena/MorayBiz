//
//  DetailViewControllerCategory.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface DetailViewControllerCategoryiPhone : UIViewController <UISplitViewControllerDelegate, UIPopoverControllerDelegate, NSFileManagerDelegate>
{
    sqlite3 *db;
    NSUserDefaults *def;
    NSString *BusName;
    NSString *BusImg;
}
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
- (void)configureView;
@end