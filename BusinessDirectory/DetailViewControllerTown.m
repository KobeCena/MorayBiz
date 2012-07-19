//
//  DetailViewControllerTown.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "DetailViewControllerTown.h"
#import "sqlite3.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "WebBrowserViewControllerTown.h"

@implementation DetailViewControllerTown

@synthesize detailTextView = _detailTextView;
@synthesize imageView;
@synthesize navItem, detailDescriptionLabel;
#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    def = [NSUserDefaults standardUserDefaults];
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [self refresh];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"TownChoiceDetail" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self configureView];
    }
    
    self.detailTextView.text = BusName;
    
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
    if (webURL == nil)
    {
        webURL = @"(null)";
    }
    [navItem setTitle:[def objectForKey:@"TownChoiceDetail"]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
    [self loadMap];
    }
}

- (void)loadMap
{
    def = [NSUserDefaults standardUserDefaults];
    NSURL *finalURL = [[NSURL alloc] initWithString:[def objectForKey:@"finalURLTownPad"]];
    [webView loadRequest:[NSURLRequest requestWithURL:finalURL]];
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
        if ([segue.identifier isEqualToString:@"padModalWeb"])
        {
         modalWeb = [(UIStoryboardSegue *)segue destinationViewController];
        }
        else
        {
         myPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        }
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
            [self performSegueWithIdentifier:@"popoverTown" sender:sender];
        }
    }
}

- (IBAction)detailsPressed:(id)sender {
    [self performSegueWithIdentifier:@"detailsPressedTown" sender:self];
}


- (void)refresh
{
    [navItem setTitle:[def objectForKey:@"TownChoiceDetail"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"GLENNSDB.sqlite"];
    const char *dbpath = [filePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TBL_BUSINESS_DETAIL WHERE BUS_NAME = '%@';", [def objectForKey:@"TownChoiceDetail"]];
        
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
    [navItem setTitle:[def objectForKey:@"TownChoiceDetail"]];
    fullBusAddr = [[NSString alloc] initWithFormat:@"%@, %@", busAddr1, busAddr2];
    testArray = [[NSMutableArray alloc] initWithObjects:busTown, webURL, telNo, busEmail, nil];
    [tableView reloadData];
    NSString *googleCall = @"http://maps.google.com/maps?q=";
    NSString *fixedAddr = [fullBusAddr stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *fullString = [googleCall stringByAppendingString:fixedAddr];
    [def setObject:fullString forKey:@"finalURLTownPad"];
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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TBL_BUSINESS_DETAIL WHERE BUS_NAME = '%@';", [def objectForKey:@"TownChoiceDetail"]];
        
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
    navItem = nil;
    webView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
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
        def = [NSUserDefaults standardUserDefaults];
        [def setObject:webURL forKey:@"webStringTown"];
        [self performSegueWithIdentifier:@"padModalWeb" sender:self];
       // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selected]];
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

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    
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
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
