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
- (void)respuestaConColumna:(NSMutableDictionary *) feed alumnosConOrden: (NSMutableDictionary *) alumnosConOrden enColumna: (NSInteger) columna error: (NSError *) error;
- (void)respuestaFechasValidas:(NSArray *) fechas error: (NSError *) error;
- (void)respuestaUpdate: (NSError *) error;
- (void)respuestaNewStudent: (NSError *) error;
- (void)respuestaInsertResumen: (NSError *) error;
- (void)respuestaExisteResumen: (BOOL) existe resumen: (NSString*) resumen error: (NSError *) error;
- (void)respuestaAusencias:(NSMutableDictionary *)feed arrayFechas:(NSMutableArray *) arrayFechas error:(NSError *)error;
- (void)respuestaEstadisticas:(NSMutableArray *)ausentes yRetrasados: (NSMutableArray *) retrasados todos:(NSMutableArray *) todos error:(NSError *)error;


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

- (void)introducirFormulasTicket:(GDataServiceTicket *)ticket
                finishedWithFeed:(GDataFeedBase *)feed
                           error:(NSError *)error;
- (void)columnaConFechaDeHoyCreada:(GDataServiceTicket *)ticket
                  finishedWithFeed:(GDataFeedBase *)feed
                             error:(NSError *)errror;

- (void)listadoAlumnosConEstadoClaseTicket:(GDataServiceTicket *)ticket
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


- (void)addStudent:(NSString *)clase paraColumna:(NSInteger) col conNombre: (NSString*) nombre paraEstadosPorDefecto: (BOOL)estados conEmail: (NSString*) mail;

- (void)addStudentTicket:(GDataServiceTicket *)ticket
        finishedWithFeed:(GDataFeedBase *)feed
                   error:(NSError *)error;

- (void)insertedStudentTicket:(GDataServiceTicket *)ticket
             finishedWithFeed:(GDataFeedBase *)feed
                        error:(NSError *)error;

- (void)insertStateStudentTicket:(GDataServiceTicket *)ticket
                finishedWithFeed:(GDataFeedBase *)feed
                           error:(NSError *)error;

- (void)insertedStateStudentTicket:(GDataServiceTicket *)ticket
                  finishedWithFeed:(GDataFeedBase *)feed
                             error:(NSError *)error;

- (void)insertePastStateStudentTicket:(GDataServiceTicket *)ticket
                     finishedWithFeed:(GDataFeedBase *)feed
                                error:(NSError *)error;

- (void)insertResumen:(NSString *)clase paraColumna:(NSInteger)columna conResumen:(NSString *)resumen;

- (void)insertResumenTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedBase *)feed
                      error:(NSError *)error;
- (void)existeResumen:(NSString *)clase paraColumna:(NSInteger)columna;

- (void)existeResumenTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedBase *)feed
                      error:(NSError *)error;

- (void)updateResumen:(NSString *)clase paraColumna:(NSInteger)columna conResumen: (NSString *) resumen;
- (void)updateResumenTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedBase *)feed
                      error:(NSError *)error;

- (void)updatedResumenTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedBase *)feed
                       error:(NSError *)error;

- (void)listadoAlumnos:(NSString *)clase;
- (void)listadoAlumnosConEmail:(GDataServiceTicket *)ticket
              finishedWithFeed:(GDataFeedBase *)feed
                         error:(NSError *)error;
- (void)listadoAlumnosConEmailTicket:(GDataServiceTicket *)ticket
                    finishedWithFeed:(GDataFeedBase *)feed
                               error:(NSError *)error;

- (void)listadoFechasConAsistencia:(NSString *)clase paraAlumno:(NSString *)alumno conRow: (NSInteger) row;
- (void)listadoFechasConAsistenciaTicket:(GDataServiceTicket *)ticket
                        finishedWithFeed:(GDataFeedBase *)feed
                                   error:(NSError *)error;
- (void)listadoAsistenciasConFechasTicket:(GDataServiceTicket *)ticket
                         finishedWithFeed:(GDataFeedBase *)feed
                                    error:(NSError *)error;
- (void)eliminarAlumno:(NSString *)clase paraRow:(NSInteger)row;

- (void)alumnoEliminadoTicket:(GDataServiceTicket *)ticket
             finishedWithFeed:(GDataFeedBase *)feed
                        error:(NSError *)error;

- (void)alumnoEliminadoSITicket:(GDataServiceTicket *)ticket
               finishedWithFeed:(GDataFeedBase *)feed
                          error:(NSError *)error;

- (void)obtenerEstadisticasTodos:(NSString *)clase paraAlumnosAusentes: (NSArray *) rowsAusentes yParaAlumnosRetrasados: (NSArray *) rowsRetrasados paraTodos: (BOOL) todos;
- (void)obtenerEstadisticasTodosTicket:(GDataServiceTicket *)ticket
                      finishedWithFeed:(GDataFeedBase *)feed
                                 error:(NSError *)error;


- (void)updateNombreAlumno:(NSString *)clase paraRow:(NSInteger)row paraNombre: (NSString *) nombre paraMail: (NSString*) mail;
- (void)updateNombreAlumnoTicket:(GDataServiceTicket *)ticket
                finishedWithFeed:(GDataFeedBase *)feed
                           error:(NSError *)error;

- (void)updateNombreAlumnoTicketDone:(GDataServiceTicket *)ticket
                    finishedWithFeed:(GDataFeedBase *)feed
                               error:(NSError *)error;

- (void)updateNombreAlumnoTicketDoneFin:(GDataServiceTicket *)ticket
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
@property (nonatomic, assign) BOOL paraTodos;
@property (nonatomic, assign) BOOL encontrada;
@property (nonatomic, assign) NSInteger columna;
@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) NSDate *fecha;
@property (nonatomic, strong) NSString *clase;
@property (nonatomic, strong) NSArray *alumnos;
@property (nonatomic, strong) NSDictionary *update;
@property (nonatomic, strong) NSString *eTag;
@property (nonatomic, strong) NSArray *updatedEntries;
@property (nonatomic, strong) NSMutableDictionary *listaCsStado;
@property (nonatomic, strong) NSMutableDictionary *alumnosConOrden;
@property (nonatomic, strong) NSString *studentName;
@property (nonatomic, strong) NSString *studentMail;
@property (nonatomic, strong) NSString *resumen;
@property (nonatomic, strong) NSArray *attendance;
@property (nonatomic, strong) NSArray *rowsAusentes;
@property (nonatomic, strong) NSArray *rowsRetrasados;
@property (nonatomic, strong) NSString *nombre;
@property (nonatomic, strong) NSString *mail;



@end
