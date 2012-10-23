//
//  AttendanceStudentsVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendanceStudentsVC.h"
#import "GDocsHelper.h"
#import "ConfigHelper.h"
#import "MBProgressHUD.h"
#import "ClassListTVC.h"

@implementation AttendanceStudentsVC

@synthesize azButton = _azButton;
@synthesize searchBar;
@synthesize mailbutton = _mailbutton;
@synthesize searchDisplayController;
@synthesize todosPresentesAusentes = _todosPresentesAusentes;
@synthesize addButton = _addButton;
@synthesize refreshButton = _refreshButton;
@synthesize informesButton = _informesButton;
@synthesize randomButton = _randomButton;
@synthesize resumenButton = _resumenButton;
@synthesize calendarButton = _calendarButton;
@synthesize miTabla = _miTabla;
@synthesize clase = _clase;
@synthesize miListaAlumnos = _miListaAlumnos;
@synthesize fecha = _fecha;
@synthesize columna = _columna;
@synthesize todos = _todos;
@synthesize today = _today;
@synthesize presentes = _presentes;
@synthesize ausentes = _ausentes;
@synthesize alumno = _alumno;
@synthesize alumnosConOrden = _alumnosConOrden;
@synthesize fechaCompleta = _fechaCompleta;
@synthesize nombreClase = _nombreClase;
@synthesize nombreAsignatura = _nombreAsignatura;
@synthesize sortedKeys = _sortedKeys;
@synthesize tamano = _tamano;
@synthesize searchResults = _searchResults;
@synthesize sortedKeysSearch = _sortedKeysSearch;
@synthesize hacerEsto = _hacerEsto;
//@synthesize mail = _mail;
//@synthesize ausencias = _ausencias;
//@synthesize pintar = _pintar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.azButton setEnabled:NO];
    [self.addButton setEnabled:NO];
    [self.refreshButton setEnabled:NO];
    [self.informesButton setEnabled:NO];
    [self.resumenButton setEnabled:NO];
    [self.todosPresentesAusentes setEnabled:NO];
    [self.randomButton setEnabled:NO];
    [self.mailbutton setEnabled:NO];
    [self.calendarButton setEnabled:NO];
    //[self.mailbutton setStyle:UIBarButtonItemStylePlain];
    self.tamano = self.miTabla.frame;
    
    
    //searching = NO;
    //letUserSelectRow = YES;
    
    //self.miTabla.tableHeaderView = self.buscador;
    //self.buscador.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 105, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    //NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    //UIBarButtonItem* fixButton = [[UIBarButtonItem alloc]
      //                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //pasarAsistenciaButton.style = UIBarButtonItemStyleBordered;
    //[buttons addObject:fixButton];
    
    
   
    /*UIBarButtonItem* mailButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(mailButtonAction)];
    mailButton.style = UIBarButtonItemStyleBordered;
    */
    //UIBarButtonItem* mailButton =[[UIBarButtonItem alloc]
      //                            initWithImage:[UIImage imageNamed:@"mail.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(mailButtonAction)];

    //[buttons addObject:mailButton];

    
    // stick the buttons in the toolbar
    //[tools setItems:buttons animated:NO];
    
 
    
    // and put the toolbar in the nav bar
    
    //UIBarButtonItem* rightButtonBar = [[UIBarButtonItem alloc] initWithCustomView:tools];
    //self.navigationItem.rightBarButtonItem = rightButtonBar;
    
    CGRect bounds = self.miTabla.bounds;
    bounds.origin.y = bounds.origin.y + self.searchBar.bounds.size.height;
    self.miTabla.bounds = bounds;
    
}

- (void)viewDidUnload
{
    [self setTodosPresentesAusentes:nil];
    [self setAddButton:nil];
    [self setRefreshButton:nil];
    [self setInformesButton:nil];
    [self setRandomButton:nil];
    [self setResumenButton:nil];
    [self setCalendarButton:nil];
    [self setSearchBar:nil];
    [self setSearchDisplayController:nil];
    [self setAzButton:nil];
    [self setMailbutton:nil];
    [super viewDidUnload];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    //self.title = [NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase];
    
    //ESTO no se que coño hace aqui!!
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    
    if (self.hacerEsto)
    {
       
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"LOADING", nil);
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        [midh listadoAlumnosClase:self.clase paraFecha:self.fecha paraEstadosPorDefecto: configH.presentesDefecto];
    }
    
    [super viewWillAppear:animated];
        
}

