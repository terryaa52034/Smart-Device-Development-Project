//
//  RunningTimerViewController.swift
//  Smart Device Developement Project
//
//  Created by Ang Bryan on 15/6/18.
//  Copyright © 2018 ITP312. All rights reserved.
//
// THIS VERSION EDITUR CONSTRUCTOR COZ U ADD 1 MORE COLUMN IN DB TOTALTIME COLUMN
import UIKit
import MapKit

class RunningTimerViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblProgress: UILabel!
    
    @IBOutlet weak var lblNumberofProgress: UILabel!
    
    @IBOutlet weak var btncontinue: UIButton!
    
    @IBOutlet weak var buttonPause: UIButton!
    
    @IBOutlet weak var lblCalories: UILabel!
    
    
    @IBOutlet weak var btnCreateSchedules: UIButton!
    
    @IBOutlet weak var ZombieModeSwitch: UISwitch!
    
    @IBOutlet weak var lblZombie: UILabel!
    
    var mylocations: [CLLocation] = []
    var targetDistance: Double = 0
    var startDate: Date!
    var startlocation: CLLocation!
    var lastLocation: CLLocation!
    var travelledDistance: Double = 0
    var time : Double = 0
    var calorie : Double = 0
    var weight : Double = 60
    var resumeTapped = false
    var seconds = 60
    var scheduleid = 0
    var thisprogress = 0
    var progress : String = ""
    var lap1Speed : String = ""
    var lap2Speed : String = ""
    var lap3Speed : String = ""
    var lap4Speed : String = ""
    var lap5Speed : String  = ""
    var lap1distance : Double = 0
    var lap2distance : Double = 0
    var lap3distance : Double = 0
    var lap4distance : Double = 0
    var lap5distance : Double = 0
    
    
    @IBOutlet weak var lblspeed: UILabel!
    //timer
    weak var timer = Timer()
    
    @IBAction func btnPause(_ sender: Any) {
        if self.resumeTapped == false
        {
        timer!.invalidate()
        var thiscurrentdistance = Session(scheduleid: RunningDataManager.selectlastSessionTableId(),currentdistance: travelledDistance/1000)
        RunningDataManager.UpdateCurrentDistance(session: thiscurrentdistance)
        self.resumeTapped = true
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        disableLocationServices()
        buttonPause.isHidden = true
        btncontinue.isHidden = false
        mapView.setUserTrackingMode(.follow, animated: true)
        }
        
    }
    
  var username = "john"
    
    var locationManager = CLLocationManager()
    var coordinate2D = CLLocationCoordinate2DMake(40.8367321, 14.2468856)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        if(RunningDataManager.checkUserScheduleExist(username) == false)
        {
            btnCreateSchedules.isHidden = false
            btnStart.isHidden = true
            btncontinue.isHidden = true
            buttonPause.isHidden = true
        }
        else
        {
        btncontinue.isHidden = true
        buttonPause.isHidden = true
        btnStart.isHidden = false
        btnCreateSchedules.isHidden = true
        }
        mapView.delegate = self
        //Create Database When entered this page
        RunningDataManager.createScheduleTable()
        RunningDataManager.createSessionTable()
        
        //Ask permission to access user location but do not start first
    

        // need this for polyline
        locationManager.delegate = self
        updateMapRegion(rangeSpan: 100)
        
        //If there is an ongoing schedule, retrieve ongoing schedule information to remind user that there is one else inform them there is no schedule
        if(RunningDataManager.checkUserScheduleExist(username) == true)
        {
            let currentschedule = RunningDataManager.loadScheduleInformation(username)
            scheduleid = currentschedule.scheduleId!
            thisprogress = Int(currentschedule.progress!)!
            let title : String = currentschedule.trainingdistance!
            targetDistance = Double(title)!
            progress = currentschedule.progress!
            let totalTime : String = currentschedule.numberoftimes!
            lblProgress.text = "\(title)Km Run/Jog"
            lblNumberofProgress.text = "\(progress) / \(totalTime) Times "
        }
        else{
            lblNumberofProgress.text = "No Schedule Created"
        }
        
        
     
        // Do any additional setup after loading the view.
        RunningDataManager.createScheduleTable()

    }
    
    @IBAction func btnCreate(_ sender: Any) {
        btnCreateSchedules.isHidden = true
        btnStart.isHidden = false
    }
