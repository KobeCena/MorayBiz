//
//  DetailViewControllerName.h
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface DetailViewControllerName : UIViewController <UISplitViewControllerDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate>
{
    __weak IBOutlet UIBarButtonItem *barButton;
    __weak IBOutlet UIWebView *webView;
    __weak IBOutlet UINavigationItem *navItem;
    sqlite3 *db;
    NSUserDefaults *def;
    __weak IBOutlet UIButton *button;
    NSString *BusName;
    NSString *BusImg;
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UIScrollView *scrollView;
    NSMutableArray *testArray;
    UITableViewCell *cell;
    NSString *BusAd1;
    NSString *BusAd2;
    NSString *BusAd3;
    NSString *telNo;
    NSString *webURL;
    NSString *busEmail;
    NSString *business;
    NSString *busTown;
    UIPopoverController *myPopover;
    UIAlertView *lol1;
    NSString *busAddr1;
    NSString *busAddr2;
    NSString *fullBusAddr;
}
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
- (void)refresh;

@end