-(void) viewWillDisappear:(BOOL)animated
{


    self.hacerEsto = NO;
    [super viewWillDisappear:animated];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //determinamos el numero de filas en funcion de si estamos trabajando con la tabla del searchDisplayController o con la tabla de datos.
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [self.searchResults count];
 
    else
        return [self.miListaAlumnos count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
     if (tableView != self.searchDisplayController.searchResultsTableView) //tengo que pintar en la tabla utilizando el dictionary miListaAlumnos
    {
        
            cell = [self.miTabla
                    dequeueReusableCellWithIdentifier:@"alumnos"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alumnos"];
            }
            
            
            //rellenamos las celdas con el nombre de la asignatura.
            UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
            UIImageView *iv = (UIImageView *)[cell viewWithTag:2];
            
            //theCellLbl.text = [self.miListaAlumnos.allKeys objectAtIndex:indexPath.row];
            
            theCellLbl.text =[self.sortedKeys objectAtIndex:indexPath.row];
            
            //theCellLbl.text = [[self filterContactsWithLastName:searchString]objectAtIndex:indexPath.row];
            
            
            //switch ([[self.miListaAlumnos.allValues objectAtIndex:indexPath.row] integerValue]) {
            switch ([[self.miListaAlumnos valueForKey:[self.sortedKeys objectAtIndex:indexPath.row]]integerValue]) {
                case 1: //Atendió
                    iv.image = [UIImage imageNamed:@"check.png"];
                    break;
                case 2: //Faltó
                    iv.image = [UIImage imageNamed:@"cross.png"];
                    break;
                    
                case 3: //Retraso
                    iv.image = [UIImage imageNamed:@"late.png"];
                    break;
                case 4: //Vacío
                    iv.image = nil;
                    break;
                default:
                    iv.image = nil;
                    break;
            }
        }
        
    else //tengo que pintar en la tabla del searchDisplayController
    {
    
            cell = [self.miTabla
                    dequeueReusableCellWithIdentifier:@"alumnos"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alumnos"];
            }
            
            
            //rellenamos las celdas con el nombre de la asignatura.
            UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
            UIImageView *iv = (UIImageView *)[cell viewWithTag:2];
            
            
            theCellLbl.text =[self.sortedKeysSearch objectAtIndex:indexPath.row];
            
            switch ([[self.searchResults valueForKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]]integerValue]) {
                case 1: //Atendió
                    iv.image = [UIImage imageNamed:@"check.png"];
                    break;
                case 2: //Faltó
                    iv.image = [UIImage imageNamed:@"cross.png"];
                    break;
                    
                case 3: //Retraso
                    iv.image = [UIImage imageNamed:@"late.png"];
                    break;
                case 4: //Vacío
                    iv.image = nil;
                    break;
                default:
                    iv.image = nil;
                    break;
            }
    }
   
    return cell;
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{

    NSArray *temp;
    NSMutableArray *temp2 = [NSMutableArray arrayWithCapacity:[self.miListaAlumnos count]];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    [self.searchResults removeAllObjects];
    
    //en temp guardo un array con los nombres filtrados
    temp = [self.miListaAlumnos.allKeys filteredArrayUsingPredicate:resultPredicate];
    for (int i=0; i<[temp count]; i++) {
        [temp2 addObject:[self.miListaAlumnos valueForKey:[temp objectAtIndex:i]]];
        //en temp2 guardo los estados para esos nombres filtrados
    }
    
    //en temp3 me construyo en dictionary con los arrays temp y temp2
    NSMutableDictionary *temp3 = [NSMutableDictionary dictionaryWithObjects:temp2 forKeys:temp];

    self.searchResults = temp3;
    
    NSArray * sortedKeysSearch = [[self.searchResults allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    self.sortedKeysSearch = sortedKeysSearch;
    

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

    [self.miTabla reloadData];

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView != self.searchDisplayController.searchResultsTableView)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        NSString *fechaHeader = [df stringFromDate:self.fecha];
        self.fechaCompleta = fechaHeader;
        return [NSString stringWithFormat:@"%@_%@\n%@",self.nombreAsignatura,self.nombreClase,fechaHeader];
    }
    else
        return @"";
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *iv = (UIImageView *)[cell viewWithTag:2];
    if (iv.image == [UIImage imageNamed:@"check.png"])
    {
        iv.image = [UIImage imageNamed:@"cross.png"];
        //cambiar el valor del estado en self.miListaAlumnos para que cuando se repinte la tabla ponga la imagen correcta.
        //también tenemos que hacer el update de self.todos que es el NSDictionary que mantiene siempre una copia de la lista de alumnos completa, por si se da el caso de estar dentro de un filtro y hacer cambios en los estados.
        
        if (tableView != self.searchDisplayController.searchResultsTableView)
        {
            [self.miListaAlumnos setObject:@"2" forKey:[self.sortedKeys objectAtIndex:indexPath.row]];
            [self.todos setObject:@"2" forKey:[self.sortedKeys objectAtIndex:indexPath.row]];
        }
        else
        {
            [self.searchResults setObject:@"2" forKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]];
            [self.todos setObject:@"2" forKey:[self.self.sortedKeysSearch objectAtIndex:indexPath.row]];
             [self.miListaAlumnos setObject:@"2" forKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]];
        }
    
        NSMutableDictionary *presentes = [self filtrarPresentes:self.todos];
        self.presentes = presentes;
        NSMutableDictionary *ausentes = [self filtrarAusentes:self.todos];
        self.ausentes = ausentes;
        
    }
         
    else if (iv.image == [UIImage imageNamed:@"cross.png"])
            {
                iv.image = [UIImage imageNamed:@"late.png"];
                               
                 if (tableView != self.searchDisplayController.searchResultsTableView)
                 {
                     [self.miListaAlumnos setObject:@"3" forKey:[self.sortedKeys objectAtIndex:indexPath.row]];
                     [self.todos setObject:@"3" forKey:[self.sortedKeys objectAtIndex:indexPath.row]];
                 }
                 else
                 {
                     [self.searchResults setObject:@"3" forKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]];
                     [self.todos setObject:@"3" forKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]];
                      [self.miListaAlumnos setObject:@"3" forKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]];
                 }
                
                
                NSMutableDictionary *presentes = [self filtrarPresentes:self.todos];
                self.presentes = presentes;
                NSMutableDictionary *ausentes = [self filtrarAusentes:self.todos];
                self.ausentes = ausentes;
            }
    
        else if (iv.image == [UIImage imageNamed:@"late.png"])
            {
                iv.image = [UIImage imageNamed:@"check.png"];
                
                if (tableView != self.searchDisplayController.searchResultsTableView)
                {
                    [self.miListaAlumnos setObject:@"1" forKey:[self.sortedKeys objectAtIndex:indexPath.row]];
                    [self.todos setObject:@"1" forKey:[self.sortedKeys objectAtIndex:indexPath.row]];
                }
                else
                {
                    [self.miListaAlumnos setObject:@"1" forKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]];
                    [self.todos setObject:@"1" forKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]];
                    [self.miListaAlumnos setObject:@"1" forKey:[self.sortedKeysSearch objectAtIndex:indexPath.row]];
                }
                
                NSMutableDictionary *presentes = [self filtrarPresentes:self.todos];
                self.presentes = presentes;
                NSMutableDictionary *ausentes = [self filtrarAusentes:self.todos];
                self.ausentes = ausentes;
 
            }
     
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
     if ([self.miListaAlumnos count]) 
         return 79;

     else
         return 100;
         
     
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
    //guardo el nombre del alumno para pasárselo a la siguiente vista (StudentVC)
    self.alumno = theCellLbl.text;
    //voy a coger el email para pasárselo también a la siguiente vista (StudentVC)
    
    [self performSegueWithIdentifier:@"goToStudent" sender:self];

}