/*
 //Incomplete
    func ZombieAlert (){
        var zombiespeed : Double = 4.0
        var zombietime : Double = 0
        var zombiedistance : Double = zombietime * zombiespeed
        
        if(time == 0){
            ZombieWarning = AVSpeechUtterance(string: "Zombie is coming in awhile! Run as fast as you can!")
            ZombieWarning.rate = 1.2
            synth.speak(ZombieWarning)
        }
        if (time == 8){
            zombietime += 1
        }
        
        if (zombiedistance >= travelledDistance - 15){
            audioPlayer.play()
            audioPlayer.volume = 0.7
        }
        if(zombiedistance >= travelledDistance - 10)
        {
            audioPlayer.volume = 0.8
        }
        
        if (zombiedistance >= travelledDistance - 5)
        {
            audioPlayer.volume = 1.0
        }
        if(zombiedistance >= travelledDistance - 20)
        {
            audioPlayer.stop()
        }
        
    }
*/
    
    
    @IBAction func SwitchZombie(_ sender: UISwitch) {
        
        if (sender.isOn == true)
        {
            lblZombie.isHidden = true
        }
        else
        {
            lblZombie.isHidden = false
        }
    }
    
    
    
    
    func FinishAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Start Timer

    @IBAction func start(_ sender: UIButton) {
        setupCoreLocation()
        //Creating Timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RunningTimerViewController.action), userInfo: nil, repeats: true)
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        let currentSession = Session(RunningDataManager.selectlastScheduleTableId(),0.0,targetDistance,lblTime.text!,myStringafd,0)
            
        RunningDataManager.insertOrReplaceSession(session: currentSession)
        
        let estimateddistance = String(targetDistance/5)
        var SessionLapDistance = Session(firstdistance :estimateddistance,seconddistance :estimateddistance,thirddistance :estimateddistance,fourthdistance :estimateddistance,fifthdistance :estimateddistance,RunningDataManager.selectlastSessionTableId())
        RunningDataManager.UpdateSessionDistance(session: SessionLapDistance)
  
        
        //Hide redundant data
        if(timer!.isValid == true)
        {
            btnStart.isHidden = true
            lblProgress.isHidden = true
            lblNumberofProgress.isHidden = true
            buttonPause.isHidden = false
        }
        
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        if self.resumeTapped == true{
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RunningTimerViewController.action), userInfo: nil, repeats: true)
            enableLocationServices()
            self.resumeTapped = false
            buttonPause.isHidden = false
            btncontinue.isHidden = true
            
        }
        
        
    }
    

      @objc func action()
    {
      time += 1
        lblTime.text = timeString(time: (TimeInterval(time)))
    
    }
    
    //Pause Timer
    
    
 
    // Mark:Instance Methods
    func updateMapRegion(rangeSpan:CLLocationDistance){
        let region = MKCoordinateRegionMakeWithDistance(coordinate2D, rangeSpan, rangeSpan)
        mapView.region = region
    }
    
    
    // Mark:Location
    func setupCoreLocation(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways:
            enableLocationServices()
        case .authorizedWhenInUse:
            enableLocationServices()
        default:
            break
        }
        
    }
    
    func enableLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.distanceFilter = 10
        mapView.setUserTrackingMode(.follow, animated: true)
        }
    }
    
    func disableLocationServices(){
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    //Mark: Location Manager delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .authorizedAlways:
            print("authorized")
        case .denied, .restricted:
            print("not authorized")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        	let location = locations.last!
            mylocations.append(locations[0] as CLLocation)
            coordinate2D = location.coordinate
            let displayString = "(\(location.timestamp) Coord:\(coordinate2D)"
            print(displayString)
            updateMapRegion(rangeSpan: 200)
        
        if startDate == nil{
            startDate = Date()
        } else {
            print("elapsedTime :", String(format: "%.0fs",Date().timeIntervalSince(startDate)))
        }
        if startlocation == nil{
            startlocation = locations.first
        }
        else if let location = locations.last{
          
        
            travelledDistance += lastLocation.distance(from: location)
       
            // Convert Meter to KiloMeters
            var distanceInkiloMeter = travelledDistance/1000
            
            
            calorie = distanceInkiloMeter * weight * 1.036
            var calorieString = String(calorie)
            
            print("Traveled Distance:", travelledDistance)
            print("Straight Distance:", startlocation.distance(from: locations.last!))
            self.lblDistance.text! = String(format : "%.2f",distanceInkiloMeter) + " Km "
            self.lblCalories.text! = String(format : "%.2f",calorie) + " cal"
            
        }
            lastLocation = locations.last
        
            var speed = travelledDistance/time
        //Convert time to meter/second
        self.lblspeed.text = String(format :"%.2f",speed) + " m/s"
        
        
        
        if(mylocations.count > 1)
        {
            var sourceIndex = mylocations.count - 1
            var destinationIndex = mylocations.count - 2
            
            let c1 = mylocations[sourceIndex].coordinate
            let c2 = mylocations[destinationIndex].coordinate
            var a = [c1,c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.add(polyline)
        }
        
        var estimateddistance : Double = targetDistance/5
        var finishingtime: String = lblTime.text!
      
        if (travelledDistance/1000 >= (estimateddistance * 5)){
            lap5Speed = lblspeed.text!
        }
        else if (travelledDistance/1000 >= (estimateddistance * 4)){
            lap4Speed = lblspeed.text!
        }
        else if (travelledDistance/1000 >= (estimateddistance * 3)){
            lap3Speed = lblspeed.text!
        }
        else if (travelledDistance/1000 >= (estimateddistance * 2)){
            lap2Speed = lblspeed.text!
        }
        else if(travelledDistance/1000 >= estimateddistance){
            lap1Speed = lblspeed.text!
        }
        if ZombieModeSwitch.isOn == true{
           // ZombieAlert()
        }
        
        if(targetDistance != 0)
        {
        if(travelledDistance/1000 >= targetDistance)
        {
            var currentFinishTime = Session(time: finishingtime,RunningDataManager.selectlastSessionTableId())
            RunningDataManager.UpdateTotalTime(session: currentFinishTime)
            FinishAlert(title:"Finish",message:"You have completed the jog/run")
            disableLocationServices()
            var currentprogress: String = String(thisprogress + 1)
            var currentcomplete: Schedule = Schedule(currentprogress,scheduleid)
            RunningDataManager.UpdateProgress(Schedule: currentcomplete)
            
            var thisSessionSpeed = Session(firstspeed : lap1Speed,secondspeed : lap2Speed,thirdspeed : lap3Speed,fourthspeed : lap4Speed,fivespeed : lap5Speed,RunningDataManager.selectlastSessionTableId())
            RunningDataManager.UpdateSessionSpeed(session: thisSessionSpeed)
            
            var thistotalcaloriesburnt = Session(scheduleid: RunningDataManager.selectlastSessionTableId(), totalcalories:calorie)
            RunningDataManager.UpdateTotalCalories(session: thistotalcaloriesburnt)
            
            var thistotaldistance = Session(scheduleid: RunningDataManager.selectlastSessionTableId(), currentdistance: travelledDistance/1000)
            RunningDataManager.UpdateCurrentDistance(session: thistotaldistance)
            
            updateMapRegion(rangeSpan: 200)
            
            timer!.invalidate()
        }
        }
            
        
        }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
    
        if overlay is MKPolyline{
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.black
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
       return MKOverlayRenderer(overlay: overlay)
    }
    
    func timeString(time:TimeInterval) -> String{
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hour, minute, second)
        
       
        
    }
    
    
    
   
 


 /*   func addAnnotationsOnMap(locationToPoint: CLLocation)
    {
        var annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        var geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler:{(placemarks, Error) -> Void in
        if let placemarks = placemarks as? [CLPlacemark] where placemarks.count > 0 {
            var placemark = placemarks[0]
            var addressDictionary = placemarks.addressDictionary;
            annotation.title = addressDictionary["Name"] as? String
            self.mapView.addAnnotation(annotation)
            }
        })
    }
 */
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if  (error as? CLError)?.code == .denied{
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
    }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
           

}
