//
//  StadisticsVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 09/09/12.
//
//

#import "StadisticsVC.h"

@interface StadisticsVC ()

@end

@implementation StadisticsVC
@synthesize fecha = _fecha;
@synthesize lblfecha = _lblfecha;
@synthesize ausentes = _ausentes;
@synthesize retrasos = _retrasos;
@synthesize clase = _clase;
@synthesize ordenAusentes = _ordenAusentes;
@synthesize ordenRetrasos = _ordenRetrasos;
@synthesize contadorAusentes = _contadorAusentes;
@synthesize contadorRetrasos = _contadorRetrasos;
@synthesize miTabla = _miTabla;

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
    self.lblfecha.text = self.fecha;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [midh obtenerEstadisticasTodos:self.clase paraAlumnosAusentes:self.ordenAusentes yParaAlumnosRetrasados:self.ordenRetrasos];
    
    [super viewWillAppear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section==0)
    {
        return [self.ausentes count];
    }
    else if(section==1)
        
    {
        return [self.retrasos count];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView
            dequeueReusableCellWithIdentifier:@"InformeAlumno"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InformeAlumno"];
    }
    
    if(indexPath.section==0)
    {
        
        //mostramos el nombre del alumno ausente
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        theCellLbl.text = [self.ausentes.allKeys objectAtIndex:indexPath.row];
        
        UILabel *num = (UILabel *)[cell viewWithTag:2];
        int contador = 0;
        for (int i=0; i<[self.contadorAusentes count]; i++) {
            if([[self.ausentes.allKeys objectAtIndex:indexPath.row] isEqualToString:[[self.contadorAusentes objectAtIndex:i] objectAtIndex:0]]) //comparando el nombre
                //si coincide tengo que hace la cuenta
                for(int u=1; u<[[self.contadorAusentes objectAtIndex:i] count]; u++)
                {
                    if([[[self.contadorAusentes objectAtIndex:i] objectAtIndex:u] isEqualToString:@"2"])
                        contador++;
                }
                
        }
        num.text = [NSString stringWithFormat:@"%d",contador];
        
    }
    else if(indexPath.section==1)
        
    {
        //mostramos el nombre del alumno que ha llegado tarde
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        theCellLbl.text = [self.retrasos.allKeys objectAtIndex:indexPath.row];
        
        UILabel *num = (UILabel *)[cell viewWithTag:2];
        int contador = 0;
        for (int i=0; i<[self.contadorRetrasos count]; i++) {
            if([[self.retrasos.allKeys objectAtIndex:indexPath.row] isEqualToString:[[self.contadorRetrasos objectAtIndex:i] objectAtIndex:0]]) //comparando el nombre
                //si coincide tengo que hace la cuenta
                for(int u=1; u<[[self.contadorRetrasos objectAtIndex:i] count]; u++)
                {
                    if([[[self.contadorRetrasos objectAtIndex:i] objectAtIndex:u] isEqualToString:@"3"])
                        contador++;
                }
            
        }
        num.text = [NSString stringWithFormat:@"%d",contador];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        return [NSString stringWithFormat:@"Ausentes (%d)",[self.ausentes count]];
    }
    else if(section == 1)
    {
        return [NSString stringWithFormat:@"Impuntuales (%d)",[self.retrasos count]];
    }
}


#pragma mark - My methods

-(void) respuestaEstadisticas:(NSMutableArray *)ausentes yRetrasados:(NSMutableArray *)retrasados ausenteserror:(NSError *)error
{
    self.contadorAusentes = ausentes;
    self.contadorRetrasos = retrasados;
    [self.miTabla reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
