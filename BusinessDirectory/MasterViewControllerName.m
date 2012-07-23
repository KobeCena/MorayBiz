//
//  MasterViewControllerCategory.m
//  BusinessDirectory
//
//  Created by Glenn Forbes on 08/04/2012.
//  Copyright (c) 2012 Moray.IT. All rights reserved.
//

#import "MasterViewControllerName.h"
#import "sqlite3.h"

@implementation MasterViewControllerName

@synthesize detailViewController = _detailViewController;

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
    arrayTown = [[NSMutableArray alloc] init];
    TownSet = [[NSMutableSet alloc] init];
    [self initializeBusData];
    [arrayTown setArray:[TownSet allObjects]];
    sortedArray = [arrayTown sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.tableView.tableHeaderView = searchBar;
    searchDis = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    [searchDis setSearchResultsDataSource:self];
    [searchDis setDelegate:self];
    
    self.searchResults = sortedArray;
    
    alphabet = [[NSMutableArray alloc] init];
 //   [alphabet addObject:@"{search}"];
    for (int i=0; i<[sortedArray count]-1; i++)
    {
        char alphabetUni = [[sortedArray objectAtIndex:i] characterAtIndex:0];
        NSString *uniChar = [NSString stringWithFormat:@"%c", alphabetUni];
        if (![alphabet containsObject:uniChar])
        {
            [alphabet addObject:uniChar];
        }
    }
}


#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self.searchDisplayController.searchBar setDelegate:self];
    
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [searchDis.searchResultsTableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, 44.f) animated:YES];
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
        NSString *querySQL = @"SELECT * FROM TBL_BUSINESS_MAIN";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *BusTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                [TownSet addObject:BusTown];
                
            } 
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(db);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [alphabet count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    NSString *alpha = [alphabet objectAtIndex:section];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alpha];
    businesses = [sortedArray filteredArrayUsingPredicate:predicate];
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResults count];
    }
    else {
        rows = [businesses count];
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [alphabet objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *alpha = [alphabet objectAtIndex:indexPath.section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alpha];
    businesses = [sortedArray filteredArrayUsingPredicate:predicate];
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.textLabel.text =
        [self.searchResults objectAtIndex:indexPath.row];
    }
    else{
            NSString *cellValue = [businesses objectAtIndex:indexPath.row];
            cell.textLabel.text = cellValue;
    }
    
 //   NSString *cellValue = [alphabet objectAtIndex:indexPath.row];
 //   cell.textLabel.text = cellValue;
    
    return cell;
    
    searchDis.delegate = self;
    searchDis.searchResultsDelegate = self;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return alphabet;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [alphabet indexOfObject:title];
}

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    searchText = searchDis.searchBar.text;
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", searchText];
    
    self.searchResults = [sortedArray filteredArrayUsingPredicate:resultPredicate];
    filteredData = self.searchResults;
    searchDis.delegate = self;
    searchDis.searchResultsDelegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    searchDis.delegate = self;
    searchDis.searchResultsDelegate = self;
    searchDis.searchResultsDataSource = self;
    
    NSString *selected = nil;
    
    NSString *alpha = [alphabet objectAtIndex:indexPath.section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alpha];
    businesses = [sortedArray filteredArrayUsingPredicate:predicate];
    
    if (tableView == self.tableView)
    {
        selected = [businesses objectAtIndex:indexPath.row];
    }
    else if (tableView == searchDis.searchResultsTableView)
    {
        selected = [filteredData objectAtIndex:indexPath.row];
    }
    
    [def setObject:selected forKey:@"NameChoiceDetail"];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self performSegueWithIdentifier:@"NameDetailPush" sender:self];

    }
}
- (void)viewDidUnload
{
    searchBar = nil;
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



@end
