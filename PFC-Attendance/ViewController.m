//
//  ViewController.m
//  PFC-Attendance
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "../Headers/GData.h"

@implementation ViewController
@synthesize miVistaTunning = _miVistaTunning;
@synthesize infoLbl = _infoLbl;
@synthesize activity = _activity;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Cargamos un NIB con la jerarquía de vistas para el custom ButtonItem
    [[NSBundle mainBundle] loadNibNamed:@"vistaConexion" owner:self options:nil];
    
}



- (void)viewDidUnload
{
    [self setMiVistaTunning:nil];
    [self setInfoLbl:nil];
    [self setActivity:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
        
    [super viewWillAppear:animated];
    
    __weak NSArray *elementosToolbar = [self toolbarItems];
    
    UIBarButtonItem *botonTunning = [[UIBarButtonItem alloc] initWithCustomView:self.miVistaTunning];
    NSMutableArray *nuevosElementos = [NSMutableArray arrayWithCapacity:elementosToolbar.count+1];
    [nuevosElementos addObjectsFromArray:elementosToolbar];
    [nuevosElementos insertObject:botonTunning atIndex:1];
    [self setToolbarItems:nuevosElementos animated:YES];

    //TODO: Si hay credenciales activar rueda y poner "Conectando"
    [self.activity stopAnimating];
    [self.infoLbl setText:NSLocalizedString(@"NO_CREDENTIALS", nil)];
    
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

@end
