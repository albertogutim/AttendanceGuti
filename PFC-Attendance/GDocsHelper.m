//
//  GDocsHelper.m
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 03/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDocsHelper.h"
#import "../Headers/GData.h"
#import "../Headers/GDataSpreadsheet.h"
#define COLUMN_START 3
#define ROW_START 3
#define DATES_START 4
#define MAIL_COLUMN 2
#define STUDENTS_COLUMN 1

@implementation GDocsHelper
@synthesize miService = _miService;
@synthesize mSpreadsheetFeed =_mSpreadsheetFeed;
@synthesize delegate = _delegate;
@synthesize mWorksheetFeed = _mWorksheetFeed;
@synthesize mListSpreadsheetId = _mListSpreadsheetId;
@synthesize mListWorksheetId = _mListWorksheetId;
@synthesize mListCells = _mListCells;
@synthesize mListFechas = _mListFechas;
@synthesize miClaseWs = _miClaseWs;
@synthesize estados = _estados;
@synthesize fecha = _fecha;
@synthesize clase = _clase;
@synthesize encontrada = _encontrada;
@synthesize columna = _columna;
@synthesize alumnos = _alumnos;
@synthesize update =_update;
@synthesize eTag = _eTag;
@synthesize updatedEntries = _updatedEntries;
@synthesize listaCsStado =_listaCsStado;
@synthesize studentName = _studentName;
@synthesize studentMail = _studentMail;
@synthesize row = _row;





+(GDocsHelper *)sharedInstance {
    
    static GDocsHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance= [[GDocsHelper alloc]init];
        [sharedInstance createSpreadsheetService];
        
    });
    return sharedInstance;
}

- (void)createSpreadsheetService {
    
    self.miService = [[GDataServiceGoogleSpreadsheet alloc] init];
    [self.miService setShouldCacheResponseData:YES];
    [self.miService setServiceShouldFollowNextLinks:YES];
    
}

-(void)credentialsWithUsr:(NSString *)newUsr andPwd:(NSString *)newPwd{

    [self.miService setUserCredentialsWithUsername:newUsr
                                          password:newPwd];
    
}

- (void)listadoAsignaturas {
    
    
        
    
    NSURL *feedURL = [NSURL URLWithString: kGDataGoogleSpreadsheetsPrivateFullFeed];
    
    
    [self.miService fetchFeedWithURL:feedURL
                              delegate:self
                     didFinishSelector:@selector(listadoAsignaturasTicket:finishedWithFeed:error:)];
    
    
}



- (void) listadoAsignaturasTicket: (GDataServiceTicket *) ticket
finishedWithFeed: (GDataFeedSpreadsheet *)feed
          error: (NSError *) error {
    
    
    //NSLog(@"%@",[error description]);
    self.mSpreadsheetFeed = feed;
    
    
    /*GDataEntrySpreadsheet *doc = [[self.mSpreadsheetFeed entries] objectAtIndex:0];
    
    NSString *ttitle = [[doc title] stringValue];
    UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"primer doc"
                                                         message:[NSString stringWithFormat:@"titulo: %@", ttitle]
                                                        delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
    
    [alertView show];
    */
    
    
    //creamos una lista de feeds conteniendo solo las asignaturas que empiecen por AT_
    NSMutableArray *listaFeeds = [NSMutableArray arrayWithCapacity: [[self.mSpreadsheetFeed entries] count]];
    NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity: [[self.mSpreadsheetFeed entries] count]];
    NSInteger i = 0;
    for (GDataEntrySpreadsheet *ss in [self.mSpreadsheetFeed entries]) {
        
        if ([[[ss title] stringValue] hasPrefix:@"AT_"]) {
            
            NSString *cadCortada = [[[ss title] stringValue] substringFromIndex:3];
            [listaFeeds addObject:cadCortada];
            [identifiers addObject:[[[self.mSpreadsheetFeed entries]objectAtIndex:i] identifier]];
            
        }
        i++;
    }
    
     NSMutableDictionary *listaSsId = [NSMutableDictionary dictionaryWithObjects:listaFeeds forKeys:identifiers];
    
     NSDictionary * listaSsIdDictionary = [NSDictionary dictionaryWithDictionary:listaSsId];
    
     self.mListSpreadsheetId = listaSsIdDictionary;
     [self.delegate respuesta: listaSsIdDictionary error:error];
    
    //[self.delegate respuesta:[NSArray arrayWithArray:listaFeeds] error:error];
    //devolvemos un array.
     
}



