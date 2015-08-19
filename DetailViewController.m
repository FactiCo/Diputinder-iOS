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
 self.navigationController.navigationBar.backItem.title=@"";
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"GothamRounded-Bold" size:19],NSFontAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes =textAttributes;

    
    //[[[ self.tabBarController navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //[self setUpNavbar];
    self.navigationController.topViewController.navigationItem.title=@"Ligue Político";
    
    
    //[super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
      delegate= (AppDelegate*)[[UIApplication sharedApplication]delegate];
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
     self.navigationController.navigationBar.backItem.title=@"";
    UIView *pleca=[[UIView alloc]initWithFrame:CGRectMake(70, 50, self.view.frame.size.width-70, 100)];
    pleca.backgroundColor= [UIColor colorWithRed:116/255.0 green:94/255.0 blue:197/255.0 alpha:1];
    
    [scroll addSubview:pleca];
    
    
    UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(70, 5, pleca.frame.size.width-70, 50)];
    name.numberOfLines=3;
    [name setFont:[UIFont systemFontOfSize:18]];
    name.textColor=[UIColor whiteColor];
    name.backgroundColor=[UIColor clearColor];
    name.text=[NSString stringWithFormat:@"%@ %@ %@",[[_data objectForKey:@"candidate"]objectForKey:@"nombres"],[[_data objectForKey:@"candidate"]objectForKey:@"apellido_paterno"],[[_data objectForKey:@"candidate"]objectForKey:@"apellido_materno"]];
  [name setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:18]];
    
    [name sizeToFit];
    
    [pleca addSubview:name];
    
    UILabel *info=[[UILabel alloc] initWithFrame:CGRectMake(70, 50, pleca.frame.size.width-70, 50)];
    info.numberOfLines=3;
   [info setFont:[UIFont fontWithName:@"GothamRounded-Book" size:16]];
    info.textColor=[UIColor whiteColor];
    info.backgroundColor=[UIColor clearColor];
    info.text=[NSString stringWithFormat:@"%@ \n%@",[_data objectForKey:@"position"],_territory];
    [info sizeToFit];
    [pleca addSubview:info];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(30, 47,100,  105)];
    [img.layer setCornerRadius:img.frame.size.width / 2];
    img.layer.cornerRadius = img.frame.size.width / 2;
    
    img.layer.masksToBounds = YES;
    img.image=[UIImage imageNamed:@"noimage.jpg"];
    img.backgroundColor=[UIColor blackColor];
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
    
    
    UILabel *partido=[[UILabel alloc] initWithFrame:CGRectMake(15, pleca.frame.size.height+ pleca.frame.origin.y+10, self.view.frame.size.width-30, 50)];
    partido.textAlignment=NSTextAlignmentCenter;
    partido.backgroundColor=[UIColor clearColor];
    [partido setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:20]];
    
    partido.text=@"Partido";//[_data objectForKey:@"partido"];
    [partido sizeToFit];
    partido.frame=CGRectMake(15, partido.frame.origin.y, self.view.frame.size.width-30, partido.frame.size.height);
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
   
    
    UIImageView *imgPartido=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, partido.frame.size.height+ partido.frame.origin.y+10,60,  60)];
    [imgPartido.layer setCornerRadius:imgPartido.frame.size.width / 2];
    imgPartido.layer.cornerRadius = imgPartido.frame.size.width / 2;
    imgPartido.layer.masksToBounds = YES;
    
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
    
    int top=imgPartido.frame.size.height+ imgPartido.frame.origin.y+10;
 
    //poner dinamicamente  los indicadores
    for (int i=0; i<[[_data objectForKey:@"indicators"] count]; i++) {
        UIImageView *doc=[[UIImageView alloc]initWithFrame:CGRectMake(15, top , 50, 50) ];
        doc.backgroundColor=[UIColor lightGrayColor];
        [doc.layer setCornerRadius:doc.frame.size.width / 2.5];
        doc.layer.cornerRadius = doc.frame.size.width / 2.5;
        
        doc.layer.masksToBounds = YES;
        if ([[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"document"] isEqualToString:@""])
        doc.image=[UIImage imageNamed:@"document.ico"];
        else
              doc.image=[UIImage imageNamed:@"document.ico"];
         UILabel *indicator=[[UILabel alloc]initWithFrame:CGRectMake(60, top+10, self.view.frame.size.width-100, 30)];
        indicator.text=[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"name"];
         [indicator setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:16]];
        indicator.textAlignment=NSTextAlignmentCenter;
        //[indicator sizeToFit];
        indicator.frame=CGRectMake(indicator.frame.origin.x,  top+12, self.view.frame.size.width-100, indicator.frame.size.height);
               [scroll addSubview:indicator];
        indicator.textColor=[UIColor whiteColor];
        
        indicator.backgroundColor=[UIColor darkGrayColor];
        
        
        UIButton *search =  [UIButton buttonWithType:UIButtonTypeCustom];
        search.tintColor=[UIColor whiteColor];
        if ([[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"document"] isEqualToString:@""])
           [search setImage:[UIImage imageNamed:@"nobutton.png"] forState:UIControlStateNormal];
        else
        [search setImage:[UIImage imageNamed:@"yesbutton.png"] forState:UIControlStateNormal];
        [search addTarget:self action:@selector(showDocument) forControlEvents:UIControlEventTouchUpInside];
        
        [search setFrame:CGRectMake(indicator.frame.size.width+indicator.frame.origin.x-15, top+12, 30 , 30)];
        search.backgroundColor=[UIColor darkGrayColor];
        [scroll addSubview:search];

        
        [scroll addSubview:doc];
        top=top+60;
        
    }
    
    [scroll addSubview:imgPartido];
     [self.view addSubview:scroll];
    

    // Do any additional setup after loading the view.
}
-(void)showDocument{}
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

-(void)viewDidAppear:(BOOL)animated{
 self.navigationController.navigationBar.backItem.title=@"";
}
@end
