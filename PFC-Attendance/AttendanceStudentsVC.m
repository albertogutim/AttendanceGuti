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

@implementation AttendanceStudentsVC


@synthesize todosPresentesAusentes = _todosPresentesAusentes;
@synthesize attendanceButton = _attendanceButton;
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
    [self.attendanceButton setEnabled:NO];
    [self.addButton setEnabled:NO];
    [self.refreshButton setEnabled:NO];
    [self.informesButton setEnabled:NO];
    [self.resumenButton setEnabled:NO];
    [self.randomButton setEnabled:NO];
}


- (void)viewDidUnload
{
    [self setAttendanceButton:nil];
    [self setTodosPresentesAusentes:nil];
    [self setAddButton:nil];
    [self setRefreshButton:nil];
    [self setInformesButton:nil];
    [self setRandomButton:nil];
    [self setResumenButton:nil];
    [self setCalendarButton:nil];
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
    [super viewWillAppear:animated];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([self.miListaAlumnos count]) {
        return [self.miListaAlumnos count];
    } else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.fecha == nil){
        
        
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"infoCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
        }
        
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:3];
        theCellLbl.text = NSLocalizedString(@"CHOOSE_DATE", nil);
        cell.imageView.image = [UIImage imageNamed:@"curlButt.png"];
        
    }

    
    else  if ([self.miListaAlumnos count]){
        
        
       cell = [tableView 
                                 dequeueReusableCellWithIdentifier:@"alumnos"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alumnos"];
        }
        
       
        //rellenamos las celdas con el nombre de la asignatura.
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        UIImageView *iv = (UIImageView *)[cell viewWithTag:2];
        
        theCellLbl.text = [self.miListaAlumnos.allKeys objectAtIndex:indexPath.row];
        switch ([[self.miListaAlumnos.allValues objectAtIndex:indexPath.row] integerValue]) {
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
    else
    
    {
    
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"noAlumnos"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noAlumnos"];
        }

         UILabel *theCellLbl = (UILabel *)[cell viewWithTag:8];
         theCellLbl.text = NSLocalizedString(@"NO_STUDENTS", nil);
    }
   
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [df setDateStyle:NSDateFormatterFullStyle];
    NSLocale *theLocale = [NSLocale currentLocale];
    [df setLocale:theLocale];
    NSString *fechaHeader = [df stringFromDate:self.fecha];
    self.fechaCompleta = fechaHeader;
    return fechaHeader;

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
        
        [self.miListaAlumnos setObject:@"2" forKey:[self.miListaAlumnos.allKeys objectAtIndex:indexPath.row]];
        //también tenemos que hacer el update de self.todos que es el NSDictionary que mantiene siempre una copia de la lista de alumnos completa, por si se da el caso de estar dentro de un filtro y hacer cambios en los estados.
    
                //buscamos por el nombre en self.todos
        //TO DO: COMPRUEBA SI ESTO MISMO NO LO PUEDES HACER DIRECTAMENTE USANDO EL MÉTODO valueForKey DE self.todos
                for (int i=0; i<[self.todos count]; i++) {
                    if([[self.todos.allKeys objectAtIndex:i] isEqualToString:[self.miListaAlumnos.allKeys objectAtIndex:indexPath.row]])
                        //cuando lo encuentra hace el update
                        [self.todos setObject:@"2" forKey:[self.todos.allKeys objectAtIndex:i]];
                }
        NSMutableDictionary *presentes = [self filtrarPresentes:self.todos];
        self.presentes = presentes;
        NSMutableDictionary *ausentes = [self filtrarAusentes:self.todos];
        self.ausentes = ausentes;
        
    }
         
    else if (iv.image == [UIImage imageNamed:@"cross.png"])
            {
                iv.image = [UIImage imageNamed:@"late.png"];
                [self.miListaAlumnos setObject:@"3" forKey:[self.miListaAlumnos.allKeys objectAtIndex:indexPath.row]];
                
                    //buscamos por el nombre en self.todos
                    for (int i=0; i<[self.todos count]; i++) {
                        if([[self.todos.allKeys objectAtIndex:i] isEqualToString:[self.miListaAlumnos.allKeys objectAtIndex:indexPath.row]])
                            //cuando lo encuentra hace el update
                            [self.todos setObject:@"3" forKey:[self.todos.allKeys objectAtIndex:i]];
                    }
                NSMutableDictionary *presentes = [self filtrarPresentes:self.todos];
                self.presentes = presentes;
                NSMutableDictionary *ausentes = [self filtrarAusentes:self.todos];
                self.ausentes = ausentes;
            }
    
        else if (iv.image == [UIImage imageNamed:@"late.png"])
            {
                iv.image = [UIImage imageNamed:@"check.png"];
                [self.miListaAlumnos setObject:@"1" forKey:[self.miListaAlumnos.allKeys objectAtIndex:indexPath.row]];
                    //buscamos por el nombre en self.todos
                    for (int i=0; i<[self.todos count]; i++) {
                        if([[self.todos.allKeys objectAtIndex:i] isEqualToString:[self.miListaAlumnos.allKeys objectAtIndex:indexPath.row]])
                            //cuando lo encuentra hace el update
                            [self.todos setObject:@"1" forKey:[self.todos.allKeys objectAtIndex:i]];
                    }
                NSMutableDictionary *presentes = [self filtrarPresentes:self.todos];
                self.presentes = presentes;
                NSMutableDictionary *ausentes = [self filtrarAusentes:self.todos];
                self.ausentes = ausentes;
 
            }
     
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
     if ([self.miListaAlumnos count]) {
         
         
         return 79;

         
     }
     else{
        
          return 100;
         
     }
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
    
    NSMutableDictionary *presentes = [self filtrarPresentes:self.todos];
    self.presentes = presentes;
    NSMutableDictionary *ausentes = [self filtrarAusentes:self.todos];
    self.ausentes = ausentes;
    
    [self.miTabla reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    //animar boton pasar asistencia
    [self.attendanceButton setEnabled:YES];
    
    //solo se podra añadir un alumno si se trata del dia de hoy porque si no quedaria la spreadsheet incompleta
    if([self.today isEqualToDate:self.fecha])
        [self.addButton setEnabled:YES];
    [self.refreshButton setEnabled:YES];
    [self.informesButton setEnabled:YES];
    [self.resumenButton setEnabled:YES];
    [self.randomButton setEnabled:YES];
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
        
        //cuando el usuario selecciona una clase se le pasa el id de la misma al viewcontroller siguiente
        
        
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
    [self.attendanceButton setEnabled:NO];
    [self.calendarButton setEnabled:NO];
    [self.refreshButton setEnabled:NO];
    [self.informesButton setEnabled:NO];
    [self.resumenButton setEnabled:NO];
    [self.randomButton setEnabled:NO];
    [self.addButton setEnabled:NO];
   
    
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    
    //comprobamos que el usuario realmente seleccionó una fecha y le dió a aceptar y no a cancelar sin seleccionar nada.
    if(date!=nil)
    {
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
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [self.attendanceButton setEnabled:NO];
        [self.calendarButton setEnabled:NO];
        [self.refreshButton setEnabled:NO];
        [self.informesButton setEnabled:NO];
        [self.resumenButton setEnabled:NO];
        [self.randomButton setEnabled:NO];
        [self.addButton setEnabled:NO];

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

-(void) devolverTabla:(StudentVC *)controller huboCambios: (BOOL) cambios
{
    [self.navigationController popViewControllerAnimated:YES];
    if(cambios)
    {
        
        [self.attendanceButton setEnabled:NO];
        [self.calendarButton setEnabled:NO];
        [self.refreshButton setEnabled:NO];
        [self.informesButton setEnabled:NO];
        [self.resumenButton setEnabled:NO];
        [self.randomButton setEnabled:NO];
        [self.addButton setEnabled:NO];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        GDocsHelper *midh = [GDocsHelper sharedInstance];
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        [midh listadoAlumnosClase:self.clase paraFecha:self.fecha paraEstadosPorDefecto: configH.presentesDefecto];
    }

}

- (IBAction)attendance:(id)sender {
    
    
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
    
    [self.miTabla setUserInteractionEnabled:YES];
    

}

- (IBAction)changeSegmentedControl:(id)sender {
    if(self.todosPresentesAusentes.selectedSegmentIndex == 0) {
        //Todos
        self.miListaAlumnos = self.todos;
        [self.miTabla reloadData];

    }
    else if (self.todosPresentesAusentes.selectedSegmentIndex == 1) {
        //Presentes
        //Buscar dentro de "todos" los que estén presentes
        NSMutableDictionary *presentes = self.todos;
        presentes = [self filtrarPresentes:presentes];
        self.miListaAlumnos = presentes;
        self.presentes = presentes;
        [self.miTabla reloadData];
    }
        else //Ausentes
            
        {
            //Buscar dentro de "todos" los que estén ausentes
            NSMutableDictionary *ausentes = self.todos;
            ausentes = [self filtrarAusentes:ausentes];
            self.miListaAlumnos = ausentes;
            self.ausentes = ausentes;
            [self.miTabla reloadData];
        }
    
}

-(NSMutableDictionary *) filtrarAusentes: (NSMutableDictionary *) alumnos
{
   //TODO: mirar si aki hay que tener en cuenta los alumnos añadidos que tienen -1
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
            if(([[alumnos.allValues objectAtIndex:j] isEqualToString:@"2"]) || ([[alumnos.allValues objectAtIndex:j] isEqualToString:@"-1"]))
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
}

- (IBAction)randomStudent:(id)sender
{
   int randomKeyIndex = (arc4random()% [[self.todos allKeys] count]);
   NSString *randomKey = [[self.todos allKeys] objectAtIndex:randomKeyIndex];
   UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Alumno"
     message:[NSString stringWithFormat:@"nombre: %@", randomKey]
     delegate:self
     cancelButtonTitle:@"Dismiss"
     otherButtonTitles:nil];
     
     [alertView show];
    

    
}




@end