- (void)listadoClasesAsignatura:(NSString *)asignatura
{
    
    
    GDataEntrySpreadsheet *ss = [self.mSpreadsheetFeed entryForIdentifier:asignatura];
    NSURL *f = [ss worksheetsFeedURL];
    
    
    [self.miService fetchFeedWithURL:f
                            delegate:self
                   didFinishSelector:@selector(listadoClasesAsignaturaTicket:finishedWithFeed:error:)];


}


- (void)listadoClasesAsignaturaTicket:(GDataServiceTicket *)ticket
        finishedWithFeed:(GDataFeedWorksheet *)feed
                   error:(NSError *)error {
    
    
    self.mWorksheetFeed = feed;
    
    
    /*NSArray *Worksheets = [feed entries];
    GDataEntryWorksheet *Worksheet = [Worksheets objectAtIndex:0];
    
    NSString *ttitleworksheet = [[Worksheet title] stringValue];
    UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"worksheet"
                                                         message:[NSString stringWithFormat:@"titulo: %@", ttitleworksheet]
                                                        delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
    
    [alertView show];*/
     
    
    NSMutableArray *listaWorksheetFeeds = [NSMutableArray arrayWithCapacity: [[self.mWorksheetFeed entries] count]];
    NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity: [[self.mWorksheetFeed entries] count]];
    NSInteger i = 0;
    for (GDataEntryWorksheet *ws in [self.mWorksheetFeed entries]) {
        
            [listaWorksheetFeeds addObject:[[ws title] stringValue]];
            [identifiers addObject:[[[self.mWorksheetFeed entries]objectAtIndex:i] identifier]];
            i++;
            
    }
    
    NSMutableDictionary *listaWsId = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithArray:listaWorksheetFeeds] forKeys:[NSArray arrayWithArray:identifiers]];
    
    NSDictionary * listaWsIdDictionary = [NSDictionary dictionaryWithDictionary:listaWsId];
    self.mListWorksheetId = listaWsIdDictionary;
    [self.delegate respuesta: listaWsIdDictionary error:error];
    
}


-(void)fechasValidasPara:(NSString *)miClase {
    
    
    //Primero buscamos la fecha para saber si existe
    self.miClaseWs = [self.mWorksheetFeed entryForIdentifier:miClase];
    
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    GDataQuerySpreadsheet *q = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
    [q setMinimumColumn:DATES_START];
    [q setMinimumRow:1];
    [q setMaximumRow:1];
    
    
    
    [self.miService fetchFeedWithQuery:q
                              delegate:self
                     didFinishSelector:@selector(fechasValidasParaTicket:finishedWithFeed:error:)];
    
    
}


- (void)fechasValidasParaTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedBase *)feed
                       error:(NSError *)error {
    
    
    if ([[feed entries] count]) {
        
        NSMutableArray *fechasValidas = [NSMutableArray arrayWithCapacity:[[feed entries] count]];
        for (GDataEntrySpreadsheetCell *cs in [feed entries]) {
            
            GDataSpreadsheetCell *theCell = [cs cell];
            
            [fechasValidas addObject:theCell.inputString];
        }

        
        [self.delegate respuestaFechasValidas:[NSArray arrayWithArray:fechasValidas] error:error];
        
        
    } else {
        
        //Si no hay ninguna es la primera vez y devolvemos nil
        [self.delegate respuestaFechasValidas:nil error:error];
    }
    
}


- (void)listadoAlumnosClase:(NSString *)clase paraFecha:(NSDate *)newFecha paraEstadosPorDefecto:(BOOL)estados;

