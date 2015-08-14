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
      self.navigationItem.title=@"Información";
    //[super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
      delegate= (AppDelegate*)[[UIApplication sharedApplication]delegate];
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    UIView *pleca=[[UIView alloc]initWithFrame:CGRectMake(70, 50, self.view.frame.size.width-70, 100)];
    pleca.backgroundColor= [UIColor colorWithRed:116/255.0 green:94/255.0 blue:197/255.0 alpha:1];
    
    [scroll addSubview:pleca];
    
    
    UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(70, 0, pleca.frame.size.width-70, 50)];
    name.numberOfLines=3;
    [name setFont:[UIFont systemFontOfSize:18]];
    name.textColor=[UIColor whiteColor];
    name.backgroundColor=[UIColor clearColor];
    name.text=[NSString stringWithFormat:@"%@ %@ %@",[[_data objectForKey:@"candidate"]objectForKey:@"nombres"],[[_data objectForKey:@"candidate"]objectForKey:@"apellido_paterno"],[[_data objectForKey:@"candidate"]objectForKey:@"apellido_materno"]];
    [name sizeToFit];
    [pleca addSubview:name];
    
    UILabel *info=[[UILabel alloc] initWithFrame:CGRectMake(70, 50, pleca.frame.size.width-70, 50)];
    info.numberOfLines=3;
    [info setFont:[UIFont systemFontOfSize:18]];
    info.textColor=[UIColor whiteColor];
    info.backgroundColor=[UIColor clearColor];
    info.text=[NSString stringWithFormat:@"%@ \n %@",[_data objectForKey:@"position"],_territory];
    [info sizeToFit];
    [pleca addSubview:info];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(30, 50,100,  105)];
    [img.layer setCornerRadius:img.frame.size.width / 2];
    img.layer.cornerRadius = img.frame.size.width / 2;
    img.layer.masksToBounds = YES;
    if ([[_data objectForKey:@"candidate"]objectForKey:@"twitter"] !=NULL) {
    NSString *st=[NSString stringWithFormat:@"https://twitter.com/%@/profile_image?size=original",[[_data objectForKey:@"candidate"]objectForKey:@"twitter"]];

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
    
    [scroll addSubview:img];
   
    
    
    // datos debajo de la foto

    
    UILabel *puesto=[[UILabel alloc] initWithFrame:CGRectMake(15, img.frame.size.height+ img.frame.origin.y, self.view.frame.size.width-30, 50)];
    
    puesto.backgroundColor=[UIColor clearColor];
    puesto.text=@"";//[_data objectForKey:@"puesto"];
    [scroll addSubview:puesto];
    
    
    UILabel *partido=[[UILabel alloc] initWithFrame:CGRectMake(15, puesto.frame.size.height+ puesto.frame.origin.y, self.view.frame.size.width-30, 50)];
    
    partido.backgroundColor=[UIColor clearColor];
    partido.text=@"Partido";//[_data objectForKey:@"partido"];
    [partido sizeToFit];
    [scroll addSubview:partido];
    
    if([_data objectForKey:@"partidosEnAlianza"]!=NULL)
    {
    
        UILabel *alianza=[[UILabel alloc] initWithFrame:CGRectMake(15, partido.frame.size.height+ partido.frame.origin.y, self.view.frame.size.width-30, 50)];
        
        alianza.backgroundColor=[UIColor redColor];
        alianza.text=[_data objectForKey:@"partidosEnAlianza"];
        //[scroll addSubview:alianza];
        UIImageView *imgPartidoAlianza=[[UIImageView alloc]initWithFrame:CGRectMake(90, partido.frame.size.height+partido.frame.origin.y+20,80,  80)];
        NSString *aux2=[NSString stringWithFormat:@"%@.png",[_data objectForKey:@"partidosEnAlianza"]];
        imgPartidoAlianza.image=[UIImage imageNamed:aux2];
        [scroll addSubview:imgPartidoAlianza];
        [self.view addSubview:scroll];
        self.view.backgroundColor=[UIColor redColor];
    }
   
    
    UIImageView *imgPartido=[[UIImageView alloc]initWithFrame:CGRectMake(90, partido.frame.size.height+ partido.frame.origin.y,40,  40)];
    
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        
        UIImage *imgAux=[self buscarCache:[[[_data objectForKey:@"party"]objectAtIndex:0] objectForKey:@"image"]];
        if (imgAux==nil) {
            UIImage *tmp= [self descargarImg:[[[_data objectForKey:@"party"]objectAtIndex:0] objectForKey:@"image"]];
            [delegate.imgCache setObject: tmp forKey:[[[_data objectForKey:@"party"]objectAtIndex:0] objectForKey:@"image"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
            imgPartido.image=[self buscarCache:[[[_data objectForKey:@"party"]objectAtIndex:0] objectForKey:@"image"]];
            
        });
        
        
    });
    
 
    [scroll addSubview:imgPartido];
     [self.view addSubview:scroll];
    

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
