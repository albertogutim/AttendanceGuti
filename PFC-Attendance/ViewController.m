//
//  ViewController.m
//  pruebitaBuscador
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 16/10/12.
//  Copyright (c) 2012 ANA GUTIERREZ ESGUEVILLAS. All rights reserved.
//

#import "ViewController.h"
#import "GDocsHelper.h"
#import "ConfigHelper.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController


@synthesize miTabla;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize allItems;
@synthesize searchResults;
@synthesize sortedKeys;
@synthesize sortedKeysSearch;

- (void)viewDidLoad
{
    NSArray *alum = [[NSArray alloc] initWithObjects:@"Ana Gutierrez Esguevillas", @"Raquel Gutierrez Esguevillas", @"Aday Perera Rodriguez", @"Raul Suarez Rodriguez", @"Berta Galvan", @"Ana Rios Cabrera", @"Isabel Mayor Guerra", nil];
    
    NSArray *est = [[NSArray alloc] initWithObjects:@"3", @"3",
                    @"2", @"2", @"1", @"1", @"3", nil];
    
    NSMutableDictionary *prueba = [NSDictionary dictionaryWithObjects:est forKeys:alum];
    
    self.allItems=prueba;
    
    NSArray * sortedKeys2 = [[self.allItems allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    self.sortedKeys = sortedKeys2;
    [self.miTabla reloadData];
    
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 105, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    UIBarButtonItem* pasarAsistenciaButton = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pasarAsistenciaButtonAction)];
    pasarAsistenciaButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:pasarAsistenciaButton];
    
    
    
    UIBarButtonItem* mailButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(mailButtonAction)];
    mailButton.style = UIBarButtonItemStyleBordered;
    
    [buttons addObject:mailButton];
    
    
    // stick the buttons in the toolbar
    [tools setItems:buttons animated:NO];
    
    
    
    // and put the toolbar in the nav bar
    
    UIBarButtonItem* rightButtonBar = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = rightButtonBar;
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}





- (void)viewDidUnload
{
    [self setMiTabla:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.searchResults count];
    }
	else
	{
        return [self.allItems count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
               
        theCellLbl.text =[self.sortedKeysSearch objectAtIndex:indexPath.row];
    }
	else
	{
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
            
        theCellLbl.text =[self.sortedKeys objectAtIndex:indexPath.row];
    }
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView != self.searchDisplayController.searchResultsTableView)
    {
        return @"tableview";
    }
    else
        return @"tableViewSearchdisplay";
    
    
}


-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
   
    NSArray *temp;
    NSMutableArray *temp2 = [NSMutableArray arrayWithCapacity:[self.allItems count]];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    [self.searchResults removeAllObjects];
    
    //en temp guardo un array con los nombres filtrados
    temp = [self.allItems.allKeys filteredArrayUsingPredicate:resultPredicate];
    for (int i=0; i<[temp count]; i++) {
        [temp2 addObject:[self.allItems valueForKey:[temp objectAtIndex:i]]];
        //en temp2 guardo los estados para esos nombres filtrados
    }
    
    //en temp3 me construyo en dictionary con los arrays temp y temp2
    NSMutableDictionary *temp3 = [NSMutableDictionary dictionaryWithObjects:temp2 forKeys:temp];
    
    self.searchResults = temp3;
    
    NSArray * sortedKeysSearch2 = [[self.searchResults allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    self.sortedKeysSearch = sortedKeysSearch2;
    
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
    
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:searchOption]];
    
    return YES;
    
}



@end