{
    
    //guardamos fecha y estados para poder acceder desde el ticket.
    self.estados = estados;
    self.fecha = newFecha;
    self.clase = clase;
    
    //Primero buscamos la fecha para saber si existe
    //TO DO: Controlar error si no existe el identifier
    self.miClaseWs = [self.mWorksheetFeed entryForIdentifier:clase];
    
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    GDataQuerySpreadsheet *q = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
    [q setMinimumColumn:DATES_START];
    [q setMinimumRow:1];
    [q setMaximumRow:1];
    
    
    
    [self.miService fetchFeedWithQuery:q
                     delegate:self
            didFinishSelector:@selector(consultaFechasTicket:finishedWithFeed:error:)];

    
}

- (void)consultaFechasTicket:(GDataServiceTicket *)ticket
                 finishedWithFeed:(GDataFeedBase *)feed
                            error:(NSError *)error {
    
    
    if ([[feed entries] count]) {
        //TODO: Buscar fecha
        self.mListFechas = feed;
        self.encontrada=NO;
        NSInteger col = 1;
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        
        for (GDataEntrySpreadsheetCell *fech in [self.mListFechas entries]) {
            
            GDataSpreadsheetCell *theCell = [fech cell];
            NSDate *nuevaFecha = [df dateFromString:theCell.inputString];
            if([nuevaFecha isEqualToDate:self.fecha])
            //if([self compareDay: nuevaFecha withDay:self.fecha] == 0)
            {
                //NSLog(@"Se compara bien la fecha");
            //encontro la fecha seleccionada en la spreadsheet. Hay que devolver la lista de alumnos y sus estados
                self.encontrada = YES;
                self.columna = COLUMN_START+col;
                
                self.miClaseWs = [self.mWorksheetFeed entryForIdentifier:self.clase];
                
                NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
                GDataQuerySpreadsheet *q = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
                [q setMinimumColumn:STUDENTS_COLUMN]; 
                [q setMaximumColumn:STUDENTS_COLUMN]; 
                [q setMinimumRow:ROW_START];
                
                
                [self.miService fetchFeedWithQuery:q
                                          delegate:self
                                 didFinishSelector:@selector(listadoAlumnosConEstadoClaseTicket:finishedWithFeed:error:)];
                break; //Si ya la has encontrado no sigas buscando!
                
            }
            col++;
        }
        // si despues de la búsqueda no encontró la fecha significa q es el día de hoy. hay que crear la columna con la fecha y los estados por defecto.
        if (!self.encontrada)
        {
           // NSLog(@"no encontrada es el dia de hoy");

            NSDateFormatter *df = [NSDateFormatter new];
            [df setTimeStyle:NSDateFormatterNoStyle];
            [df setDateStyle:NSDateFormatterShortStyle];
            NSLocale *theLocale = [NSLocale currentLocale];
            [df setLocale:theLocale];
            
            
            NSDate *d =[NSDate date];
            NSString *dateStr = [df stringFromDate:d];
            self.columna = [[feed entries] count]+DATES_START;
            
            GDataSpreadsheetCell *newSC= [GDataSpreadsheetCell cellWithRow:1 column:[[feed entries] count]+DATES_START inputString:dateStr numericValue:nil resultString:nil];
            GDataEntrySpreadsheetCell *newESC= [GDataEntrySpreadsheetCell spreadsheetCellEntryWithCell:newSC];
            
            NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
            
            [self.miService fetchEntryByInsertingEntry:newESC forFeedURL:feedURL delegate:self didFinishSelector:@selector(columnaConFechaDeHoyCreada:finishedWithFeed:error:)];
        }
        
    } else { //Es la primera vez, y no existe ninguna fecha. Añadir fecha en el header
        
        //Creamos la fecha en español para el día de hoy
        //TODO: Generalizarlo para cualquier fecha
        self.encontrada=NO;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"dd/MM/yy"];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        
        self.columna = DATES_START;
        
        NSDate *d =[NSDate date];
        NSString *dateStr = [df stringFromDate:d];
       
        GDataSpreadsheetCell *newSC= [GDataSpreadsheetCell cellWithRow:1 column:DATES_START inputString:dateStr numericValue:nil resultString:nil];
        GDataEntrySpreadsheetCell *newESC= [GDataEntrySpreadsheetCell spreadsheetCellEntryWithCell:newSC];
        
        NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
        
        [self.miService fetchEntryByInsertingEntry:newESC forFeedURL:feedURL delegate:self didFinishSelector:@selector(columnaConFechaDeHoyCreada:finishedWithFeed:error:)];
        
        
    }
}



