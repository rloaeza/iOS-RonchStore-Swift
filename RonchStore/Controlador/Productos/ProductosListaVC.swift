//
//  ProductosListaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/12/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage


protocol ProductosListaVCDelegate {
    func productoSeleccionado(producto: NSDictionary)
}


class ProductosListaVC: UIViewController {
    
    var delegate: ProductosListaVCDelegate?
    var valores: [NSDictionary] = []
    
    @IBOutlet weak var productosViewController: UITableView!
    @IBOutlet weak var botonCategoria: UIButton!
    
    @IBAction func botonAgregar(_ sender: Any) {
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let ref = Database.database().reference().child(Configuraciones.keyProductos).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.productosViewController.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "CategoriaDesdeListaProducto",
               let vc = segue.destination as? CategoriaVC {
                   vc.delegate = self
           }
    }
    
    
}


extension ProductosListaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath) as! ProductoCell
        
        let nombre = valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        let marca = valores[indexPath.row].value(forKey: Configuraciones.keyMarca) as? String
        //let categoria = valores[indexPath.row].value(forKey: Configuraciones.keyCategorias) as? String
        let talla = valores[indexPath.row].value(forKey: Configuraciones.keyTalla) as? String

        celda.Nombre.text = "\(nombre!) "
        celda.Marca.text = "\(marca!)"
        celda.Talla.text = "\(talla!)"
        celda.CostoVenta.text = "$ \( (valores[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as? String)! )"
        
        let storageRef = Storage.storage().reference()
        
        let userRef = storageRef.child(Configuraciones.keyProductos).child(valores[indexPath.row].value(forKey: Configuraciones.keyId)! as! String)
        userRef.getData(maxSize: 10*1024*1024) { (data, error) in
            if error == nil {
                let img = UIImage(data: data!)
                celda.Imagen.image = img
            }
        }
        
        
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyProductos).child(valores[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
    }
}


extension ProductosListaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        delegate?.productoSeleccionado(producto: valores[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
}




extension ProductosListaVC: CategoriaVCDelegate {
    func categoriaSeleccionada(nombre: String) {
        botonCategoria.setTitle(nombre, for: .normal)
        print( "categoria = \(nombre)")
        
       
    }
    
    
}

