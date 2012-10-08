//
//  ClassVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 12/09/12.
//
//

#import "ClassVC.h"
#import "ConfigHelper.h"

@interface ClassVC ()

@end

@implementation ClassVC

@synthesize classLbl = _classLbl;
@synthesize miTabla = _miTabla;
@synthesize nombreClase = _nombreClase;
@synthesize clase =_clase;
@synthesize todos = _todos;
@synthesize cuantos = _cuantos;
@synthesize alumno = _alumno;
@synthesize mail =_mail;
@synthesize row = _row;
@synthesize contadorAusenciasGlobal = _contadorAusenciasGlobal;
@synthesize contadorPresenciasGlobal = _contadorPresenciasGlobal;
@synthesize ausenciasArray = _ausenciasArray;
@synthesize presenciasArray = _presenciasArray;
@synthesize fechas = _fechas;
@synthesize nombreAsignatura = _nombreAsignatura;
@synthesize sortedKeys = _sortedKeys;
@synthesize nombres = _nombres;
@synthesize noMatriculadosArray = _noMatriculadosArray;
@synthesize contadorNoMatriculadoGlobal = _contadorNoMatriculadoGlobal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setClassLbl:nil];
    [self setMiTabla:nil];
    [super viewDidUnload];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate=nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    self.classLbl.text = [NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase];
    self.contadorPresenciasGlobal = 0;
    self.contadorAusenciasGlobal = 0;
    self.contadorNoMatriculadoGlobal = 0;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [midh obtenerEstadisticasTodos:self.clase paraAlumnosAusentes:nil yParaAlumnosRetrasados:nil paraTodos:YES];
    
    [super viewWillAppear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section==0)
    {
        return self.cuantos;
    }
    else if(section==1)
        
    {
        return 1;
    }
    else if(section==2)
        
    {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    if(indexPath.section==0)
    {
        
        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"detalleAlumno"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detalleAlumno"];
        }

        //mostramos el nombre del alumno
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        //theCellLbl.text = [[self.todos objectAtIndex:indexPath.row +1] objectAtIndex:0];
        
        theCellLbl.text = [self.sortedKeys objectAtIndex:indexPath.row];
        
        
        
        UILabel *numAusencias = (UILabel *)[cell viewWithTag:2];
        UILabel *numPresencias = (UILabel *)[cell viewWithTag:3];
        [numPresencias setTextColor:[UIColor blackColor]];
        [numAusencias setTextColor:[UIColor blackColor]];
        
        //int contadorAusencias = 0;
        //int contadorPresencias = 0;

        
        /*for(int u=2; u<[[self.todos objectAtIndex:indexPath.row +1] count]; u++)
            {
            
                if([[[self.todos objectAtIndex:indexPath.row +1] objectAtIndex:u] isEqualToString:@"2"])
                {contadorAusencias++;
                    self.contadorAusenciasGlobal++;}
                
                if([[[self.todos objectAtIndex:indexPath.row +1] objectAtIndex:u] isEqualToString:@"3"])
                {contadorPresencias++;
                    self.contadorPresenciasGlobal++;}

            }
         */
            
        float total = [[self.todos objectAtIndex:indexPath.row +1] count]-2;
        if([[self.noMatriculadosArray objectAtIndex:[self.nombres indexOfObject:[self.sortedKeys objectAtIndex:indexPath.row]]] integerValue] > 0)
        {
            total = total - [[self.noMatriculadosArray objectAtIndex:[self.nombres indexOfObject:[self.sortedKeys objectAtIndex:indexPath.row]]] floatValue];
 
        }
            
      
            
            float porcentaje1 = [[self.ausenciasArray objectAtIndex:[self.nombres indexOfObject:[self.sortedKeys objectAtIndex:indexPath.row]]] floatValue]/ total;
            float porcentaje2 = [[self.presenciasArray objectAtIndex:[self.nombres indexOfObject:[self.sortedKeys objectAtIndex:indexPath.row]]] floatValue]/ total;
            
            //float porcentaje1 = [[self.ausenciasArray objectAtIndex:indexPath.row] floatValue]/ total;
            //float porcentaje2 = [[self.presenciasArray objectAtIndex:indexPath.row] floatValue]/ total;
            porcentaje1 = porcentaje1 * 100;
            porcentaje2 = porcentaje2 * 100;
            
            NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
            nf.positiveFormat = @"0.#";
            NSString* s1 = [nf stringFromNumber: [NSNumber numberWithFloat: porcentaje1]];
            NSString* s2 = [nf stringFromNumber: [NSNumber numberWithFloat: porcentaje2]];
            
            numAusencias.text = [NSString stringWithFormat:@"%d (%@%%)",[[self.presenciasArray  objectAtIndex:[self.nombres indexOfObject:[self.sortedKeys objectAtIndex:indexPath.row]]] integerValue],s2];
        
                   
            numPresencias.text = [NSString stringWithFormat:@"%d (%@%%)",[[self.ausenciasArray objectAtIndex:[self.nombres indexOfObject:[self.sortedKeys objectAtIndex:indexPath.row]]] integerValue],s1];
        
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        if([[self.ausenciasArray  objectAtIndex:[self.nombres indexOfObject:[self.sortedKeys objectAtIndex:indexPath.row]]] integerValue]>=configH.ausencias)
            [numPresencias setTextColor:[UIColor redColor]];
        if([[self.ausenciasArray  objectAtIndex:[self.nombres indexOfObject:[self.sortedKeys objectAtIndex:indexPath.row]]] integerValue]+1==configH.ausencias)
            [numPresencias setTextColor:[UIColor orangeColor]];

            return cell;
        
       
            

    }
    else if(indexPath.section==1)
        
        
    {
        
        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"detalleAlumno2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detalleAlumno2"];
        }

        //mostramos la opcion de enviar estadisticas
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:8];
        theCellLbl.text = @"Enviar Estadísticas";
        theCellLbl.textAlignment= UITextAlignmentCenter;
        return cell;
        
    }
    
    else if(indexPath.section==2)
        
    {
        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"detalleAlumno2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detalleAlumno2"];
        }

        //mostramos la opcion de ver resumenes
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:8];
        theCellLbl.text =@"Ver Resúmenes";
        theCellLbl.textAlignment= UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    }
    
    
}


