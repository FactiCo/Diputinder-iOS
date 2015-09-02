//
//  DetailViewController.m
//  Diputinder
//
//  Created by Carlos Castellanos on 29/04/15.
//  Copyright (c) 2015 Carlos Castellanos. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "DocumentViewController.h"

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
   
    
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 15,100,  100)];
    [img.layer setCornerRadius:img.frame.size.width / 2];
    img.layer.cornerRadius = img.frame.size.width / 2;
    img.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    img.layer.borderWidth =3.5;
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
    
    
    UIImageView *imgPartido=[[UIImageView alloc]initWithFrame:CGRectMake(img.frame.size.width+img.frame.origin.x-30, img.frame.size.height+img.frame.origin.y-35,40,40)];
    [imgPartido.layer setCornerRadius:imgPartido.frame.size.width / 2];
    imgPartido.layer.cornerRadius = imgPartido.frame.size.width / 2;
    imgPartido.layer.borderColor = [[UIColor whiteColor] CGColor];
    imgPartido.layer.borderWidth =3.5;
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
    
    
    UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(15, img.frame.size.height+img.frame.origin.y+5, scroll.frame.size.width-30, 50)];
    name.numberOfLines=4;
    name.textAlignment=NSTextAlignmentCenter;
    [name setFont:[UIFont systemFontOfSize:16]];
    name.textColor=[UIColor blackColor];
    name.backgroundColor=[UIColor clearColor];
    name.text=[NSString stringWithFormat:@"%@ %@ %@",[[_data objectForKey:@"candidate"]objectForKey:@"nombres"],[[_data objectForKey:@"candidate"]objectForKey:@"apellido_paterno"],[[_data objectForKey:@"candidate"]objectForKey:@"apellido_materno"]];
    [name setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:18]];
    
    [name sizeToFit];
    name.frame=CGRectMake(15, name.frame.origin.y, self.view.frame.size.width-30, name.frame.size.height);
    [scroll addSubview:name];
    
    
 
    UILabel *partido=[[UILabel alloc] initWithFrame:CGRectMake(15, name.frame.size.height+name.frame.origin.y+3, scroll.frame.size.width-30, 50)];
    partido.textAlignment=NSTextAlignmentCenter;
    partido.textColor=[UIColor darkGrayColor];
    partido.backgroundColor=[UIColor clearColor];
    [partido setFont:[UIFont fontWithName:@"GothamRounded-Book" size:12]];
    
    partido.text=[[[_data objectForKey:@"party"]objectAtIndex:0] objectForKey:@"name"];//[_data objectForKey:@"partido"];
    [partido sizeToFit];
    partido.frame=CGRectMake(15, partido.frame.origin.y, self.view.frame.size.width-30, partido.frame.size.height);
    
    partido.frame=CGRectMake(15, partido.frame.origin.y, self.view.frame.size.width-30, partido.frame.size.height);
    
     [scroll addSubview:partido];
    
    UILabel *info=[[UILabel alloc] initWithFrame:CGRectMake(15, partido.frame.size.height+partido.frame.origin.y+3, scroll.frame.size.width-30, 50)];
    info.numberOfLines=3;
    info.textAlignment=NSTextAlignmentCenter;
    [info setFont:[UIFont fontWithName:@"GothamRounded-Book" size:12]];
    info.textColor=[UIColor darkGrayColor];
    info.backgroundColor=[UIColor clearColor];
    info.text=[NSString stringWithFormat:@"%@/%@",[_data objectForKey:@"position"],[_data objectForKey:@"territory"]];
    [info sizeToFit];
     info.frame=CGRectMake(15, info.frame.origin.y, self.view.frame.size.width-30, info.frame.size.height);
    [scroll addSubview:info];
 
    
    // datos debajo de la foto

    
   
    
   
    
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
   
    UIImageView *aux1=[[UIImageView alloc]initWithFrame:CGRectMake(15, info.frame.size.height+ info.frame.origin.y+10, 20, 20)];
    aux1.image=[UIImage imageNamed:@"palomita.png"];
    [scroll addSubview:aux1];
    UILabel *declarado=[[UILabel alloc]initWithFrame:CGRectMake(aux1.frame.size.width+aux1.frame.origin.x+5, info.frame.size.height+ info.frame.origin.y, scroll.frame.size.width-30, 40)];
    declarado.text=@"Declaraciones Presentadas";
    declarado.backgroundColor=[UIColor clearColor];
    [declarado setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:14]];
    [scroll addSubview: declarado];
    int top=declarado.frame.size.height+ declarado.frame.origin.y+5;
    int tope=declarado.frame.size.height+ declarado.frame.origin.y+5;
    //poner dinamicamente  los indicadores
    int aux=0;
    BOOL oneLine=TRUE;
    for (int i=0; i<[[_data objectForKey:@"indicators"] count]; i++) {
        if (oneLine) {
            tope=top+110;
        }else
            tope=top;
        
        
        if((aux*70)+70 > scroll.frame.size.width )
          {
          oneLine=FALSE;
          top=top+110;
          aux=0;
          tope=top+110;
          }
       
        if ([[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"document"] isEqualToString:@""])
        {        }
        else
        {
            
            UIImageView *doc=[[UIImageView alloc]initWithFrame:CGRectMake(15 +(aux*70), top , 70, 70) ];
            doc.layer.masksToBounds = YES;
            doc.image=[UIImage imageNamed:@"declarado.png"];
            [scroll addSubview:doc];
            
            doc.userInteractionEnabled = YES;
               UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDocument:)];
            tap.accessibilityValue=[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"document"];
            //pgr.delegate = self;
            [doc addGestureRecognizer:tap];
            
            UILabel *indicator=[[UILabel alloc]initWithFrame:CGRectMake(15 +(aux*70), doc.frame.size.height+doc.frame.origin.y+2,70, 30)];
            indicator.numberOfLines=3;
            indicator.text=[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"name"];
            [indicator setFont:[UIFont fontWithName:@"GothamRounded-Book" size:10]];
            indicator.textAlignment=NSTextAlignmentCenter;
            [indicator sizeToFit];
            indicator.frame=CGRectMake(indicator.frame.origin.x,doc.frame.size.height+doc.frame.origin.y+5, 70, indicator.frame.size.height);
            //   [scroll addSubview:indicator];
            indicator.textColor=[UIColor darkGrayColor];
            [scroll addSubview:indicator];
              aux++;
        
        }
         //   doc.image=[UIImage imageNamed:@"declarado.png"];
        
        
        
   
        
        /*
        
        
        UIButton *search =  [UIButton buttonWithType:UIButtonTypeCustom];
        search.accessibilityIdentifier=[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"document"];
        search.tintColor=[UIColor whiteColor];
        if ([[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"document"] isEqualToString:@""])
        {
           [search setImage:[UIImage imageNamed:@"ic_btn_no_declaro.png"] forState:UIControlStateNormal];
           
        }
        else
        [search setImage:[UIImage imageNamed:@"ic_btn_declaro.png"] forState:UIControlStateNormal];
        
        
        [search addTarget:self action:@selector(showDocument:) forControlEvents:UIControlEventTouchUpInside];
        
        [search setFrame:CGRectMake(indicator.frame.size.width+indicator.frame.origin.x-15, top+12, 30 , 30)];
        search.backgroundColor=[UIColor clearColor];*/
      //  [scroll addSubview:search];

        
      
        //top=top+60;
        
    }
    UIImageView *aux2=[[UIImageView alloc]initWithFrame:CGRectMake(15, tope, 20, 20)];
    aux2.image=[UIImage imageNamed:@"tache.png"];
    [scroll addSubview:aux2];
    UILabel *nodeclarado=[[UILabel alloc]initWithFrame:CGRectMake(aux2.frame.size.width+aux2.frame.origin.x+5, tope-10, scroll.frame.size.width-30, 40)];
    nodeclarado.text=@"Declaraciones No Presentadas";
    [nodeclarado setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:14]];
    [scroll addSubview: nodeclarado];
    top=nodeclarado.frame.size.height+ nodeclarado.frame.origin.y+10;
    tope=nodeclarado.frame.size.height+ nodeclarado.frame.origin.y+10;
    aux=0;
    oneLine=TRUE;
    for (int i=0; i<[[_data objectForKey:@"indicators"] count]; i++) {
        if (oneLine) {
            tope=top+110;
        }else
            tope=top;
        
        
        if((aux*70)+70 > scroll.frame.size.width )
        {
            oneLine=FALSE;
            top=top+110;
            aux=0;
            tope=top+110;
        }
        
        if ([[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"document"] isEqualToString:@""])
        {
            UIImageView *doc=[[UIImageView alloc]initWithFrame:CGRectMake(15 +(aux*70), top , 70, 70) ];
            doc.layer.masksToBounds = YES;
            doc.image=[UIImage imageNamed:@"nodeclarado.png"];
            [scroll addSubview:doc];
            
            UILabel *indicator=[[UILabel alloc]initWithFrame:CGRectMake(15 +(aux*70), doc.frame.size.height+doc.frame.origin.y+2,70, 30)];
            indicator.numberOfLines=3;
            indicator.text=[[[_data objectForKey:@"indicators"]objectAtIndex:i]objectForKey:@"name"];
            [indicator setFont:[UIFont fontWithName:@"GothamRounded-Book" size:10]];
            indicator.textAlignment=NSTextAlignmentCenter;
            [indicator sizeToFit];
            indicator.frame=CGRectMake(indicator.frame.origin.x,doc.frame.size.height+doc.frame.origin.y+5, 70, indicator.frame.size.height);
            //   [scroll addSubview:indicator];
            indicator.textColor=[UIColor darkGrayColor];
            [scroll addSubview:indicator];
            aux++;

        }
        
    }
    
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width,tope+60)];
    [scroll addSubview:imgPartido];
     [self.view addSubview:scroll];
    

    // Do any additional setup after loading the view.
}
-(void)showDocument:(id)sender{
    UIGestureRecognizer *a = (UIGestureRecognizer *) sender;
    DocumentViewController *doc=[[DocumentViewController alloc]init];
    if ([a.accessibilityValue isEqualToString:@""]) {
        
    }
    else{
    doc.path=a.accessibilityValue;
        [self.navigationController pushViewController:doc animated:NO];}
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
    if ([url isEqualToString:@"ejemplo"]) {
        tmp=[UIImage imageNamed:@"noimage.jpg"];
    }
    else{
    if([[url substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]){
        
        tmp =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: url]]];
        while (tmp==nil) {
            tmp=[UIImage imageNamed:@"h.jpg"];
            
        }
    }
    else{
        tmp=[UIImage imageNamed:@"h.jpg"];
    }
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

    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"GothamRounded-Bold" size:19],NSFontAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes =textAttributes;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.topViewController.navigationItem.title=@"Ligue Político";
    
}
@end
