//
//  DetallesPeliculaController.swift
//  peliculas
//
//  Created by Alumno on 01/11/18.
//  Copyright © 2018 Alumno. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


class DetallesPeliculaController : UIViewController {
    
    @IBOutlet weak var imgPoster: UIImageView!
    var pelicula : Pelicula?
    let urlBase = "https://omdbapi.com/?apikey=1d2750f9&i="
    
    @IBAction func doTapAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblDuracion: UILabel!
    @IBOutlet weak var lblAño: UILabel!
    @IBOutlet weak var lblClasificacion: UILabel!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblGenero: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if pelicula != nil {
            lblTitulo.text = pelicula!.titulo
            lblAño.text = "\(pelicula!.año)"
            Alamofire.request("\(urlBase)\(pelicula!.id!)").responseJSON{
                response in
                if let dictResultado = response.result.value as? NSDictionary {
                    /*
                      genero
                      director
                      duracion
                        */
                    
                    if let clasificacion = dictResultado.value(forKey: "Rated") as? String {
                        self.pelicula?.clasificacion = clasificacion
                        self.lblClasificacion.text = clasificacion
                    }
                    if let director = dictResultado.value(forKey: "Director") as? String {
                        self.pelicula?.director = director
                        self.lblDirector.text = director
                    }
                    if let duracion = dictResultado.value(forKey: "Runtime") as? String {
                        self.pelicula?.duracion = duracion
                        self.lblDuracion.text = duracion
                    }
                    if let genero = dictResultado.value(forKey: "Genre") as? String {
                        self.pelicula?.genero = genero
                        self.lblGenero.text = genero
                    }
                    if let poster = dictResultado.value(forKey: "Poster") as? String {
                        self.pelicula?.urlPoster = poster
                        Alamofire.request(poster).responseImage{
                            response in
                            self.imgPoster.image =
                                response.result.value
                        }
                    }
                }
            }
        }
        
        
    }
}
