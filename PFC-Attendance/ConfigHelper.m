//
//  ConfigHelper.m
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigHelper.h"
#import "KeychainItemWrapper.h"

@implementation ConfigHelper
@synthesize user = _user;
@synthesize password = _password;



+(ConfigHelper *)sharedInstance {
    
    static ConfigHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance= [[ConfigHelper alloc]init];
        [sharedInstance inicializarValoresDefecto];
        
    });
    return sharedInstance;
}

-(void) inicializarValoresDefecto {

    //Accedemos a KeyChain para ver si hay usuario/contraseña guardados y copiarlos. Si no hay inicializamos a nil.
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppPassword" accessGroup:nil];
    NSString *password = [keychainItem objectForKey:(__bridge id)kSecValueData];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    
    if (([password length] != 0) && ([username length] != 0)) {
        
        self.user = username;
        self.password = password;
    }
    else
    {
        self.user = nil;
        self.password = nil;
    
    }
    
    
    //Ahora inicializamos los NSUserDefaults (3) presentesDefecto, retrasos, ausencias.
    
    
   [NSUserDefaults resetStandardUserDefaults];
    
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];

    if ([settings objectForKey:@"presentesDefecto"] == nil) 
    {
        [settings setBool:YES forKey:@"presentesDefecto"]; //todos presentes por defecto
        [settings setDouble:0 forKey:@"retrasos"]; //0
        [settings setDouble:0 forKey:@"ausencias"];//0
    }
    
}



-(void) resetearCredenciales {
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppPassword" accessGroup:nil];
    [keychainItem resetKeychainItem];
}

-(void) leerConfiguracion {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppPassword" accessGroup:nil];
    
    NSString *password = [keychainItem objectForKey:(__bridge id)kSecValueData];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    
    self.password = password;
    self.user = username;
    
    NSUserDefaults *NSUser =[NSUserDefaults standardUserDefaults];
    [NSUser boolForKey:@"presentesDefecto"];
    [NSUser doubleForKey:@"retrasos"];
    [NSUser doubleForKey:@"ausencias"];
   
    
}

-(void) guardarCredenciales: (NSString *) user 
                            pass: (NSString *) password {



}

-(void) guardar 
{

}



@end
