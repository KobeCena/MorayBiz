//
//  MasterViewControllerCategory.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "MasterViewControllerCategory.h"
#import "sqlite3.h"

@implementation MasterViewControllerCategory

@synthesize navBar;
@synthesize detailViewController = _detailViewController;
@synthesize arrayCategory;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    def = [NSUserDefaults standardUserDefaults];
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    arrayCategory = [[NSMutableArray alloc] init];
    CatSet = [[NSMutableSet alloc] init];
    [self initializeBusData];
    [arrayCategory setArray:[CatSet allObjects]];
    sortedArray = [arrayCategory sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

}


- (void)initializeBusData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  
    
    NSString *defaultDBPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"GLENNSDB.sqlite"];    
    const char *dbpath = [defaultDBPath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM TBL_BUSINESS_MAIN";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *BusCategory = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];

                [CatSet addObject:BusCategory];
                
            } 
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }
}


- (void)viewDidUnload
{
    [self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sortedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCellStyle style =  UITableViewCellStyleDefault;
	cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
	if (!cell) 
		cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"tableCell"];
    cell.textLabel.textColor = [UIColor whiteColor];
    [[cell textLabel] setText:[sortedArray objectAtIndex:indexPath.row]];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [def setObject:[sortedArray objectAtIndex:indexPath.row] forKey:@"CategoryChoice"];
    [self performSegueWithIdentifier:@"CategoryFirstPush" sender:self];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
