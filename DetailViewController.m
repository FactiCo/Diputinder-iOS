//
//  DetailViewController.m
//  Diputinder
//
//  Created by Carlos Castellanos on 29/04/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
{

    UIScrollView *scroll;
    AppDelegate *delegate;

}
- (void)viewDidLoad {
    //[super viewDidLoad];
      delegate= (AppDelegate*)[[UIApplication sharedApplication]delegate];
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.backgroundColor=[UIColor whiteColor];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.width+50)];
    if ([_data objectForKey:@"twitter"] !=NULL) {
    NSString *st=[NSString stringWithFormat:@"https://twitter.com/%@/profile_image?size=original",[_data objectForKey:@"twitter"]];

    img.image=[delegate.imgCache objectForKey:st];
    }
    // si no tienen tuiter XD
    else{
        if ([[_data objectForKey:@"gnero"] isEqualToString:@"M"]) {
            img.image=[UIImage imageNamed:@"h.jpg"];
        }
        else
            img.image=[UIImage imageNamed:@"m.jpg"];

    
    }
    
    /*******/
    
 
    if ([_data objectForKey:@"twitter"] !=NULL ) {
        
        if([[_data objectForKey:@"twitter"] isEqualToString:@"No se identificó"] ||[[_data objectForKey:@"twitter"] isEqualToString:@"No tiene twitter"])
        {
            // son tan pendejos que le ponen no tiene tuiter
            if ([[_data objectForKey:@"gnero"] isEqualToString:@"M"]) {
                img.image=[UIImage imageNamed:@"h.jpg"];
            }
            else
                img.image=[UIImage imageNamed:@"m.jpg"];
        }
        else{
            if([[_data objectForKey:@"apellidoPaterno"]isEqualToString:@"Doring"]|| [[_data objectForKey:@"nombres"]isEqualToString:@"Dora Elia"])
            {
                NSLog( @"encontre a este puto ");
            }
            NSString *tw=[[_data objectForKey:@"twitter"] stringByReplacingOccurrencesOfString: @"\n" withString: @""];
            NSString *st=[NSString stringWithFormat:@"https://twitter.com/%@/profile_image?size=original",tw];
            
            // buscamos la img en cache y si no pues la descargamos
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage *imgAux2=[self buscarCache:st];
                if (imgAux2==nil) {
                    UIImage *tmp= [self descargarImg:st];
                    [delegate.imgCache setObject: tmp forKey: st];
                    
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                    
                    img.image=[self buscarCache:st];
                }];
                
                
            });}
        
        
        
    }else{
        
        if ([[_data objectForKey:@"gnero"] isEqualToString:@"M"]) {
            img.image=[UIImage imageNamed:@"h.jpg"];
        }
        else
            img.image=[UIImage imageNamed:@"m.jpg"];
        
    }
    /*********/
    [scroll addSubview:img];
   
    
    
    // datos debajo de la foto
    UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(15, img.frame.origin.y+img.frame.size.height+10, self.view.frame.size.width-30, 150)];
    name.numberOfLines=3;
    [name setFont:[UIFont systemFontOfSize:20]];
    name.backgroundColor=[UIColor clearColor];
    name.text=[NSString stringWithFormat:@"%@ %@ %@",[_data objectForKey:@"nombres"],[_data objectForKey:@"apellidoPaterno"],[_data objectForKey:@"apellidoMaterno"]];
     [name sizeToFit];
    [scroll addSubview:name];
    
    UILabel *puesto=[[UILabel alloc] initWithFrame:CGRectMake(15, name.frame.size.height+ name.frame.origin.y, self.view.frame.size.width-30, 50)];
    
    puesto.backgroundColor=[UIColor redColor];
    puesto.text=[_data objectForKey:@"puesto"];
    [scroll addSubview:puesto];
    
     [self.view addSubview:scroll];
    self.view.backgroundColor=[UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/***************************************/
/*  Codigo para cache de imagenes      */
/***************************************/
-(UIImage *)buscarCache:(NSString *)url {
    UIImage *img=[delegate.imgCache objectForKey:url];
    return img;
}



-(UIImage *)descargarImg:(NSString *)url {
    UIImage *tmp;
    NSLog(@"%@",url);
    if([[url substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]){
        
        tmp =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: url]]];
        while (tmp==nil) {
            tmp=[UIImage imageNamed:@"h.jpg"];
            
        }
    }
    else{
        tmp=[UIImage imageNamed:@"h.jpg"];
    }
    
    return tmp;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
