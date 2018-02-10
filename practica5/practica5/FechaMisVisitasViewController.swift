//
//  FechaMisVisitasViewController.swift
//  practica5
//
//  Created by mhs on 26/11/2017.
//  Copyright © 2017 mhs. All rights reserved.
//

import UIKit

class FechaMisVisitasViewController: UIViewController {

    @IBOutlet weak var fechainicio: UIDatePicker!
    
    @IBOutlet weak var fechafin: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        if let finicio = defaults.object(forKey: "finicio") as? Date {
            fechainicio.date = finicio
        }
        if let ffin = defaults.object(forKey: "ffin") as? Date {
            fechafin.date = ffin
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "MostrarMisVisitas"{
            
            if let mvtvc = segue.destination as? MisVisitasTableViewController {
                
                mvtvc.fechainicio = fechainicio.date
                mvtvc.fechafin = fechafin.date
                
            }
            
        }
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = UserDefaults.standard
        
        defaults.set(fechainicio.date, forKey:"finicio")
        defaults.set(fechafin.date, forKey:"ffin")
        defaults.synchronize()
    }
    
    
    
}
