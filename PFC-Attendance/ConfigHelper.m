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
    
    
    //Ahora inicializamos los NSUserDefaults (3) presentesDefecto, retrasos y ausencias si no existen.    

    
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];

    if ([settings objectForKey:@"presentesDefecto"] == nil) 
    {
        [settings setBool:YES forKey:@"presentesDefecto"]; //todos presentes por defecto
        [settings setInteger:0 forKey:@"retrasos"]; //0
        [settings setInteger:0 forKey:@"ausencias"];//0
    }
    
}



-(void) resetearCredenciales {
    
    //Borramos el usuario/contraseña guardado.
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppPassword" accessGroup:nil];
    [keychainItem resetKeychainItem];
}


-(void) guardarCredenciales: (NSString *) user 
                            pass: (NSString *) password {

    //Cuando el usuario quiere guardar sus datos para la proxima conexion.
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppPassword" accessGroup:nil];
    
    [keychainItem setObject:user  forKey:(__bridge id)kSecValueData];
    [keychainItem setObject:password  forKey:(__bridge id)kSecAttrAccount];
    
    self.user = user;
    self.password = password;

}


-(int)retrasos {
    
    //Obtener dato de NSUserDefaults
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];
    return [settings integerForKey:@"retrasos"];
    
}

-(void)setRetrasos:(int)retrasos {
    
    //Guardar dato en NSUserDefaults
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];
    [settings setInteger:retrasos forKey:@"retrasos"];
    
}

-(int) ausencias {

    //Obtener dato de NSUserDefaults
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];
    return [settings integerForKey:@"ausencias"];

}

-(void) setAusencias:(int)ausencias {

    //Guardar dato en NSUserDefaults
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];
    [settings setInteger:ausencias forKey:@"ausencias"];
    

}

-(BOOL) presentesDefecto {
    
    //Obtener dato de NSUserDefaults
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];
    return [settings boolForKey:@"presentesDefecto"];
}

-(void) setPresentesDefecto:(BOOL)presentesDefecto {
    
    //Guardar dato en NSUserDefaults
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];
    [settings setBool:presentesDefecto forKey:@"presentesDefecto"];

}




@end
