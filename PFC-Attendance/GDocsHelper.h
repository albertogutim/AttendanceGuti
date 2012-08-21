//
//  GDocsHelper.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 03/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Headers/GData.h"

@class GDocsHelper;

@protocol GDocsHelperDelegate <NSObject> 

@optional
- (void)respuesta:(NSDictionary *)feed error:(NSError *)error;
- (void)respuestaConColumna:(NSMutableDictionary *) feed enColumna: (NSInteger) columna error: (NSError *) error;
- (void)respuestaFechasValidas:(NSArray *) fechas error: (NSError *) error;
@end


@interface GDocsHelper : NSObject

+(GDocsHelper *)sharedInstance;
-(void)createSpreadsheetService;
-(void)credentialsWithUsr:(NSString *)newUsr andPwd:(NSString *)newPwd;
-(void)listadoAsignaturas;
-(void)listadoAsignaturasTicket: (GDataServiceTicket *) ticket
                 finishedWithFeed: (GDataFeedSpreadsheet *) feed
                            error: (NSError *) error;

-(void)listadoClasesAsignatura:(NSString *)asignatura;
-(void)listadoClasesAsignaturaTicket:(GDataServiceTicket *)ticket
                     finishedWithFeed:(GDataFeedWorksheet *)feed
                                error:(NSError *)error;

-(void)fechasValidasPara:(NSString *)miClase;
- (void)fechasValidasParaTicket:(GDataServiceTicket *)ticket
                   finishedWithFeed:(GDataFeedBase *)feed
                              error:(NSError *)error;

- (void)listadoAlumnosClase:(NSString *)clase paraFecha:(NSDate *)newFecha paraEstadosPorDefecto:(BOOL) estados;
- (void)consultaFechasTicket:
    (GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedBase *)feed
                       error:(NSError *)error;
- (void)columnaConFechaDeHoyCreada:(GDataServiceTicket *)ticket
                  finishedWithFeed:(GDataFeedBase *)feed
                             error:(NSError *)errror;

- (void)listadoAlumnosConEstadoClaseTicket:(GDataServiceTicket *)ticket
                          finishedWithFeed:(GDataFeedBase *)feed
                                     error:(NSError *)error;

- (void)insertCellsTicket:(GDataServiceTicket *)ticket
         finishedWithFeed:(GDataFeedBase *)feed
                    error:(NSError *)error;

- (void)insertedCellsTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedBase *)feed
                      error:(NSError *)error;

- (void)listadoEstadosAlumnosTicket:(GDataServiceTicket *)ticket
                   finishedWithFeed:(GDataFeedBase *)feed
                              error:(NSError *)error;



- (void)updateAlumnosConEstados:(NSString *)clase paraUpdate: (NSDictionary *) listaAlumnosEstados paraColumna:(NSInteger)col;
- (void)updateAlumnosConEstadosTicket:(GDataServiceTicket *)ticket
                     finishedWithFeed:(GDataFeedBase *)feed
                                error:(NSError *)error;
- (void)updateCellsTicket:(GDataServiceTicket *)ticket
         finishedWithFeed:(GDataFeedBase *)feed
                    error:(NSError *)error;
- (void)updatedCellsTicket:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedBase *)feed
                     error:(NSError *)error;


-(int)compareDay:(NSDate *)date1 withDay:(NSDate *)date2;


@property(nonatomic,strong) GDataServiceGoogleSpreadsheet *miService;
@property (nonatomic, strong) GDataFeedSpreadsheet *mSpreadsheetFeed;
@property (nonatomic, strong) GDataFeedWorksheet *mWorksheetFeed;
@property (nonatomic, strong) GDataFeedBase *mListCells;
@property (nonatomic, strong) GDataFeedBase *mListFechas;
@property (nonatomic, strong) GDataEntryWorksheet *miClaseWs;

@property (nonatomic, weak) id <GDocsHelperDelegate> delegate;

@property (nonatomic, strong) NSDictionary *mListSpreadsheetId;
@property (nonatomic, strong) NSDictionary *mListWorksheetId;

@property (nonatomic, assign) BOOL estados;
@property (nonatomic, assign) BOOL encontrada;
@property (nonatomic, assign) NSInteger columna;

@property (nonatomic, strong) NSDate *fecha;
@property (nonatomic, strong) NSString *clase;
@property (nonatomic, strong) NSArray *alumnos;
@property (nonatomic, strong) NSDictionary *update;
@property (nonatomic, strong) NSString *eTag;
@property (nonatomic, strong) NSArray *updatedEntries;
@property (nonatomic, strong) NSMutableDictionary *listaCsStado;


@end