//header y footer para la primera seccion de estadisticas
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        return @"Estadísticas";
    }
    else if((section == 1)||(section == 2))
        return @"";
}

- (NSString *)tableView: (UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        float totalFechas,totalAlumnos,total;
        totalFechas = [[self.todos objectAtIndex:0]count] -2;
        totalAlumnos = [self.todos count]-1;
        if(self.contadorNoMatriculadoGlobal == 0)
        {
            total =  totalAlumnos * totalFechas;
            
        }
        else if (self.contadorNoMatriculadoGlobal > 0)
        {
            
            total =  totalAlumnos * totalFechas;
            total = total - self.contadorNoMatriculadoGlobal;
            
        }
        float porcentajeGlobalAusencias = self.contadorAusenciasGlobal /total;
        float porcentajeGlobalPresencias = self.contadorPresenciasGlobal /total;
        porcentajeGlobalAusencias = porcentajeGlobalAusencias *100;
        porcentajeGlobalPresencias = porcentajeGlobalPresencias *100;
        
        NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
        nf.positiveFormat = @"0.#";
        NSString* s1 = [nf stringFromNumber: [NSNumber numberWithFloat: porcentajeGlobalAusencias]];
        NSString* s2 = [nf stringFromNumber: [NSNumber numberWithFloat: porcentajeGlobalPresencias]];
        return [NSString stringWithFormat:@"%@ %% %@\n%@ %% %@",s2,@"Total Asistencias",s1,@"Total Ausencias "];

    }
    else if((section == 1)||(section == 2))
        return @"";    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.section == 1)||(indexPath.section == 2)) {
        
        
        return 44;
        
        
    }
    else if(indexPath.section == 0)
    {
        
        return 100;
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *theCellLbl = (UILabel *)[cell viewWithTag:8];
    if([theCellLbl.text isEqualToString:@"Ver Resúmenes"])
    {
        GDocsHelper *midh = [GDocsHelper sharedInstance];
        [midh fechasValidasPara:self.clase];

    }
       
    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
    //guardo el nombre del alumno para pasárselo a la siguiente vista (StudentVC)
    self.alumno = theCellLbl.text;
    self.row = indexPath.row+1;
    [self performSegueWithIdentifier:@"goToStudentInfo" sender:self];
    
}
                 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        
        if ([[segue identifier] isEqualToString:@"goToStudentInfo"])
        {
           
            StudentVC *studentVC = [segue destinationViewController];
            studentVC.clase = self.clase;
            studentVC.alumno = self.alumno;
            studentVC.delegate = self;
            studentVC.row = self.row+2;
            studentVC.nombreClase = self.nombreClase;
    
        }
    
    if ([[segue identifier] isEqualToString:@"goToResumenList"])
    {
        
        ResumenesVC *resumenesvc = [segue destinationViewController];
        resumenesvc.resumenes = [self.todos objectAtIndex:0];
        resumenesvc.fechas = self.fechas;
        resumenesvc.nombreClase = self.nombreClase;
        resumenesvc.nombreAsignatura = self.nombreAsignatura;
    }
}


