//
//  BusDetailsViewControllerName.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/05/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "BusDetailsViewControllerName.h"
#import "sqlite3.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface BusDetailsViewControllerName ()

@end

@implementation BusDetailsViewControllerName
@synthesize navItem;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    def = [NSUserDefaults standardUserDefaults];
    [self setNavItem:navItem];
    [self initializeBusData];
    [navItem setTitle:busTown];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)initializeBusData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"GLENNSDB.sqlite"];
    const char *dbpath = [filePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TBL_BUSINESS_DETAIL WHERE BUS_NAME = '%@';", [def objectForKey:@"NameChoiceDetail"]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
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
    fullBusAddr = [[NSString alloc] initWithFormat:@"%@, %@", busAddr1, busAddr2];
    testArray = [[NSMutableArray alloc] initWithObjects:busTown, webURL, telNo, busEmail, fullBusAddr, nil];
    [tableView reloadData];
}
- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        [def setObject:selected forKey:@"webStringName"];
        [self performSegueWithIdentifier:@"webModalName" sender:self];
    }
    
    if (selected == telNo)
    {
        NSString *kk = [telNo stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", kk]]];
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
    
    if (selected == fullBusAddr)
    {
        NSString *plusString = [fullBusAddr stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *googleCall = @"http://maps.google.com/maps?q=";
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[googleCall stringByAppendingString:plusString]]];
        NSString *finalString = [googleCall stringByAppendingString:plusString];
        def = [NSUserDefaults standardUserDefaults];
        [def setObject:finalString forKey:@"finalStringName"];
        [self performSegueWithIdentifier:@"mapsModalName" sender:self];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *selected = [alertView buttonTitleAtIndex:buttonIndex];
    if (selected == @"Ok")
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
@end
