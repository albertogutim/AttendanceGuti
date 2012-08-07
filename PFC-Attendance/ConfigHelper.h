//
//  ConfigHelper.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigHelper : NSObject

+(ConfigHelper *)sharedInstance;
-(void) inicializarValoresDefecto;
-(void) guardarCredenciales: (NSString *) user 
                       pass: (NSString *) password;
-(void) resetearCredenciales; 
-(BOOL)hasCredentials;

@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *password;

@property (assign, nonatomic) int retrasos;
@property (assign, nonatomic) int ausencias;
@property (assign, nonatomic) BOOL presentesDefecto;
@end
