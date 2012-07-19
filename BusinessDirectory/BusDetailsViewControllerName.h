//
//  BusDetailsViewControllerName.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/05/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface BusDetailsViewControllerName : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSMutableArray *testArray;
    UITableViewCell *cell;
    sqlite3 *db;
    NSUserDefaults *def;
    NSString *busTown;
    NSString *webURL;
    NSString *busEmail;
    NSString *telNo;
    NSString *busAddr1;
    NSString *busAddr2;
    NSString *busAddr3;
    UIAlertView *lol1;
    NSString *fullBusAddr;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
