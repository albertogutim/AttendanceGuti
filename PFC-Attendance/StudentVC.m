//
//  StudentVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 04/09/12.
//
//

#import "StudentVC.h"

@interface StudentVC ()

@end

@implementation StudentVC

@synthesize alumno =_alumno;
@synthesize clase = _clase;
@synthesize mail = _mail;
@synthesize datosAlumnoTable = _datosAlumnoTable;
@synthesize ausencias = _ausencias;
@synthesize pintar = _pintar;
@synthesize row = _row;
@synthesize cuantasAusencias =_cuantasAusencias;
@synthesize cuantosRetrasos = _cuantosRetrasos;
@synthesize pintarAusencias = _pintarAusencias;
@synthesize pintarRetrasos =_pintarRetrasos;
@synthesize datosAlumno = _datosAlumno;

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
    [self setDatosAlumnoTable:nil];
    [super viewDidUnload];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate=nil;
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [midh listadoFechasConAsistencia:self.clase paraAlumno:self.alumno conRow: self.row];
        
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        return 2;
    }
    else if(section==1)
        
    {
        
        return self.cuantasAusencias;
    }
    else if(section==2)
    {
        
        
        return self.cuantosRetrasos;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView
            dequeueReusableCellWithIdentifier:@"datos"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"datos"];
    }
    
    if(indexPath.section==0)
    {
        
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        theCellLbl.text = [self.datosAlumno objectAtIndex:indexPath.row];

    }
    else if(indexPath.section==1)
        
    {
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        theCellLbl.text = [self.pintarAusencias.allKeys objectAtIndex:indexPath.row];
        
    }
    else if(indexPath.section==2)
    {

        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        theCellLbl.text = [self.pintarRetrasos.allKeys objectAtIndex:indexPath.row];
        
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        return @"";
    }
    else if(section == 1)
    {
        return [NSString stringWithFormat:@"Ausencias (%d)",self.cuantasAusencias];
    }
    else if(section == 2)
    {
        return [NSString stringWithFormat:@"Retrasos (%d)",self.cuantosRetrasos];
    }
    
}

#pragma mark - My Methods


-(void)respuestaAusencias:(NSMutableDictionary *)feed error:(NSError *)error
{
    //responde a listadoFechasConAsistencia
    
    
    
    self.mail = [feed objectForKey:@"Email"];
    self.ausencias = [feed objectForKey:@"Estadistica"];
    
    self.datosAlumno = [NSArray arrayWithObjects:self.alumno,self.mail, nil];
    
    [feed removeObjectForKey:@"Email"];
    [feed removeObjectForKey:@"Estadistica"];
    
    self.pintar = feed;
    
    
    NSInteger cuantasAusencias = 0;
    //return [self.ausencias intValue] ;
    for (int i=0; i<[self.pintar count]; i++) {
        
        if([[self.pintar.allValues objectAtIndex:i] isEqualToString:@"2"])
        {
            //No asistió. Hay que poner la fecha en el label
            cuantasAusencias++;
        }
    }
    self.cuantasAusencias = cuantasAusencias;
    
    NSInteger cuantosRetrasos = 0;
    //return [self.ausencias intValue] ;
    for (int i=0; i<[self.pintar count]; i++) {
        
        if([[self.pintar.allValues objectAtIndex:i] isEqualToString:@"3"])
        {
            //No asistió. Hay que poner la fecha en el label
            cuantosRetrasos++;
        }
    }
    self.cuantosRetrasos = cuantosRetrasos;
    
    NSMutableDictionary *ausencias = [NSMutableDictionary dictionaryWithDictionary:self.pintar];
    ausencias = [self filtrarAusentes:ausencias];
    self.pintarAusencias = ausencias;
    
    NSMutableDictionary *retrasos = [NSMutableDictionary dictionaryWithDictionary:self.pintar];
    retrasos = [self filtrarRetrasos:retrasos];
    self.pintarRetrasos = retrasos;
    
    [self.datosAlumnoTable reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}

- (IBAction)eliminarAlumno:(id)sender {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    [midh eliminarAlumno: self.clase paraRow:self.row];
}

-(NSMutableDictionary *) filtrarAusentes: (NSMutableDictionary *) asistencias
{
    
    NSMutableDictionary *filtro = [NSMutableDictionary dictionaryWithDictionary:asistencias];
    for (int j=0; j<[asistencias count]; j++)
    {
        if(![[asistencias.allValues objectAtIndex:j] isEqualToString:@"2"])
            [filtro removeObjectForKey:[asistencias.allKeys objectAtIndex:j]];
        
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


@end
