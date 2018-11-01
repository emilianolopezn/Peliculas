//
//  ViewController.swift
//  peliculas
//
//  Created by Alumno on 31/10/18.
//  Copyright © 2018 Alumno. All rights reserved.
//

import UIKit
import Alamofire

//Heredar los protocolor
//Data source y Delegate
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Establecemos la altura
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    //Número de filas por sección
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Datos.resultadosPeliculas.count
    }
    //Construimos la vista de la celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellResultadoPelicula") as! CeldaPeliculaController
        celda.lblTitulo.text = Datos.resultadosPeliculas[indexPath.row].titulo
        celda.lblAño.text = "\(Datos.resultadosPeliculas[indexPath.row].año)"
        return celda
    }
    
    //Outlets
    @IBOutlet weak var tvResultadosPeliculas: UITableView!
    @IBOutlet weak var aiCargandoBusqueda: UIActivityIndicatorView!
    @IBOutlet weak var txtBusqueda: UITextField!
    
    
    let urlBase = "https://omdbapi.com/?apikey=1d2750f9&s="
    
    //Actions
    @IBAction func doTapBuscarPelicula(_ sender: Any) {
        
        aiCargandoBusqueda.startAnimating()
        var busqueda = txtBusqueda.text!
        busqueda = busqueda.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        Alamofire.request("\(urlBase)\(busqueda)").responseJSON{
            response in
            
            Datos.resultadosPeliculas.removeAll()
            
            if let dictResponse = response.result.value as? NSDictionary {
                if let arrResultados = dictResponse.value(forKey: "Search") as? NSArray {
                    for resultado in arrResultados {
                        if let dictResultado = resultado as? NSDictionary {
                            let nuevoResultado = Pelicula(diccionario: dictResultado)
                            Datos.resultadosPeliculas.append(nuevoResultado)
                        }
                    }
                    self.tvResultadosPeliculas.reloadData()
                }
            }
            self.aiCargandoBusqueda.stopAnimating()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? DetallesPeliculaController {
            destino.pelicula = Datos.resultadosPeliculas[(tvResultadosPeliculas.indexPathForSelectedRow?.row)!]
        }
    }


}

