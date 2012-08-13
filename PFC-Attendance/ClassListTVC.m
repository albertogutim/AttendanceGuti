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
    self.title = NSLocalizedString(@"CLASS_TITLE", nil);

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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     self.clase= [self.miListaClases.allKeys objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"goToAsistenciaAlumnos" sender:self];
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
    
    if ([[segue identifier] isEqualToString:@"goToAsistenciaAlumnos"])
    {
        
        //cuando el usuario selecciona una clase se le pasa el id de la misma al viewcontroller siguiente
        
        
        AttendanceStudentsVC *attendanceStudentView = [segue destinationViewController];
        attendanceStudentView.clase = self.clase;
    
        
        
        
    }
}




@end