- (void)columnaConFechaDeHoyCreada:(GDataServiceTicket *)ticket
                             finishedWithFeed:(GDataFeedBase *)feed
                                        error:(NSError *)error {
    
    
    //aqui llegamos despues de crear una columna nueva con la fecha de hoy. O bien porque es la primera vez que usamos la aplicacion y no hay ninguna fecha o bien porque queremos pasar asistencia para el dia de hoy y ya habia mas fechas. Tenemos que acceder a la lista de alumnos y asignarles el estado por defecto porque no estaba creada esta fecha.
    if (error) {
        //TODO: Avisar de fallo al crear la celda
    } else {
        //NSLog(@"Se ha creado con éxito");
        
        //query para buscar los alumnos
        self.miClaseWs = [self.mWorksheetFeed entryForIdentifier:self.clase];
        
        NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
        GDataQuerySpreadsheet *q = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
        [q setMinimumColumn:STUDENTS_COLUMN];
        [q setMaximumColumn:STUDENTS_COLUMN];
        [q setMinimumRow:ROW_START];
   
        
        [self.miService fetchFeedWithQuery:q
                                  delegate:self
                         didFinishSelector:@selector(listadoAlumnosConEstadoClaseTicket:finishedWithFeed:error:)];
        

    }
        
}


- (void)listadoAlumnosConEstadoClaseTicket:(GDataServiceTicket *)ticket
                     finishedWithFeed:(GDataFeedBase *)feed
                                error:(NSError *)error {


    self.mListCells = feed;

        
    NSMutableArray *listaCellFeeds = [NSMutableArray arrayWithCapacity: [[self.mListCells entries] count]];
    NSMutableArray *estados = [NSMutableArray arrayWithCapacity: [[self.mListCells entries] count]];

    for (GDataEntrySpreadsheetCell *cs in [self.mListCells entries]) {
        
        GDataSpreadsheetCell *theCell = [cs cell];
            
            [listaCellFeeds addObject:theCell.inputString];
        
            if(!self.encontrada){
                if(self.estados)
                    //[estados addObject:[NSNumber numberWithInteger:1]];
                    [estados addObject:@"1"];
                else
                    //[estados addObject:[NSNumber numberWithInteger:2]];
                    [estados addObject:@"2"];
            
            }
    }
    
    if(!self.encontrada){
    NSMutableDictionary *listaCsStado = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithArray:estados] forKeys:[NSArray arrayWithArray:listaCellFeeds]];
    
    NSDictionary * listaCellsStadoDictionary = [NSDictionary dictionaryWithDictionary:listaCsStado];
    self.mListWorksheetId = listaCellsStadoDictionary;
    self.alumnos = [NSArray arrayWithArray:listaCellFeeds];
    self.listaCsStado = listaCsStado;
        //Guardar en la spreadsheet los estados.
        //AQUÍ OCURRE LA CHAPUZA DEL INSERT DE LOS ESTADOS DE UN DÍA NUEVO
    
        NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
        NSString *e = [NSString string];
        if(self.estados)
            e = @"1";
        else
            e = @"2";

        for (int i=0; i<[self.alumnos count]; i++) {
            GDataSpreadsheetCell *newSC= [GDataSpreadsheetCell cellWithRow:i+ROW_START column:self.columna inputString:e numericValue:nil resultString:nil];
            GDataEntrySpreadsheetCell *newESC= [GDataEntrySpreadsheetCell spreadsheetCellEntryWithCell:newSC];
            
            
            [self.miService fetchEntryByInsertingEntry:newESC forFeedURL:feedURL delegate:self didFinishSelector:@selector(insertedCellsTicket:finishedWithFeed:error:)];
           
        }
        

        [self.delegate respuestaConColumna: self.listaCsStado enColumna: self.columna error:error];

        
    
    }
    else{
        self.alumnos = [NSArray arrayWithArray:listaCellFeeds];
        self.miClaseWs = [self.mWorksheetFeed entryForIdentifier:self.clase];
        
        NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
        GDataQuerySpreadsheet *q = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
        [q setMinimumColumn:self.columna];
        [q setMaximumColumn:self.columna];
        [q setMinimumRow:ROW_START];
        
        
        [self.miService fetchFeedWithQuery:q
                                  delegate:self
                         didFinishSelector:@selector(listadoEstadosAlumnosTicket:finishedWithFeed:error:)];
    }
    
   
}
   

