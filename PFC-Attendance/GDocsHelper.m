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


- (void)listadoAlumnosClase:(NSString *)clase paraFecha:(NSDate *)newFecha paraEstadosPorDefecto:(BOOL)estados;

{
    
    //guardamos fecha y estados para poder acceder desde el ticket.
    self.estados = estados;
    self.fecha = newFecha;
    
    //Primero buscamos la fecha para saber si existe
    self.miClaseWs = [self.mWorksheetFeed entryForIdentifier:clase];
    
    NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
    GDataQuerySpreadsheet *q = [GDataQuerySpreadsheet spreadsheetQueryWithFeedURL:feedURL];
    [q setMinimumColumn:4];
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
        
        
    } else { //Es la primera vez, y no existe ninguna fecha. Añadir fecha en el header
        
        //Creamos la fecha en español para el día de hoy
        //TODO: Generalizarlo para cualquier fecha
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        
        NSString *dateStr = [df stringFromDate:[NSDate date]];
       
        GDataSpreadsheetCell *newSC= [GDataSpreadsheetCell cellWithRow:1 column:4 inputString:dateStr numericValue:nil resultString:nil];
        GDataEntrySpreadsheetCell *newESC= [GDataEntrySpreadsheetCell spreadsheetCellEntryWithCell:newSC];
        
        NSURL *feedURL = [[self.miClaseWs cellsLink] URL];
        
        [self.miService fetchEntryByInsertingEntry:newESC forFeedURL:feedURL delegate:self didFinishSelector:@selector(consultaFechasTicketCrearPrimeraFechaRespuesta:finishedWithFeed:error:)];
        
        
    }
}



- (void)consultaFechasTicketCrearPrimeraFechaRespuesta:(GDataServiceTicket *)ticket
                             finishedWithFeed:(GDataFeedBase *)feed
                                        error:(NSError *)error {
    
    if (error) {
        //TODO: Avisar de fallo al crear la celda
    } else {
        NSLog(@"Se ha creado con éxito");

    }
        
}



- (void)listadoAlumnosClaseTicket:(GDataServiceTicket *)ticket
                     finishedWithFeed:(GDataFeedBase *)feed
                                error:(NSError *)error {


    self.mListCells = feed;

        
    NSMutableArray *listaCellFeeds = [NSMutableArray arrayWithCapacity: [[self.mListCells entries] count]];
    NSMutableArray *estados = [NSMutableArray arrayWithCapacity: [[self.mListCells entries] count]];

    for (GDataEntrySpreadsheetCell *cs in [self.mListCells entries]) {
        
        GDataSpreadsheetCell *theCell = [cs cell];
            
            [listaCellFeeds addObject:theCell.inputString];
        
            //TODO: controlar si hay que leer los estados porque existe la fecha o hay que cogerlos de los predeterminados.
            //Controlar estado predeterminado alumnos presentes
            if(self.estados)
                [estados addObject:[NSNumber numberWithInteger:1]];
            else
                [estados addObject:[NSNumber numberWithInteger:2]];

    }
     
    
    NSMutableDictionary *listaCsStado = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithArray:estados] forKeys:[NSArray arrayWithArray:listaCellFeeds]];
    
    NSDictionary * listaCellsStadoDictionary = [NSDictionary dictionaryWithDictionary:listaCsStado];
    self.mListWorksheetId = listaCellsStadoDictionary;
    [self.delegate respuesta: listaCellsStadoDictionary error:error];
    
    
}


@end