#pragma mark - My Methods


- (void)respuestaConColumna:(NSMutableDictionary *) feed alumnosConOrden: (NSMutableDictionary *) alumnosConOrden enColumna: (NSInteger) columna error: (NSError *) error

{
    self.miListaAlumnos = feed;
    //Mantenemos una copia con todos los alumnos para poder gestionar el segmented control
    self.todos = feed;
    self.columna = columna;
    self.alumnosConOrden = alumnosConOrden;
    
    NSArray * sortedKeys = [[self.miListaAlumnos allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    self.sortedKeys = sortedKeys;
    
    /*self.searchResults = feed;
    
    NSArray * sortedKeysSearch = [[self.searchResults allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    self.sortedKeysSearch = sortedKeysSearch;
   */
    
    NSMutableDictionary *presentes = [self filtrarPresentes:self.todos];
    self.presentes = presentes;
    NSMutableDictionary *ausentes = [self filtrarAusentes:self.todos];
    self.ausentes = ausentes;
    
    [self.miTabla reloadData];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    //animar boton pasar asistencia
    [self.azButton setEnabled:YES];
    [self.todosPresentesAusentes setEnabled:YES];
    [self.addButton setEnabled:YES];
    [self.refreshButton setEnabled:YES];
    [self.informesButton setEnabled:YES];
    [self.resumenButton setEnabled:YES];
    [self.randomButton setEnabled:YES];
    [self.calendarButton setEnabled:YES];
    [self.mailbutton setEnabled:YES];
    [self.calendarButton setEnabled:YES];
    
    //QUITAR ESTO: Es para probar que funcionaba bien el update de estados en la spreadsheet.
    /*NSArray *alum = [[NSArray alloc] initWithObjects:@"Ana Gutierrez Esguevillas", @"Raquel Gutierrez Esguevillas", @"Aday Perera Rodriguez", @"Raul Suarez Rodriguez", @"Berta Galvan", @"Ana Rios Cabrera", @"Isabel Mayor Guerra", nil];
    
    NSArray *est = [[NSArray alloc] initWithObjects:@"3", @"3",
                    @"2", @"2", @"1", @"1", @"3", nil];
    
    NSDictionary *prueba = [NSDictionary dictionaryWithObjects:est forKeys:alum];
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    [midh updateAlumnosConEstados:self.clase paraUpdate:prueba paraColumna:5];

    */
    
}

- (void)respuestaUpdate: (NSError *) error

{
    if(error){
        //TODO: actuar si error
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
        
            
    
}

- (void)respuestaNewStudent: (NSError *) error
{
   
    if(error){
        //TODO: actuar si error
    }
    else
    {
        //repintamos la tabla
        
        GDocsHelper *midh = [GDocsHelper sharedInstance];
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        [midh listadoAlumnosClase:self.clase paraFecha:self.fecha paraEstadosPorDefecto: configH.presentesDefecto];
        
        
    }

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"goToPicker"])
    {
        PickerVC *pickerV = [segue destinationViewController];
        pickerV.clase = self.clase;
        pickerV.delegate = self;
        pickerV.fecha=self.fecha;
        
    }
    if ([[segue identifier] isEqualToString:@"goToAddStudent"])
    {
        AddStudentTVC *addStudentTVC = [segue destinationViewController];
        addStudentTVC.delegate = self;
        
    }
    
    if ([[segue identifier] isEqualToString:@"goToResumen"])
    {
        ResumenVC *resumenvc = [segue destinationViewController];
        resumenvc.alumnos = self.todos;
        resumenvc.presentes = self.presentes;
        resumenvc.ausentes = self.ausentes;
        resumenvc.columna = self.columna;
        resumenvc.clase = self.clase;
        resumenvc.fecha = self.fecha;
        resumenvc.nombreClase = self.nombreClase;
        
    }
    
    if ([[segue identifier] isEqualToString:@"goToStudent"])
    {
         //hay que pasarle la clase, el nombre, el mail, la fila, sus ausencias y sus retrasos.
        StudentVC *studentVC = [segue destinationViewController];
        studentVC.clase = self.clase;
        studentVC.alumno = self.alumno;
        studentVC.delegate = self;
        studentVC.row = [[self.alumnosConOrden objectForKey:self.alumno]integerValue]+2;
        studentVC.nombreClase = self.nombreClase;
        studentVC.nombreAsignatura = self.nombreAsignatura;
    }

    
    if ([[segue identifier] isEqualToString:@"goToStadistics"])
    {
        StadisticsVC *stadisticsVC = [segue destinationViewController];
        stadisticsVC.fecha = self.fechaCompleta;
        stadisticsVC.ausentes = self.ausentes;
        NSMutableDictionary *retrasos = self.presentes;
        stadisticsVC.retrasos = [self filtrarRetrasos:retrasos];
        retrasos = [self filtrarRetrasos:retrasos];
        stadisticsVC.clase = self.clase;
        stadisticsVC.nombreClase = self.nombreClase;
        stadisticsVC.nombreAsignatura = self.nombreAsignatura;
        
        NSMutableArray *ordenAusentes = [NSMutableArray arrayWithCapacity:[self.ausentes count]];
        for (int j=0; j<[self.ausentes count]; j++)
        {
            for (int i=0; i<[self.alumnosConOrden count]; i++) {
                
                if([[self.alumnosConOrden.allKeys objectAtIndex:i] isEqualToString:[self.ausentes.allKeys objectAtIndex:j]])
                    [ordenAusentes addObject:[self.alumnosConOrden.allValues objectAtIndex:i]];
                    

            }
                       
        }
        
        NSMutableArray *ordenRetrasados = [NSMutableArray arrayWithCapacity:[retrasos count]];
        for (int j=0; j<[retrasos count]; j++)
        {
            for (int i=0; i<[self.alumnosConOrden count]; i++) {
                
                if([[self.alumnosConOrden.allKeys objectAtIndex:i] isEqualToString:[retrasos.allKeys objectAtIndex:j]])
                     [ordenRetrasados addObject:[self.alumnosConOrden.allValues objectAtIndex:i]];
                    
                
            }
            
        }
        
        stadisticsVC.ordenAusentes = ordenAusentes;
        stadisticsVC.ordenRetrasos = ordenRetrasados;
        
    }
    
    
}

-(void) devolverFecha: (PickerVC *) controller didSelectDate: (NSDate *) date hoyEs:(NSDate *) today

{
    self.fecha = date;
    self.today = today;
    [self.azButton setEnabled:NO];
    [self.calendarButton setEnabled:NO];
    [self.refreshButton setEnabled:NO];
    [self.informesButton setEnabled:NO];
    [self.resumenButton setEnabled:NO];
    [self.randomButton setEnabled:NO];
    [self.todosPresentesAusentes setEnabled:NO];
    [self.addButton setEnabled:NO];
    [self.mailbutton setEnabled:YES];
    [self.calendarButton setEnabled:YES];
   
    
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    
    //comprobamos que el usuario realmente seleccionó una fecha y le dió a aceptar y no a cancelar sin seleccionar nada.
    if(date!=nil)
    {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"LOADING", nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        GDocsHelper *midh = [GDocsHelper sharedInstance];
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        [midh listadoAlumnosClase:self.clase paraFecha:self.fecha paraEstadosPorDefecto: configH.presentesDefecto];
        
    }
}


-(void) devolverDatosAlumno: (AddStudentTVC *) controller conNombre: (NSString *) nombre yEmail: (NSString *) mail yEstado: (NSInteger) estado
{

    [self.navigationController popViewControllerAnimated:YES];

    //Aquí hay que añadir el nuevo alumno a la spreadsheet.
    if(nombre!=nil) //Permitimos añadir un alumno sin mail?? NO!
    {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"ADDING_STUDENT", nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [self.azButton setEnabled:NO];
        [self.calendarButton setEnabled:NO];
        [self.refreshButton setEnabled:NO];
        [self.informesButton setEnabled:NO];
        [self.resumenButton setEnabled:NO];
        [self.randomButton setEnabled:NO];
        [self.addButton setEnabled:NO];
        [self.mailbutton setEnabled:NO];
        [self.calendarButton setEnabled:NO];
        [self.todosPresentesAusentes setEnabled:NO];

        //Tenemos que pintar de nuevo la tabla añadiendo el alumno nuevo.
        
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        if(configH.presentesDefecto)
            [self.todos setValue:@"1" forKey:nombre];
        else
             [self.todos setValue:@"2" forKey:nombre];
        
        //Antes de repintar la tabla debemos añadir el nuevo alumno a la spreadsheet
        GDocsHelper *midh = [GDocsHelper sharedInstance];
        midh.delegate = self;
        [midh addStudent: self.clase paraColumna:self.columna conNombre: nombre paraEstadosPorDefecto: configH.presentesDefecto conEmail: mail];
        


    /*UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"datos alumno"
                                                         message:[NSString stringWithFormat:@"nombre: %@ mail: %@", nombre, mail]
                                                        delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
    
    [alertView show];
     */
    }

}

-(void) devolverTabla:(StudentVC *)controller huboCambios: (int) cambios
{
  
    if(cambios==1)
        [self.navigationController popViewControllerAnimated:YES];
    
        [self.azButton setEnabled:NO];
        [self.calendarButton setEnabled:NO];
        [self.refreshButton setEnabled:NO];
        [self.informesButton setEnabled:NO];
        [self.resumenButton setEnabled:NO];
        [self.todosPresentesAusentes setEnabled:NO];
        [self.randomButton setEnabled:NO];
        [self.addButton setEnabled:NO];
        [self.mailbutton setEnabled:NO];
        [self.calendarButton setEnabled:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"LOADING", nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        GDocsHelper *midh = [GDocsHelper sharedInstance];
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        [midh listadoAlumnosClase:self.clase paraFecha:self.fecha paraEstadosPorDefecto: configH.presentesDefecto];

}

- (void)pasarAsistenciaButtonAction{
    
    
    //TODO: habrá que controlar si le ha dado al boton para pasar asistencia o para hacer el update.
    //si es la primera vez se habilita tocar las celdas. si es para el update hay que deshabilitarlas otra vez.
    
    //cambiar apariencia del boton para que cuando se termine de pasar asistencia se pulse de nuevo y se vuelque la información
    
    //INTENTO DE CAMBIAR EL BOTON COMPOSE POR UNO QUE PONGA OK
    /*NSMutableArray *newButton = [[NSMutableArray alloc] initWithCapacity:1];
    UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 53.0f)];
    
    UIBarButtonItem *bi1 = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(Edit:)];
    bi1.style = UIBarButtonItemStyleBordered;
    bi1.width = 45;
    [newButton addObject:bi1];
    
    
    // Add button to toolbar and toolbar to nav bar.
    [tools setItems:newButton animated:NO];
    
    // Add toolbar to nav bar.
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = button;
*/
    
    //habilitar tocar celdas
    
    if(self.miTabla.userInteractionEnabled)
       [self.miTabla setUserInteractionEnabled:NO];
    else
        [self.miTabla setUserInteractionEnabled:YES];
        
        
    

}


- (IBAction)changeSegmentedControl:(id)sender {
    if(self.todosPresentesAusentes.selectedSegmentIndex == 0) {
        //Todos
        self.miListaAlumnos = self.todos;
        NSArray * sortedKeys = [[self.miListaAlumnos allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
        
        self.sortedKeys = sortedKeys;

        [self.miTabla reloadData];

    }
    else if (self.todosPresentesAusentes.selectedSegmentIndex == 1) {
        //Presentes
        //Buscar dentro de "todos" los que estén presentes
        NSMutableDictionary *presentes = self.todos;
        presentes = [self filtrarPresentes:presentes];
        self.miListaAlumnos = presentes;
        self.presentes = presentes;
        NSArray * sortedKeys = [[self.miListaAlumnos allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
        
        self.sortedKeys = sortedKeys;
        [self.miTabla reloadData];
    }
        else //Ausentes
            
        {
            //Buscar dentro de "todos" los que estén ausentes
            NSMutableDictionary *ausentes = self.todos;
            ausentes = [self filtrarAusentes:ausentes];
            self.miListaAlumnos = ausentes;
            self.ausentes = ausentes;
            NSArray * sortedKeys = [[self.miListaAlumnos allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
            
            self.sortedKeys = sortedKeys;
            [self.miTabla reloadData];
        }
    
}

/*- (void)mailButtonAction
{
    
    if(self.todosPresentesAusentes.selectedSegmentIndex == 0)
    {
        NSMutableString *presentes = [NSMutableString stringWithCapacity:[self.presentes count]];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        NSString *dateStr = [df stringFromDate:self.fecha];
        [presentes appendString:[NSString stringWithFormat:@"%@_%@\n",self.nombreAsignatura,self.nombreClase]];
        [presentes appendString:[NSString stringWithFormat:@"%@\n\n",dateStr]];
        [presentes appendString:@"Presentes\n\n"];
        for (int i=0; i<[self.presentes count]; i++) {
            if([[self.presentes.allValues objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%d",3]])
                [presentes appendString:[NSString stringWithFormat:@"%@ (Llegó tarde)\n",[self.presentes.allKeys objectAtIndex:i]]];
            else
                [presentes appendString:[NSString stringWithFormat:@"%@\n",[self.presentes.allKeys objectAtIndex:i]]];

        }
        
        if([self.ausentes count]>0)
        {
        [presentes appendString:@"\n\nAusentes\n\n"];
        for (int i=0; i<[self.ausentes count]; i++) {
            [presentes appendString:[NSString stringWithFormat:@"%@\n",[self.ausentes.allKeys objectAtIndex:i]]];
            
        }
        }
        
        
        
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"TODAY_STUDENTS_LIST" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase],dateStr]];
            [composer setMessageBody:presentes isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }
    }
    
    if(self.todosPresentesAusentes.selectedSegmentIndex == 1)
    {
        
        NSMutableString *presentes = [NSMutableString stringWithCapacity:[self.presentes count]];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        NSString *dateStr = [df stringFromDate:self.fecha];
        [presentes appendString:[NSString stringWithFormat:@"%@_%@\n",self.nombreAsignatura,self.nombreClase]];
        [presentes appendString:[NSString stringWithFormat:@"%@\n\n",dateStr]];
        [presentes appendString:@"Presentes\n\n"];
        for (int i=0; i<[self.presentes count]; i++) {
            if([[self.presentes.allValues objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%d",3]])
                [presentes appendString:[NSString stringWithFormat:@"%@ (Llegó tarde)\n",[self.presentes.allKeys objectAtIndex:i]]];
            else
                [presentes appendString:[NSString stringWithFormat:@"%@\n",[self.presentes.allKeys objectAtIndex:i]]];
            
        }


        
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"TODAY_STUDENTS_LIST" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase],dateStr]];
            [composer setMessageBody:presentes isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }

    }
    
    if(self.todosPresentesAusentes.selectedSegmentIndex == 2)
    {
        
        NSMutableString *presentes = [NSMutableString stringWithCapacity:[self.presentes count]];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        NSString *dateStr = [df stringFromDate:self.fecha];
        [presentes appendString:[NSString stringWithFormat:@"%@_%@\n",self.nombreAsignatura,self.nombreClase]];
        [presentes appendString:dateStr];
        if([self.ausentes count]>0)
        {
             [presentes appendString:@"\n\nAusentes\n\n"];
            for (int i=0; i<[self.ausentes count]; i++) {
                [presentes appendString:[NSString stringWithFormat:@"%@\n",[self.ausentes.allKeys objectAtIndex:i]]];
                
            }
        }
        
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"TODAY_STUDENTS_LIST" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase],dateStr]];
            [composer setMessageBody:presentes isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }
    }

}
 */

-(NSMutableDictionary *) filtrarAusentes: (NSMutableDictionary *) alumnos
{
   //TODO: mirar si aki hay que tener en cuenta los alumnos añadidos que tienen 0
   NSMutableDictionary *filtro = [NSMutableDictionary dictionaryWithDictionary:alumnos];
    for (int j=0; j<[alumnos count]; j++)
    {
        if(![[alumnos.allValues objectAtIndex:j] isEqualToString:@"2"])
            [filtro removeObjectForKey:[alumnos.allKeys objectAtIndex:j]];

    }
    return filtro;

}

-(NSMutableDictionary *) filtrarPresentes: (NSMutableDictionary *) alumnos
{
    NSMutableDictionary *filtro = [NSMutableDictionary dictionaryWithDictionary:alumnos];
    for (int j=0; j<[alumnos count]; j++)
    {
        if(![[alumnos.allValues objectAtIndex:j] isEqualToString:@"1"])
        {
            if(([[alumnos.allValues objectAtIndex:j] isEqualToString:@"2"]) || ([[alumnos.allValues objectAtIndex:j] isEqualToString:@"0"]))
                [filtro removeObjectForKey:[alumnos.allKeys objectAtIndex:j]];
        }
    }
    return filtro;
    
}

-(NSMutableDictionary *) filtrarRetrasos: (NSMutableDictionary *) asistencias
{
    NSMutableDictionary *filtro = [NSMutableDictionary dictionaryWithDictionary:asistencias];
    for (int j=0; j<[asistencias count]; j++)
    {
        if(![[asistencias.allValues objectAtIndex:j] isEqualToString:@"3"])
        {
            [filtro removeObjectForKey:[asistencias.allKeys objectAtIndex:j]];
        }
    }
    return filtro;
    
}

- (IBAction)updateSpreadsheet:(id)sender {
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    [midh updateAlumnosConEstados:self.clase paraUpdate:self.todos paraColumna:self.columna];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"UPDATING", nil);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
}

- (IBAction)randomStudent:(id)sender
{
   int randomKeyIndex = (arc4random()% [[self.presentes allKeys] count]);
   NSString *randomKey = [[self.presentes allKeys] objectAtIndex:randomKeyIndex];
   UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@""
     message:[NSString stringWithFormat:@"%@", randomKey]
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     
     [alertView show];
    

    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error) {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}



- (IBAction)azButtonPressed:(id)sender {
    
    if([self.azButton.title isEqualToString:  @"Z-A"])
    {
       
        
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];
        NSArray* sortedArray = [self.miListaAlumnos.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
         self.sortedKeys = sortedArray;
        
        [self.miTabla reloadData];
        
        
        [(UIBarButtonItem *)sender setTitle:@"A-Z"];
        
        //[(UILabel *)[[self.toolbarItems objectAtIndex:1] view] setText:@"Z-A"];
        
        //[self.azButton setTitle:@"Z-A"];
    }
    else
    {

        NSArray * sortedKeys = [[self.miListaAlumnos allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
        
        self.sortedKeys = sortedKeys;
        
        [self.miTabla reloadData];
        
        [(UIBarButtonItem *)sender setTitle:@"Z-A"];
        
        //[self.azButton setTitle:@"A-Z"];
        

    }
}
- (IBAction)sendmail:(id)sender {
    
    if(self.todosPresentesAusentes.selectedSegmentIndex == 0)
    {
        NSMutableString *presentes = [NSMutableString stringWithCapacity:[self.presentes count]];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        NSString *dateStr = [df stringFromDate:self.fecha];
        [presentes appendString:[NSString stringWithFormat:@"%@_%@\n",self.nombreAsignatura,self.nombreClase]];
        [presentes appendString:[NSString stringWithFormat:@"%@\n\n",dateStr]];
        [presentes appendString:@"Presentes\n\n"];
        for (int i=0; i<[self.presentes count]; i++) {
            if([[self.presentes.allValues objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%d",3]])
                [presentes appendString:[NSString stringWithFormat:@"%@ (Llegó tarde)\n",[self.presentes.allKeys objectAtIndex:i]]];
            else
                [presentes appendString:[NSString stringWithFormat:@"%@\n",[self.presentes.allKeys objectAtIndex:i]]];
            
        }
        
        if([self.ausentes count]>0)
        {
            [presentes appendString:@"\n\nAusentes\n\n"];
            for (int i=0; i<[self.ausentes count]; i++) {
                [presentes appendString:[NSString stringWithFormat:@"%@\n",[self.ausentes.allKeys objectAtIndex:i]]];
                
            }
        }
        
        
        
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"TODAY_STUDENTS_LIST" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase],dateStr]];
            [composer setMessageBody:presentes isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }
    }
    
    if(self.todosPresentesAusentes.selectedSegmentIndex == 1)
    {
        
        NSMutableString *presentes = [NSMutableString stringWithCapacity:[self.presentes count]];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        NSString *dateStr = [df stringFromDate:self.fecha];
        [presentes appendString:[NSString stringWithFormat:@"%@_%@\n",self.nombreAsignatura,self.nombreClase]];
        [presentes appendString:[NSString stringWithFormat:@"%@\n\n",dateStr]];
        [presentes appendString:@"Presentes\n\n"];
        for (int i=0; i<[self.presentes count]; i++) {
            if([[self.presentes.allValues objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%d",3]])
                [presentes appendString:[NSString stringWithFormat:@"%@ (Llegó tarde)\n",[self.presentes.allKeys objectAtIndex:i]]];
            else
                [presentes appendString:[NSString stringWithFormat:@"%@\n",[self.presentes.allKeys objectAtIndex:i]]];
            
        }
        
        
        
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"TODAY_STUDENTS_LIST" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase],dateStr]];
            [composer setMessageBody:presentes isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }
        
    }
    
    if(self.todosPresentesAusentes.selectedSegmentIndex == 2)
    {
        
        NSMutableString *presentes = [NSMutableString stringWithCapacity:[self.presentes count]];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        NSString *dateStr = [df stringFromDate:self.fecha];
        [presentes appendString:[NSString stringWithFormat:@"%@_%@\n",self.nombreAsignatura,self.nombreClase]];
        [presentes appendString:dateStr];
        if([self.ausentes count]>0)
        {
            [presentes appendString:@"\n\nAusentes\n\n"];
            for (int i=0; i<[self.ausentes count]; i++) {
                [presentes appendString:[NSString stringWithFormat:@"%@\n",[self.ausentes.allKeys objectAtIndex:i]]];
                
            }
        }
        
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"TODAY_STUDENTS_LIST" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase],dateStr]];
            [composer setMessageBody:presentes isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }
    }

}
@end
