//
//  SplashViewController.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 10/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "SplashViewController.h"
#import "sqlite3.h"


@implementation SplashViewController
@synthesize DetailText;



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (IBAction)download:(id)sender {
    NSString *stringURL = @"http://gizmoloon.com/busdirdb/BUSDIR.sqlite";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];  
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"GLENNSDB.sqlite"];
        [urlData writeToFile:filePath atomically:YES];
    }
    UIAlertView *lol2 = [[UIAlertView alloc] initWithTitle:@"Download Complete" message:@"The latest version of the database has been downloaded." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [lol2 show];
    advance.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"GLENNSDB.sqlite"];
    NSFileManager *fileMana = [[NSFileManager alloc] init];
    
    if ([fileMana fileExistsAtPath:filePath] == NO)
    {
        UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"No Directory Detected" message:@"The device reports it requires the directory to be download. Please tap Update the Directory." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [aView show];
    }
    NSString *lol1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://gizmoloon.com"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    if (lol1.length == 0)
    {
        lol = [[UIAlertView alloc] initWithTitle:@"Offline Mode" message:@"The device currently has no internet connection. Images will not be loaded." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [lol show];
        download.enabled = NO;
    }
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

- (void)viewDidUnload
{
    [self setDetailText:nil];
    advance = nil;
    download = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
