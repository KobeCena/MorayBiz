//
//  DetailViewControllerName.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "DetailViewControllerName.h"
#import "sqlite3.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "WebBrowserViewControllerName.h"
#import "MasterViewControllerName.h"

@implementation DetailViewControllerName

@synthesize detailTextView = _detailTextView;
@synthesize imageView;
@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;
#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    def = [NSUserDefaults standardUserDefaults];
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    [testArray addObject:@"TEST"];
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"NameChoiceDetail" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    }
        
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self configureView];
    }
    
    if (BusName == nil)
    {
        self.detailTextView.text = @"Please file a bug report from the AppStore if you see this error.";
    }
    else 
    {
        self.detailTextView.text = BusName;
    }
    
    if (BusImg == nil)
    {
        self.imageView.image = nil;  
    }
    else
    {
        NSURL *BusImgURL = [[NSURL alloc] initWithString:BusImg];
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:BusImgURL];
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        self.imageView.image = img;
    }
    [self setTitle:[def objectForKey:@"NameChoiceDetail"]];
    [navItem setTitle:[def objectForKey:@"NameChoiceDetail"]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [self loadMap];
    }
}

- (void)loadMap
{
    def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"finalURLNamePad"] == nil)
    {
        return;
    }
    else 
    {
    NSURL *finalURL = [[NSURL alloc] initWithString:[def objectForKey:@"finalURLNamePad"]];
    [webView loadRequest:[NSURLRequest requestWithURL:finalURL]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self refresh];
    [self loadMap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        myPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
}

- (IBAction)searchPressed:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
     if ([myPopover isPopoverVisible] == YES)
     {
        [myPopover dismissPopoverAnimated:YES];
     }
    
     else
     {
         [self performSegueWithIdentifier:@"popoverName" sender:self];
     }
    }
}

- (IBAction)detailsPressed:(id)sender {
    [self performSegueWithIdentifier:@"detailsPressedName" sender:self];
}

- (void)refresh
{
    [navItem setTitle:[def objectForKey:@"NameChoiceDetail"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"GLENNSDB.sqlite"];
    const char *dbpath = [filePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TBL_BUSINESS_DETAIL WHERE BUS_NAME = '%@'", [def objectForKey:@"NameChoiceDetail"]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                BusName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                BusImg = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                
                busTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                webURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                telNo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                busEmail = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                busAddr1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                busAddr2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(db);
    }
    if ([myPopover isPopoverVisible] == YES)
    {
        [myPopover dismissPopoverAnimated:YES];
    }
    self.detailTextView.text = BusName;
    if (busAddr1 == nil)
    {
        busAddr1 = @"No";
    }
    if (busAddr2 == nil)
    {
        busAddr2 = @"Address";
    }
    if (BusImg == nil)
    {
        self.imageView.image = nil;
    }
    else
    {
        NSURL *BusImgURL = [[NSURL alloc] initWithString:BusImg];
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:BusImgURL];
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        self.imageView.image = img;
    }
    [navItem setTitle:[def objectForKey:@"NameChoiceDetail"]];
    fullBusAddr = [[NSString alloc] initWithFormat:@"%@, %@", busAddr1, busAddr2];
    testArray = [[NSMutableArray alloc] initWithObjects:busTown, webURL, telNo, busEmail, nil];
    [tableView reloadData];
    NSString *googleCall = @"http://maps.google.com/maps?q=";
    NSString *fixedAddr = [fullBusAddr stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *fullString = [googleCall stringByAppendingString:fixedAddr];
    def = [NSUserDefaults standardUserDefaults];
    [def setObject:fullString forKey:@"finalURLNamePad"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)configureView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  
    
    NSString *defaultDBPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"GLENNSDB.sqlite"];
    const char *dbpath = [defaultDBPath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TBL_BUSINESS_DETAIL WHERE BUS_NAME = '%@';", [def objectForKey:@"NameChoiceDetail"]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                BusName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                BusImg = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                
            } 
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(db);
    }
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    tableView = nil;
    button = nil;
    navItem = nil;
    webView = nil;
    barButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return testArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCellStyle style =  UITableViewCellStyleDefault;
	cell = [tableViews dequeueReusableCellWithIdentifier:@"tableCell"];
    
	if (!cell) 
		cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"tableCell"];
    cell.textLabel.text = [testArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected = [testArray objectAtIndex:indexPath.row];
    
    if (selected == webURL)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selected]];
    }
    
    if (selected == telNo)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
        }
        
        else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            
        }
    }
    
    if (selected == busEmail)
    {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        
        if ([MFMailComposeViewController canSendMail] == YES)
        {
            mailVC.mailComposeDelegate = self;
            
            NSArray *toArray = [[NSArray alloc] initWithObjects:busEmail, nil];
            
            [mailVC setToRecipients:toArray];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                mailVC.modalPresentationStyle = UIModalPresentationPageSheet;
            }
            
            [self presentModalViewController:mailVC animated:YES];
        }
        else
        {
            lol1 = [[UIAlertView alloc] initWithTitle:@"Mail Failure" message:@"The device reports it cannot send Emails. Would you like to enter the Mail app?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [lol1 show];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if (title == @"Ok")
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", busEmail]]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultCancelled)
    {
        UIAlertView *lol = [[UIAlertView alloc] initWithTitle:@"Message Cancelled" message:@"The New Message has been cancelled." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [lol show];
        [self dismissModalViewControllerAnimated:YES];
    }
    if (result == MFMailComposeResultFailed)
    {
        UIAlertView *lol = [[UIAlertView alloc] initWithTitle:@"Message Failed" message:@"The New Message has failed to send." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [lol show];
        [self dismissModalViewControllerAnimated:YES];
    }
    if (result == MFMailComposeResultSaved)
    {
        UIAlertView *lol = [[UIAlertView alloc] initWithTitle:@"Message Saved" message:@"The New Message has been saved." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [lol show];
        [self dismissModalViewControllerAnimated:YES];
    }
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *lol = [[UIAlertView alloc] initWithTitle:@"Message Sent" message:@"The New Message has been sent." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [lol show];
        [self dismissModalViewControllerAnimated:YES];     
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
