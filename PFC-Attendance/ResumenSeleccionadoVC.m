//
//  ResumenSeleccionadoVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 13/09/12.
//
//

#import "ResumenSeleccionadoVC.h"

@interface ResumenSeleccionadoVC ()

@end

@implementation ResumenSeleccionadoVC

@synthesize nombreAsignatura = _nombreAsignatura;
@synthesize nombreClase = _nombreClase;
@synthesize fechaResumen = _fechaResumen;
@synthesize resumenSeleccionado = _resumenSeleccionado;
@synthesize nombreAsignaturaGrupolbl = _nombreAsignaturaGrupolbl;
@synthesize fechalbl = _fechalbl;
@synthesize resumenView = _resumenView;

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
    [self setNombreAsignaturaGrupolbl:nil];
    [self setFechalbl:nil];
    [self setResumenView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.resumenView.text = self.resumenSeleccionado;
    self.nombreAsignaturaGrupolbl.text = [NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase];
    self.fechalbl.text = self.fechaResumen;
    
    [super viewWillAppear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
