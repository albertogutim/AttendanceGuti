//
//  StadisticsVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 09/09/12.
//
//

#import "StadisticsVC.h"
#import "ConfigHelper.h"
#import "MBProgressHUD.h"

@interface StadisticsVC ()

@end

@implementation StadisticsVC
@synthesize ambosAusentesImpuntuales = _ambosAusentesImpuntuales;
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
@synthesize nombreAsignatura = _nombreAsignatura;
@synthesize nombreClase = _nombreClase;

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
    [self setAmbosAusentesImpuntuales:nil];
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
    self.lblAsignaturaGrupo.text = [NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"LOADING", nil);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [midh obtenerEstadisticasTodos:self.clase paraAlumnosAusentes:self.ordenAusentes yParaAlumnosRetrasados:self.ordenRetrasos paraTodos: NO];
    
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
        [num setTextColor:[UIColor blackColor]];
        int contador = 0;
        for (int i=0; i<[self.contadorAusentes count]; i++) {
            if([[self.ausentes.allKeys objectAtIndex:indexPath.row] isEqualToString:[[self.contadorAusentes objectAtIndex:i] objectAtIndex:0]]) //comparando el nombre
                //si coincide tengo que hacer la cuenta
                for(int u=1; u<[[self.contadorAusentes objectAtIndex:i] count]; u++)
                {
                    if([[[self.contadorAusentes objectAtIndex:i] objectAtIndex:u] isEqualToString:@"2"])
                        contador++;
                }
                
        }
        //theCellLbl.text = [NSString stringWithFormat:@"%@ (%d)",[self.ausentes.allKeys objectAtIndex:indexPath.row],contador];
        num.text = [NSString stringWithFormat:@"(%d)",contador];
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        if(contador>=configH.ausencias)
            [num setTextColor:[UIColor redColor]];
        if(contador+1==configH.ausencias)
            [num setTextColor:[UIColor orangeColor]];
            
        
    }
    else if(indexPath.section==1)
        
    {
        //mostramos el nombre del alumno que ha llegado tarde
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        
        theCellLbl.text = [self.retrasos.allKeys objectAtIndex:indexPath.row];
        UILabel *num = (UILabel *)[cell viewWithTag:2];
        [num setTextColor:[UIColor blackColor]];
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
        //theCellLbl.text = [NSString stringWithFormat:@"%@ (%d)",[self.retrasos.allKeys objectAtIndex:indexPath.row],contador];
        num.text = [NSString stringWithFormat:@"(%d)",contador];
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        if(contador>=configH.retrasos)
            [num setTextColor:[UIColor redColor]];
        if(contador+1==configH.retrasos)
            [num setTextColor:[UIColor orangeColor]];
    
        
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

-(void) respuestaEstadisticas:(NSMutableArray *)ausentes yRetrasados:(NSMutableArray *)retrasados todos: (NSMutableArray *) todos error:(NSError *)error 
{
    self.contadorAusentes = ausentes;
    self.contadorRetrasos = retrasados;
    [self.miTabla reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (IBAction)sendMail:(id)sender {
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    [midh listadoAlumnos:self.clase];
}

-(void) respuesta:(NSDictionary *)feed error:(NSError *)error
{
    
    
    NSMutableArray *mails = [NSMutableArray arrayWithCapacity: [feed count]];
    if (self.ambosAusentesImpuntuales.selectedSegmentIndex == 0) {
       
        for (int j=0; j<[feed count]; j++) {
            for (int i=0; i<[self.ausentes count]; i++) {
                
                if([[feed.allKeys objectAtIndex:j] isEqualToString:[self.ausentes.allKeys objectAtIndex:i]])
                {
                    //nos vamos creando el array de mails
                    [mails addObject:[feed.allValues objectAtIndex:j]];
                    break;
                }
            }
            
        }
        
        for (int j=0; j<[feed count]; j++) {
            for (int i=0; i<[self.retrasos count]; i++) {
                
                if([[feed.allKeys objectAtIndex:j] isEqualToString:[self.retrasos.allKeys objectAtIndex:i]])
                {
                    //nos vamos creando el array de mails
                    [mails addObject:[feed.allValues objectAtIndex:j]];
                    break;
                }
            }
        }
        
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setBccRecipients:mails];
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"STADISTICS_SUBJECT" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase]]];
            [composer setMessageBody:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"STADISTICS" value:@"" table:nil],configH.ausencias, configH.retrasos] isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }


    }
    else if (self.ambosAusentesImpuntuales.selectedSegmentIndex == 1)
    {
        //tengo que cotejar los alumnos con los ausentes
        
        
        for (int j=0; j<[feed count]; j++) {
            for (int i=0; i<[self.ausentes count]; i++) {
                
                if([[feed.allKeys objectAtIndex:j] isEqualToString:[self.ausentes.allKeys objectAtIndex:i]])
                {
                    //nos vamos creando el array de mails
                    [mails addObject:[feed.allValues objectAtIndex:j]];
                    break;
                }
            }
        
        }
        
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setBccRecipients:mails];
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"STADISTICS_SUBJECT" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase]]];
            [composer setMessageBody:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"STADISTICS_MISSED" value:@"" table:nil],self.fecha, configH.ausencias] isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }

        
    }
    else ////tengo que cotejar los alumnos con los retrasados
    {
        for (int j=0; j<[feed count]; j++) {
            for (int i=0; i<[self.retrasos count]; i++) {
                
                if([[feed.allKeys objectAtIndex:j] isEqualToString:[self.retrasos.allKeys objectAtIndex:i]])
                {
                    //nos vamos creando el array de mails
                    [mails addObject:[feed.allValues objectAtIndex:j]];
                    break;
                }
            }
        }
        
        ConfigHelper *configH = [ConfigHelper sharedInstance];
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setBccRecipients:mails];
            [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"STADISTICS_SUBJECT" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase]]];
            [composer setMessageBody:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"STADISTICS_LATE" value:@"" table:nil],self.fecha, configH.retrasos] isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentModalViewController:composer animated:YES];
        }

    }
    
        
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error) {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}


@end
