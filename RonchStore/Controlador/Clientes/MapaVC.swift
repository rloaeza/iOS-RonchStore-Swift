//
//  MapaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 15/06/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase


class MapaVC: UIViewController {

    @IBOutlet weak var Mapa: MKMapView!
    
    var codigo: String? = nil
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()


        // Do any additional setup after loading the view.
    }
    
    @IBAction func fijarPIN(_ sender: UILongPressGestureRecognizer) {
        let loc = sender.location(in: self.Mapa)
        
        let coord = self.Mapa.convert(loc, toCoordinateFrom: self.Mapa)
        
        let PIN = MKPointAnnotation()
        PIN.title = "CASA"
        let lat = coord.latitude as Double
        let long = coord.longitude as Double
        PIN.subtitle = "Lat=\(lat),Long=\(long)"
        
        PIN.coordinate = coord
        self.Mapa.removeAnnotations(Mapa.annotations)
        self.Mapa.addAnnotation(PIN)
        
        
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyLat, Value: "\(coord.latitude)")
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyLong, Value: "\(coord.longitude)")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