- (void)listadoEstadosAlumnosTicket:(GDataServiceTicket *)ticket
                          finishedWithFeed:(GDataFeedBase *)feed
                                     error:(NSError *)error {


    NSMutableArray *estados = [NSMutableArray arrayWithCapacity: [[feed entries] count]];
    
    for (GDataEntrySpreadsheetCell *cs in [feed entries]) {
        
        GDataSpreadsheetCell *theCell = [cs cell];
        
        [estados addObject:theCell.inputString];
    }

    
    NSMutableDictionary *listaCsStado = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithArray:estados] forKeys:self.alumnos];
    
    NSDictionary * listaCellsStadoDictionary = [NSDictionary dictionaryWithDictionary:listaCsStado];
    self.mListWorksheetId = listaCellsStadoDictionary;
    [self.delegate respuestaConColumna: listaCsStado enColumna: self.columna error:error];

}

- (void)insertedCellsTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedBase *)feed
                      error:(NSError *)error
{
    //NSLog(@"termino el insert");
    if (error)
        NSLog(@"ocurrió un error en la inserción de celdas");
    
}


- (void)updateAlumnosConEstados:(NSString *)clase paraUpdate: (NSDictionary *) listaAlumnosEstados paraColumna:(NSInteger)col
{
    self.update = listaAlumnosEstados;
    self.columna = col;
    self.clase = clase;
    self.miClaseWs = [self.mWorksheetFeed entryForIdentifier:clase];
    
    
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    GDataQuerySpreadsheet *q = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
    [q setMinimumColumn:col];
    [q setMaximumColumn:col];
    [q setMinimumRow:ROW_START];
    
    
    [self.miService fetchFeedWithQuery:q
                              delegate:self
                     didFinishSelector:@selector(updateAlumnosConEstadosTicket:finishedWithFeed:error:)];
    
}

- (void)updateAlumnosConEstadosTicket:(GDataServiceTicket *)ticket
                     finishedWithFeed:(GDataFeedBase *)feed
                                error:(NSError *)error

{
    
    //Es necesario utilizar self.alumnos, donde estan guardados los nombres en el mismo orden que estan en la spreadsheet porque el NSDictionary cambia el orden al rellenarlo.
    NSMutableArray *nuevosEstados = [NSMutableArray arrayWithCapacity:[self.alumnos count]];
    for (int j=0; j<[self.alumnos count]; j++) {
        NSInteger i=0;
        for (GDataEntrySpreadsheetCell *cs in [feed entries]) {
            
            if([[self.alumnos objectAtIndex:j] isEqualToString:[self.update.allKeys objectAtIndex:i]])
            {
                //nos vamos creando un array nuevo con los estados en orden
                [nuevosEstados addObject:[self.update.allValues objectAtIndex:i]];
                break;
            }
            
            i++;
        }
    }
    NSInteger h=0;
    for (GDataEntrySpreadsheetCell *cs in [feed entries]) {
        
        //recorremos por orden las celdas y vamos leyendo del array con los estados en orden.
        [[cs cell] setInputString:[nuevosEstados objectAtIndex:h]];
        h++;
        
    }
    
    NSString *eTag = feed.ETag;
    self.eTag = eTag;
    
    NSArray *updatedEntries = [feed entries];
    self.updatedEntries = updatedEntries;
    
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    [self.miService fetchFeedWithURL:feedURL
                            delegate:self
                   didFinishSelector:@selector(updateCellsTicket:finishedWithFeed:error:)];
    
    
}



