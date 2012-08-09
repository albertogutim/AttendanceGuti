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

@synthesize miTabla = _miTabla;
@synthesize clase = _clase;
@synthesize miListaAlumnos = _miListaAlumnos;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
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
    ConfigHelper *configH = [ConfigHelper sharedInstance];
   
    [midh listadoAlumnosClase:self.clase estadoDefault: configH.presentesDefecto];
       
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
    return [self.miListaAlumnos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
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
    return cell;
}


#pragma mark - My Methods

- (void)respuesta:(NSDictionary *) feed error: (NSError *) error

{
    self.miListaAlumnos = feed;
    [self.miTabla reloadData];
}


@end
