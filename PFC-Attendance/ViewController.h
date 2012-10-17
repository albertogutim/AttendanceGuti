//
//  ViewController.h
//  pruebitaBuscador
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 16/10/12.
//  Copyright (c) 2012 ANA GUTIERREZ ESGUEVILLAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"

@interface ViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate, GDocsHelperDelegate>

{

    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    NSMutableDictionary *allItems;
    NSMutableDictionary *searchResults;
    NSArray *sortedKeys;
    NSArray *sortedKeysSearch;

}

@property (strong, nonatomic) IBOutlet UITableView *miTabla;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableDictionary *allItems;
@property (strong, nonatomic) NSMutableDictionary *searchResults;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *sortedKeysSearch;
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;

@end
