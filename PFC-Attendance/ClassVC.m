//
//  ClassVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 12/09/12.
//
//

#import "ClassVC.h"

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
@synthesize contadorRetrasosGlobal = _contadorRetrasosGlobal;
@synthesize ausenciasArray = _ausenciasArray;
@synthesize retrasosArray = _retrasosArray;

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
    self.classLbl.text = self.nombreClase;
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
        theCellLbl.text = [[self.todos objectAtIndex:indexPath.row +1] objectAtIndex:0];
        
        UILabel *numAusencias = (UILabel *)[cell viewWithTag:2];
        UILabel *numRestrasos = (UILabel *)[cell viewWithTag:3];
        //int contadorAusencias = 0;
        //int contadorRetrasos = 0;

        
        /*for(int u=2; u<[[self.todos objectAtIndex:indexPath.row +1] count]; u++)
            {
            
                if([[[self.todos objectAtIndex:indexPath.row +1] objectAtIndex:u] isEqualToString:@"2"])
                {contadorAusencias++;
                    self.contadorAusenciasGlobal++;}
                
                if([[[self.todos objectAtIndex:indexPath.row +1] objectAtIndex:u] isEqualToString:@"3"])
                {contadorRetrasos++;
                    self.contadorRetrasosGlobal++;}

            }
         */
            
        float total = [[self.todos objectAtIndex:indexPath.row +1] count]-2;
        float porcentaje1 = [[self.ausenciasArray objectAtIndex:indexPath.row] floatValue]/ total;
        float porcentaje2 = [[self.retrasosArray objectAtIndex:indexPath.row] floatValue]/ total;
        
        NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
        nf.positiveFormat = @"0.##";
        NSString* s1 = [nf stringFromNumber: [NSNumber numberWithFloat: porcentaje1]];
        NSString* s2 = [nf stringFromNumber: [NSNumber numberWithFloat: porcentaje2]];
        
        numAusencias.text = [NSString stringWithFormat:@"%f (%@)",[[self.ausenciasArray objectAtIndex:indexPath.row] floatValue],s1];
        numRestrasos.text = [NSString stringWithFormat:@"%f (%@)",[[self.retrasosArray objectAtIndex:indexPath.row] floatValue],s2];
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
        
        
        float totalFechas = [[self.todos objectAtIndex:0]count] -2;
        float totalAlumnos = [self.todos count]-1;
        float total =  totalAlumnos * totalFechas;
        float porcentajeGlobalAusencias = self.contadorAusenciasGlobal /total;
        float porcentajeGlobalRetrasos = self.contadorRetrasosGlobal /total;
        
        NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
        nf.positiveFormat = @"0.##";
        NSString* s1 = [nf stringFromNumber: [NSNumber numberWithFloat: porcentajeGlobalAusencias]];
        NSString* s2 = [nf stringFromNumber: [NSNumber numberWithFloat: porcentajeGlobalRetrasos]];
        return [NSString stringWithFormat:@"%@ %@\n%@ %@",s1,@"Total Ausencias",s2,@"Total Retrasos"];

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


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
    //guardo el nombre del alumno para pasárselo a la siguiente vista (StudentVC)
    self.alumno = theCellLbl.text;
    //voy a coger el email para pasárselo también a la siguiente vista (StudentVC)
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
            studentVC.row = self.row;
            studentVC.nombreClase = self.nombreClase;
    
        }
}


#pragma mark - My methods

-(void) respuestaEstadisticas:(NSMutableArray *)ausentes yRetrasados:(NSMutableArray *)retrasados todos:(NSMutableArray *)todos error:(NSError *)error
{

    self.todos = todos;
    self.cuantos = [todos count]-1;
    float contadorAusencias;
    float contadorRetrasos;
    
    NSMutableArray *contadoresAusenciasArray = [NSMutableArray arrayWithCapacity:[self.todos count]-1];
    NSMutableArray *contadoresRetrasosArray = [NSMutableArray arrayWithCapacity:[self.todos count]-1];
    for (int i=1; i<[self.todos count]; i++) {
        contadorAusencias=0;
        contadorRetrasos=0;
        for(int u=2; u<[[self.todos objectAtIndex:i] count]; u++)
        {
            
            if([[[self.todos objectAtIndex:i] objectAtIndex:u] isEqualToString:@"2"])
                {contadorAusencias++;
                    self.contadorAusenciasGlobal++;}
                
            
            if([[[self.todos objectAtIndex:i] objectAtIndex:u] isEqualToString:@"3"])
                { contadorRetrasos++;
                    self.contadorRetrasosGlobal++;}
                
            
        }
        [contadoresAusenciasArray addObject:[NSString stringWithFormat:@"%f",contadorAusencias]];
        [contadoresRetrasosArray addObject:[NSString stringWithFormat:@"%f",contadorRetrasos]];
        
    }
    self.ausenciasArray = contadoresAusenciasArray;
    self.retrasosArray = contadoresRetrasosArray;
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

@end