- (void)updateCellsTicket:(GDataServiceTicket *)ticket
         finishedWithFeed:(GDataFeedBase *)feed
                    error:(NSError *)error{
    
    
    NSURL *batchUrl = [[feed batchLink] URL];
    GDataFeedSpreadsheetCell *batchFeed = [GDataFeedSpreadsheetCell spreadsheetCellFeed];
    
    [batchFeed setEntriesWithEntries:self.updatedEntries];
    
    GDataBatchOperation *op;
    op = [GDataBatchOperation batchOperationWithType:kGDataBatchOperationUpdate];
    [batchFeed setBatchOperation:op];
    [batchFeed setETag:self.eTag];
    
    [self.miService fetchFeedWithBatchFeed:batchFeed forBatchFeedURL:batchUrl delegate:self didFinishSelector:@selector(updatedCellsTicket:finishedWithFeed:error:)];
}

- (void)updatedCellsTicket:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedBase *)feed
                     error:(NSError *)error
{
    //NSLog(@"termino el update");
    [self.delegate respuestaUpdate: error];
    
}



- (void)addStudent:(NSString *)clase paraColumna:(NSInteger) col conNombre: (NSString*) nombre paraEstadosPorDefecto: (BOOL)estados conEmail: (NSString*) mail
{
    //Vamos añadir un nuevo alumno con su mail y su estado predeterminado.
    
    
    self.estados = estados;
    self.columna = col;
    self.clase = clase;
    self.studentName = nombre;
    self.studentMail = mail;
    
    self.miClaseWs = [self.mWorksheetFeed entryForIdentifier:clase];
    
    
    //query para coger solo los nombres de los alumnos
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    GDataQuerySpreadsheet *q = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
    [q setMinimumColumn:STUDENTS_COLUMN];
    [q setMaximumColumn:STUDENTS_COLUMN];
    [q setMinimumRow:ROW_START];
    
    
    
    [self.miService fetchFeedWithQuery:q
                              delegate:self
                     didFinishSelector:@selector(addStudentTicket:finishedWithFeed:error:)];
    
}



- (void)addStudentTicket:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedBase *)feed
                     error:(NSError *)error
{
        
    //TODO: controlar errores

    
    self.row = [[feed entries] count] + ROW_START;
    GDataSpreadsheetCell *newSC= [GDataSpreadsheetCell cellWithRow:self.row column:1 inputString:self.studentName numericValue:nil resultString:nil];
    GDataEntrySpreadsheetCell *newESC= [GDataEntrySpreadsheetCell spreadsheetCellEntryWithCell:newSC];
    
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    
    [self.miService fetchEntryByInsertingEntry:newESC forFeedURL:feedURL delegate:self didFinishSelector:@selector(insertedStudentTicket:finishedWithFeed:error:)];
    
}

- (void)insertedStudentTicket:(GDataServiceTicket *)ticket
finishedWithFeed:(GDataFeedBase *)feed
          error:(NSError *)error
{
    //Ahora una vez tenemos insertado el nombre tenemos que insertar su estado
    //TODO: controlar errores
    NSString *e = [NSString string];
    if(self.estados)
        e = @"1";
    else
        e = @"2";
    
    GDataSpreadsheetCell *newSC= [GDataSpreadsheetCell cellWithRow:self.row column:self.columna inputString:e numericValue:nil resultString:nil];
    GDataEntrySpreadsheetCell *newESC= [GDataEntrySpreadsheetCell spreadsheetCellEntryWithCell:newSC];
    
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    
    [self.miService fetchEntryByInsertingEntry:newESC forFeedURL:feedURL delegate:self didFinishSelector:@selector(insertStateStudentTicket:finishedWithFeed:error:)];
    
    
}


