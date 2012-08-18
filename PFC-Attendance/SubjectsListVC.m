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
@synthesize asignatura = _asignatura;

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
    __weak NSArray *elementosToolbar = [self toolbarItems];
    
    UIBarButtonItem *botonTunning = [[UIBarButtonItem alloc] initWithCustomView:self.miVistaTunning];
    NSMutableArray *nuevosElementos = [NSMutableArray arrayWithCapacity:elementosToolbar.count+1];
    [nuevosElementos addObjectsFromArray:elementosToolbar];
    [nuevosElementos insertObject:botonTunning atIndex:1];
    [self setToolbarItems:nuevosElementos animated:YES];
    
}


- (void)viewDidUnload
{
    [self setMiVistaTunning:nil];
    [self setInfoLbl:nil];
    [self setActivity:nil];
    [self setListaTableView:nil];
    [self setMiListaAsignaturas:nil];
    [self setAsignatura:nil];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
        
    [super viewWillAppear:animated];
    
    [self connectIntent];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
   // NSLog(@"%@",[self.asignatura description]);
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
    cell.textLabel.text = [self.miListaAsignaturas.allValues objectAtIndex:indexPath.row];
    
    
    return cell;
} 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //guardamos en asignatura el identificador de la asignatura que se ha seleccionado de la tabla

    
    self.asignatura= [self.miListaAsignaturas.allKeys objectAtIndex:indexPath.row];
    
    /*UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"SubjectsView"
                                                         message:[NSString stringWithFormat:@"asignatura: %@", self.asignatura]
                                                        delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
    
    [alertView show];*/
    [self performSegueWithIdentifier:@"goToWorksheetsView" sender:self];

}


#pragma mark - My methods

-(void)connectIntent {
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    
    
    
    //cogemos credenciales del ConfigHelper.
    
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    
    //si existen guardados animamos la rueda y mostramos el mensaje correspondiente.
    if (([configH.password length] != 0) && ([configH.user length] != 0)) {
        [self.activity startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self.infoLbl setText:NSLocalizedString(@"CREDENTIALS", nil)];
        
        [midh credentialsWithUsr:configH.user andPwd:configH.password];
        [midh listadoAsignaturas];
        
    }
    else
    {
        //si no hay credenciales no hay rueda y mostramos el mensaje correspondiente.
        [self.activity stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [self.infoLbl setText:NSLocalizedString(@"NO_CREDENTIALS", nil)];
    }
    
}


//implementacion protocolo
- (void)respuesta:(NSDictionary *)feed error:(NSError *)error
{
    //TODO: Controlar errores
    
    //error al conectar 
    //error user/pass
    //0 spreadsheets
    if (error) {
        
        switch (error.code) {
            case 403:
                NSLog(@"Error de login");
                //TODO: Comprobar si al meter mal la clave y guardar las credenciales en el keychain, se puede corregir la clave (también guardada en keychain) y funciona. Creo que he tenido que meter un e-mail inventado antes de poner la clave bien otra vez porque no había manera.
                //mostramos mensaje ERROR y paramos la ruedita.
                self.infoLbl.text = NSLocalizedString(@"LOGIN_ERR", NIL);
                [self.activity stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                break;
                
            case -1009:
                NSLog(@"Error de conexión");
                //mostramos mensaje ERROR y paramos la ruedita.
                self.infoLbl.text = NSLocalizedString(@"CONN_ERR", NIL);
                [self.activity stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];

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
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
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
    
     if ([[segue identifier] isEqualToString:@"goToWorksheetsView"])
     {
     
         //cuando el usuario selecciona una asignatura se le pasa el id de la misma al tableview siguiente
         
         
         ClassListTVC *classListView = [segue destinationViewController];
         classListView.asignatura = self.asignatura;
         
        
         
     }
}

- (IBAction)refreshData:(id)sender {
    
    [self connectIntent];
}
@end
