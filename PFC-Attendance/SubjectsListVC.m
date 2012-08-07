//
//  ViewController.m
//  PFC-Attendance
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubjectsListVC.h"
#import "GDocsHelper.h"
#import "ConfigHelper.h"


@implementation SubjectsListVC
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

    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    
   
    
    //cogemos credenciales del ConfigHelper.
    
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    
    //si existen guardados animamos la rueda y mostramos el mensaje correspondiente.
    if (([configH.password length] != 0) && ([configH.user length] != 0)) {
        [self.activity startAnimating];
        [self.infoLbl setText:NSLocalizedString(@"CREDENTIALS", nil)];
        
        [midh credentialsWithUsr:configH.user andPwd:configH.password];
        [midh listadoAsignaturas];
        
    }
    else
    {
        //si no hay credenciales no hay rueda y mostramos el mensaje correspondiente.
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

    
    //tantas celdas como asignaturas tenga el usuario en googledocs con el prefijo AT_
    return [self.miListaAsignaturas count];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"tablalistar"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablalistar"];
    }
    
    //rellenamos las celdas con el nombre de la asignatura.
    cell.textLabel.text = [self.miListaAsignaturas objectAtIndex:indexPath.row];
    
    
    return cell;
} 

//implementacion protocolo
- (void)respuesta:(NSArray *)feed error:(NSError *)error
{
    //TODO: Controlar errores
    
    //error al conectar 
    //error user/pass
    //0 spreadsheets
    if (error) {
        
        switch (error.code) {
            case 403:
                NSLog(@"Error de login");
                break;
                
            case -1009:
                NSLog(@"Error de conexión");
                break;
                
            default:
                //Error desconocido. Poner el localized description del NSError
                
                break;
        }
        
    } else { //No ha habido error
        
        self.miListaAsignaturas = feed;
        [self.miTabla reloadData];
        //Cogemos el nombre de usuario de ConfigHelper para mostrar con que cuenta se esta conectando la aplicacion.
        
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        NSString *usr = configH.user;
        
        //mostramos mensaje "conectado a " y paramos la ruedita.
        self.infoLbl.text = [NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"CONNECTED_USR" value:@"" table:nil],usr];
        [self.activity stopAnimating];
        
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"goToConfig"])
    {
        
        //borramos la lista de asignaturas por si hay un cambio de usuario
        self.miListaAsignaturas = nil;
        [self.miTabla reloadData];
    }
}

@end