- (void)insertStateStudentTicket:(GDataServiceTicket *)ticket
             finishedWithFeed:(GDataFeedBase *)feed
                        error:(NSError *)error
{

    
    //TODO: controlar errores
    //Ahora solo nos queda insertar el mail.
    
    GDataSpreadsheetCell *newSC= [GDataSpreadsheetCell cellWithRow:self.row column:MAIL_COLUMN inputString:self.studentMail numericValue:nil resultString:nil];
    GDataEntrySpreadsheetCell *newESC= [GDataEntrySpreadsheetCell spreadsheetCellEntryWithCell:newSC];
    
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    
    [self.miService fetchEntryByInsertingEntry:newESC forFeedURL:feedURL delegate:self didFinishSelector:@selector(insertedStateStudentTicket:finishedWithFeed:error:)];
    
}

- (void)insertedStateStudentTicket:(GDataServiceTicket *)ticket
                finishedWithFeed:(GDataFeedBase *)feed
                           error:(NSError *)error
{

    //TODO: controlar errores
    //Ya se subió todo a la spreadsheet.
    NSLog(@"Ya se subió todo a la spreadsheet");
    
    //ahora hay que compensar los días anteriores si los hubiera, poniendo un estado diferente
    //que no contabilizara para las estadisticas (-1).
    
        if (self.columna>DATES_START) //hay fechas anteriores
        {
            
            for (int i=DATES_START; i<self.columna; i++) {
                
                GDataSpreadsheetCell *newSC= [GDataSpreadsheetCell cellWithRow:self.row column:i inputString:@"-1" numericValue:nil resultString:nil];
                GDataEntrySpreadsheetCell *newESC= [GDataEntrySpreadsheetCell spreadsheetCellEntryWithCell:newSC];
                
                NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
                
                [self.miService fetchEntryByInsertingEntry:newESC forFeedURL:feedURL delegate:self didFinishSelector:@selector(insertePastStateStudentTicket:finishedWithFeed:error:)];
                
            }
            [self.delegate respuestaNewStudent: error];
        
        }
    else
        [self.delegate respuestaNewStudent: error];

}


- (void)insertePastStateStudentTicket:(GDataServiceTicket *)ticket
                  finishedWithFeed:(GDataFeedBase *)feed
                             error:(NSError *)error
{

//TODO: controlar error

}

//NSDate compara a nivel de milisegundo y sólo necesitamos que compare entre días.
//Devuelve -1 si es anterior, 1 si es posterior y 0 si es el mismo día
-(int)compareDay:(NSDate *)date1 withDay:(NSDate *)date2 {
    
    NSDateFormatter *yearDF = [[NSDateFormatter alloc] init];
    [yearDF setDateFormat:@"yyyy"];
    
    NSDateFormatter *monthDF = [[NSDateFormatter alloc] init];
    [monthDF setDateFormat:@"mm"];
    
    NSDateFormatter *dayDF = [[NSDateFormatter alloc] init];
    [dayDF setDateFormat:@"dd"];
    
    
    int year1 = [[yearDF stringFromDate:date1] intValue];
    int year2 = [[yearDF stringFromDate:date2] intValue];
    
    if (year1 < year2) {
        
        return -1;
        
    }
    if (year1 > year2) {
        
        return 1;
        
    }
    //Mismo año, comprobamos el mes
    int month1 = [[monthDF stringFromDate:date1] intValue];
    int month2 = [[monthDF stringFromDate:date2] intValue];
    
    if (month1 < month2) {
        
        return -1;
        
    }
    if (month1 > month2) {
        
        return 1;
        
    }
    //Mismo mes, comprobamos día
    int day1 = [[dayDF stringFromDate:date1] intValue];
    int day2 = [[dayDF stringFromDate:date2] intValue];
    
    if (day1 < day2) {
        
        return -1;
        
    }
    if (day1 > day2) {
        
        return 1;
        
    }
    return 0; //es el mismo día

}


@end

