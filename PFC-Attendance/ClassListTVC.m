//
//  ClassListTVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClassListTVC.h"
#import "GDocsHelper.h"



@implementation ClassListTVC
@synthesize miTabla = _miTabla;
@synthesize asignatura = _asignatura;
@synthesize miListaClases = _miListaClases;
@synthesize clase = _clase;
@synthesize nombreClase = _nombreClase;
@synthesize nombreAsignatura = _nombreAsignatura;
@synthesize fecha = _fecha;
@synthesize today = _today;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = NSLocalizedString(@"CLASS_TITLE", nil);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate=nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    //NSLog(@"%@", [self.asignatura description]); 
    
    [self connectIntent];
    //self.title = self.nombreAsignatura;
    
    [super viewWillAppear:animated];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.miListaClases count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"claselistar"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"claselistar"];
    }
    
    //rellenamos las celdas con el nombre de la asignatura.
    cell.textLabel.text = [self.miListaClases.allValues objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     self.clase= [self.miListaClases.allKeys objectAtIndex:indexPath.row];
     self.nombreClase = [self.miListaClases.allValues objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"goToPickerFromClassList" sender:self];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //guardo el nombre de la clase para pasárselo a la siguiente vista que lo necesite
    self.nombreClase = cell.textLabel.text;
    self.clase= [self.miListaClases.allKeys objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"goToClassInform" sender:self];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.nombreAsignatura;
}

#pragma mark - My Methods

-(void) connectIntent

{

    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    
    [midh listadoClasesAsignatura:self.asignatura];

}
- (void)respuesta:(NSDictionary *) feed error: (NSError *) error

{
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
    }
        else
        {

            self.miListaClases = feed;
            [self.miTabla reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }

}

- (IBAction)refreshData:(id)sender 
{
    
    [self connectIntent];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"goToPickerFromClassList"])
    {
        
        //cuando el usuario selecciona una clase se le pasa el id de la misma al viewcontroller siguiente
        
        
        
        PickerFirstVC *pickerFirstvc = [segue destinationViewController];
        pickerFirstvc.clase = self.clase;
        pickerFirstvc.fecha = self.fecha;
        pickerFirstvc.delegate = self;
        pickerFirstvc.nombreClase = self.nombreClase;
        pickerFirstvc.nombreAsignatura = self.nombreAsignatura;
    
        
        
        
    }
    
    if ([[segue identifier] isEqualToString:@"goToClassInform"])
    {
        
        ClassVC *classvc = [segue destinationViewController];
        classvc.clase = self.clase;
        classvc.nombreClase = self.nombreClase;
        classvc.nombreAsignatura = self.nombreAsignatura;
        
    }
    
    
    if ([[segue identifier] isEqualToString:@"goToAttendanceStudents"])
    {
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
        AttendanceStudentsVC *attendanceStudentsvc = [segue destinationViewController];
        
        
        attendanceStudentsvc.clase = self.clase;
        attendanceStudentsvc.fecha = self.fecha;
        attendanceStudentsvc.today = self.today;
        attendanceStudentsvc.nombreAsignatura = self.nombreAsignatura;
        attendanceStudentsvc.nombreClase = self.nombreClase;
        attendanceStudentsvc.hacerEsto = YES;
        
    }
    
}

-(void) devolverFecha: (PickerVC *) controller didSelectDate: (NSDate *) date hoyEs:(NSDate *) today

{
    
    
    self.fecha = date;
    self.today = today;
    [self.navigationController dismissModalViewControllerAnimated:YES];

    if(date==nil)
        [self.miTabla reloadData];
  
}

-(void) termino:(PickerFirstVC *)controller
{
    if(self.fecha!=nil)
        [self performSegueWithIdentifier:@"goToAttendanceStudents" sender:self];

}




@end
