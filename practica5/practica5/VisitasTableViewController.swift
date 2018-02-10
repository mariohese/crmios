//
//  VisitasTableViewController.swift
//  practica5
//
//  Created by mhs on 26/11/2017.
//  Copyright © 2017 mhs. All rights reserved.
//

import UIKit

class VisitasTableViewController: UITableViewController {

    let token = "77b8e332ce25369a3285"
    var fechainicio: Date?
    var fechafin: Date?
    typealias visit = [String:Any]
    var visits = [visit]()
    var session = URLSession.shared
    var imgCache = [String: UIImage]()
    var fecha1=""
    var fecha2=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = CGFloat(100.0)
        downloadVisits()
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visitascell", for: indexPath) as! VisitasTableViewCell
        
        let visit = visits[indexPath.row]
        
        
        
        
        if let customer = visit["Customer"] as? [String:Any],
            let name = customer["name"] as? String {
            
            cell.nombreTodos.text = name
            
        }
        
        if let plannedFor = visit["plannedFor"] as? String {
            
            
            let df = ISO8601DateFormatter()
            
            
            df.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            
            if let d = df.date(from: plannedFor) {
                
                let str3 = ISO8601DateFormatter.string(from: d, timeZone: .current, formatOptions: [.withFullDate])
                
                cell.fechaTodos.text = str3
                
            }
            
            
        }
        
        if let salesman = visit["Salesman"] as? [String:Any],
            let photo = salesman["Photo"] as? [String:Any],
            let strurl = photo["url"] as? String {
            
            if let img = imgCache[strurl] {
                
                cell.imagenTodos.image = img
                
            }else {
                
                updatePhoto(strurl, for: indexPath)
                
            }
            
        }
        
        return cell
    }
    
    private func downloadVisits(){
        
        let df = ISO8601DateFormatter()
        
        
        df.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        
        let d1 = df.date(from: "\(fechainicio!)")
        fecha1 = ISO8601DateFormatter.string(from: d1!, timeZone: .current, formatOptions: [.withFullDate])
        
        
        let d2 = df.date(from: "\(fechafin!)")
        fecha2 = ISO8601DateFormatter.string(from: d2!, timeZone: .current, formatOptions: [.withFullDate])
        
        let strurl =  "https://dcrmt.herokuapp.com/api/visits/flattened?token="+token+"&dateafter="+fecha1+"&datebefore="+fecha2
        print(strurl)
        if let url = URL(string: strurl){
            let tarea = session.dataTask(with: url){ (data, response, error) in
                if error != nil{
                    print("ERROR 1")
                    return
                }
                if (response as! HTTPURLResponse).statusCode != 200 {
                    print ("ERROR 2")
                }
                if let visits = ( try?JSONSerialization.jsonObject(with: data!)) as? [visit] {
                    
                    DispatchQueue.main.async {
                        
                        self.visits = visits
                        self.tableView.reloadData()
                        
                    }
                }
            }
            
            tarea.resume()
            
        }
    }
    
    func updatePhoto(_ strurl: String, for indexPath: IndexPath) {
        
        DispatchQueue.global().async {
            
            if let url = URL(string: strurl),
                let data = try? Data(contentsOf: url),
                let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    
                    self.imgCache[strurl] = img
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    
                }
                
            }
            
        }
        
    }

}
