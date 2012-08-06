//
//  ViewController.m
//  PFC-Attendance
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GDocsHelper.h"
#import "KeychainItemWrapper.h"


@implementation ViewController
@synthesize miVistaTunning = _miVistaTunning;
@synthesize infoLbl = _infoLbl;
@synthesize activity = _activity;
@synthesize listaTableView = _listaTableView;
@synthesize miListaAsignaturas = _miListaAsignaturas;
@synthesize miTabla = _miTabla;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Cargamos un NIB con la jerarquía de vistas para el custom ButtonItem
    [[NSBundle mainBundle] loadNibNamed:@"vistaConexion" owner:self options:nil];
    self.title = NSLocalizedString(@"SUBJECTS_TITLE", nil);
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    [midh mifetch];
    
    
}


- (void)viewDidUnload
{
    [self setMiVistaTunning:nil];
    [self setInfoLbl:nil];
    [self setActivity:nil];
    [self setListaTableView:nil];
    [self setMiListaAsignaturas:nil];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
        
    [super viewWillAppear:animated];
    
    __weak NSArray *elementosToolbar = [self toolbarItems];
    
    UIBarButtonItem *botonTunning = [[UIBarButtonItem alloc] initWithCustomView:self.miVistaTunning];
    NSMutableArray *nuevosElementos = [NSMutableArray arrayWithCapacity:elementosToolbar.count+1];
    [nuevosElementos addObjectsFromArray:elementosToolbar];
    [nuevosElementos insertObject:botonTunning atIndex:1];
    [self setToolbarItems:nuevosElementos animated:YES];

    //TODO: coger credenciales del ConfigHelper.
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppPassword" accessGroup:nil];
    NSString *password = [keychainItem objectForKey:(__bridge id)kSecValueData];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    
    if (([password length] != 0) && ([username length] != 0)) {
        [self.activity startAnimating];
        [self.infoLbl setText:NSLocalizedString(@"CREDENTIALS", nil)];
        
    }
    else
    {
        //Aqui hay que comprobar antes que no haya credenciales sin guardar al hacer el back.
        [self.activity stopAnimating];
        [self.infoLbl setText:NSLocalizedString(@"NO_CREDENTIALS", nil)];
    }
    
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
     return 1;
 }
 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return [self.miListaAsignaturas count];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"tablalistar"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablalistar"];
    }
    
    cell.textLabel.text = [self.miListaAsignaturas objectAtIndex:indexPath.row];
    
    
    return cell;
} 

//implementacion protocolo
- (void)respuesta:(NSArray *)feed
{
    //TODO: Controlar errores
    self.miListaAsignaturas = feed;
    [self.miTabla reloadData];
    //TODO:Coger el nombre de usuario de ConfigHelper
    NSString *usr = @"Ana";
    self.infoLbl.text = [NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"CONNECTED_USR" value:@"" table:nil],usr];
    [self.activity stopAnimating];
}


@end
