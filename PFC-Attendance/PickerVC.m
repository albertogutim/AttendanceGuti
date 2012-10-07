//
//  PickerVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickerVC.h"
#import "GDocsHelper.h"
#import "ConfigHelper.h"

@implementation PickerVC
@synthesize fechas = _fechas;
@synthesize miPicker = _miPicker;
@synthesize clase = _clase;
@synthesize fecha = _fecha;
@synthesize today = _today;


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
    
    
}


- (void)viewDidUnload
{
    [self setMiPicker:nil];
    [super viewDidUnload];
    self.fechas = nil;
    GDocsHelper *dh = [GDocsHelper sharedInstance];
    dh.delegate = nil;
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    GDocsHelper *dh = [GDocsHelper sharedInstance];
    [dh fechasValidasPara:self.clase];
    dh.delegate = self;
    
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Picker DataSource methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.fechas count];
}

#pragma mark Picker Delegate methods
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.fechas objectAtIndex:row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *fechCad = [self.fechas objectAtIndex:row];
    
    if([fechCad isEqualToString:NSLocalizedString(@"TODAY", nil)])
        self.fecha = self.today;
    else
    {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        //[df setDateFormat:@"dd/MM/yy"];
        NSDate *nuevaFecha = [df dateFromString:fechCad];
        
        
        self.fecha = nuevaFecha;
    }
    
    /*UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Picker"
     message:[NSString stringWithFormat:@"fecha: %@", nuevaFecha]
     delegate:self
     cancelButtonTitle:@"Dismiss"
     otherButtonTitles:nil];
     
     [alertView show];
     */
    
    
    
}


#pragma mark My methods
- (void)respuestaFechasValidas:(NSArray *) fechas error: (NSError *) error {
    //TODO: Controlar error
    NSMutableArray *fechaLong = [NSMutableArray arrayWithCapacity:[fechas count]];
    BOOL encontradoHoy=NO;
    
    NSDateFormatter *dff = [NSDateFormatter new];
    [dff setTimeStyle:NSDateFormatterNoStyle];
    [dff setDateStyle:NSDateFormatterShortStyle];
    NSLocale *theLocalee = [NSLocale currentLocale];
    [dff setLocale:theLocalee];
    
    
    NSDate *today =[NSDate date];
    NSString *todayStr = [dff stringFromDate:today];
    [dff setTimeStyle:NSDateFormatterNoStyle];
    [dff setDateStyle:NSDateFormatterShortStyle];
    [dff setDateFormat:@"dd/MM/yy"];
    NSDate *todayOk = [dff dateFromString:todayStr];
    self.today = todayOk;
    
    for (NSString *fechCad in fechas) {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        //TODO: Ojo! Si pones el iPhone en inglés devuelve nil porque 13/08/02 se refiere al mes 13 y no existe obviamente.
        [df setDateFormat:@"dd/MM/yy"];
        NSDate *nuevaFecha = [df dateFromString:fechCad];
        
        //si encuentra la fecha de hoy
        if([todayOk isEqualToDate:nuevaFecha])
            encontradoHoy=YES;
        
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        
        [df setLocale:theLocale];
        //TODO: Como nuevaFecha vale nil peta al añadir a fechaLong un nil
        NSString *dateStr = [df stringFromDate:nuevaFecha];
        [fechaLong addObject:dateStr];
        
    }
    //si no encontro la fecha de hoy en el spreadsheet hay que añadirla al picker para que pueda seleccionarla y pasar lista.
    if(!encontradoHoy)
        [fechaLong addObject:NSLocalizedString(@"TODAY", nil)];
    self.fechas = fechaLong;
    
    if ([fechas count] !=0)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSDate *fechaDefecto = [df dateFromString:[self.fechas objectAtIndex:0]];
        
        self.fecha = fechaDefecto;//Le damos el valor de la primera fecha que sale por defecto que es siempre la primera de self.fechas.
    }
    else
        self.fecha = todayOk;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [self.miPicker reloadAllComponents];
}


//el usuario ha elegido fecha y quiere volver a la pantalla anterior
- (IBAction)aceptarFecha:(id)sender {
    
    [self.delegate devolverFecha:self didSelectDate:self.fecha hoyEs: self.today];
    
    
}

//el usuario no quiere elegir fecha y quiere volver a la pantalla anterior
- (IBAction)cancelarFecha:(id)sender {
    
    [self.delegate devolverFecha:self didSelectDate:nil hoyEs: self.today];
}
@end