#pragma mark - My methods

-(void) respuestaEstadisticas:(NSMutableArray *)ausentes yRetrasados:(NSMutableArray *)retrasados todos:(NSMutableArray *)todos error:(NSError *)error
{

    self.todos = todos;
    self.cuantos = [todos count]-1;
    int contadorAusencias;
    int contadorPresencias;
    int contadorNoMatriculado;
    
    NSMutableArray *nombres = [NSMutableArray arrayWithCapacity:[todos count]-1];
    
    for (int i=1; i<[todos count]; i++) {
        [nombres addObject:[[todos objectAtIndex:i] objectAtIndex:0]];
    }
    
    self.nombres = nombres;
    
    
    NSArray * sortedKeys = [nombres sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    self.sortedKeys = sortedKeys;
    
    NSMutableArray *contadoresAusenciasArray = [NSMutableArray arrayWithCapacity:[self.todos count]-1];
    NSMutableArray *contadoresPresenciasArray = [NSMutableArray arrayWithCapacity:[self.todos count]-1];
    NSMutableArray *contadoresNoMatriculadoArray = [NSMutableArray arrayWithCapacity:[self.todos count]-1];
    for (int i=1; i<[self.todos count]; i++) {
        contadorAusencias=0;
        contadorPresencias=0;
        contadorNoMatriculado=0;
        for(int u=2; u<[[self.todos objectAtIndex:i] count]; u++)
        {
            
            if([[[self.todos objectAtIndex:i] objectAtIndex:u] isEqualToString:@"2"])
                {contadorAusencias++;
                    self.contadorAusenciasGlobal++;}
                
            
            if(([[[self.todos objectAtIndex:i] objectAtIndex:u] isEqualToString:@"1"]) || ([[[self.todos objectAtIndex:i] objectAtIndex:u] isEqualToString:@"3"]))
                { contadorPresencias++;
                    self.contadorPresenciasGlobal++;}
            
            
            if([[[self.todos objectAtIndex:i] objectAtIndex:u] isEqualToString:@"0"])
               { contadorNoMatriculado++;
                self.contadorNoMatriculadoGlobal++;}
                
            
        }
        [contadoresAusenciasArray addObject:[NSString stringWithFormat:@"%d",contadorAusencias]];
        [contadoresPresenciasArray addObject:[NSString stringWithFormat:@"%d",contadorPresencias]];
        [contadoresNoMatriculadoArray addObject:[NSString stringWithFormat:@"%d",contadorNoMatriculado]];
        
    }
    self.ausenciasArray = contadoresAusenciasArray;
    self.presenciasArray = contadoresPresenciasArray;
    self.noMatriculadosArray = contadoresNoMatriculadoArray;

    [self.miTabla reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

}

-(void) devolverTabla:(StudentVC *)controller huboCambios: (BOOL) cambios
{
    [self.navigationController popViewControllerAnimated:YES];
    if(cambios)
    {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        GDocsHelper *midh = [GDocsHelper sharedInstance];
       [midh obtenerEstadisticasTodos:self.clase paraAlumnosAusentes:nil yParaAlumnosRetrasados:nil paraTodos:YES];
    }
    
}
-(void) respuestaFechasValidas:(NSArray *)fechas error:(NSError *)error
{

    self.fechas = fechas;
    [self performSegueWithIdentifier:@"goToResumenList" sender:self];
        
}

@end
