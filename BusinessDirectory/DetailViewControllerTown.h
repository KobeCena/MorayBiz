//
//  DetailViewControllerTown.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "WebBrowserViewControllerTown.h"

@interface DetailViewControllerTown : UIViewController <UISplitViewControllerDelegate, UIPopoverControllerDelegate, NSFileManagerDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UIWebViewDelegate, UISplitViewControllerDelegate>
{
    __weak IBOutlet UIWebView *webView;
    sqlite3 *db;
    NSUserDefaults *def;
    NSString *BusName;
    NSString *BusImg;
    UITableViewCell *cell;
    NSMutableArray *testArray;
    NSString *busTown;
    NSString *webURL;
    NSString *busEmail;
    __weak IBOutlet UITableView *tableView;
    NSString *telNo;
    UIPopoverController *myPopover;
    WebBrowserViewControllerTown *modalWeb;
    UIAlertView *lol1;
    NSString *busAddr1;
    NSString *busAddr2;
    NSString *fullBusAddr;
    NSString *connection;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
- (void)refresh;
@end