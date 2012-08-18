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
@synthesize miTabla = _miTabla;
@synthesize clase = _clase;
@synthesize miListaAlumnos = _miListaAlumnos;
@synthesize fecha = _fecha;
@synthesize columna = _columna;
@synthesize todos = _todos;


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
    
}


- (void)viewDidUnload
{
    [self setAttendanceButton:nil];
    [self setTodosPresentesAusentes:nil];
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
                for (int i=0; i<[self.todos count]; i++) {
                    if([[self.todos.allKeys objectAtIndex:i] isEqualToString:[self.miListaAlumnos.allKeys objectAtIndex:indexPath.row]])
                        //cuando lo encuentra hace el update
                        [self.todos setObject:@"2" forKey:[self.todos.allKeys objectAtIndex:i]];
                }
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


#pragma mark - My Methods

- (void)respuestaConColumna:(NSMutableDictionary *) feed enColumna: (NSInteger) columna error: (NSError *) error

{
    self.miListaAlumnos = feed;
    //Mantenemos una copia con todos los alumnos para poder gestionar el segmented control
    self.todos = feed;
    self.columna = columna; 
    [self.miTabla reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    //animar boton pasar asistencia
    [self.attendanceButton setEnabled:YES];
    
    //QUITAR ESTO: Es para probar que funcionaba bien el update de estados en la spreadsheet.
    /*NSArray *alum = [[NSArray alloc] initWithObjects:@"Ana Gutierrez Esguevillas", @"Raquel Gutierrez Esguevillas", @"Aday Perera Rodriguez", @"Raul Suarez Rodriguez", @"Berta Galvan", @"Ana Rios Cabrera", @"Isabel Mayor Guerra", nil];
    
    NSArray *est = [[NSArray alloc] initWithObjects:@"3", @"3",
                    @"2", @"2", @"1", @"1", @"3", nil];
    
    NSDictionary *prueba = [NSDictionary dictionaryWithObjects:est forKeys:alum];
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    [midh updateAlumnosConEstados:self.clase paraUpdate:prueba paraColumna:5];

    */
    
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
}

-(void) devolverFecha: (PickerVC *) controller didSelectDate: (NSDate *) date
{
    self.fecha = date;
    [self.attendanceButton setEnabled:NO];
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
        [self.miTabla reloadData];
    }
        else //Ausentes
            
        {
            //Buscar dentro de "todos" los que estén ausentes
            NSMutableDictionary *ausentes = self.todos;
            ausentes = [self filtrarAusentes:ausentes];
            self.miListaAlumnos = ausentes;
            [self.miTabla reloadData];
        }
    
}

-(NSMutableDictionary *) filtrarAusentes: (NSMutableDictionary *) alumnos
{
    
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
            if([[alumnos.allValues objectAtIndex:j] isEqualToString:@"2"])
                [filtro removeObjectForKey:[alumnos.allKeys objectAtIndex:j]];
        }
    }
    return filtro;
    
}

@end
