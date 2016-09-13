import UIKit
import GPUImage
import AVFoundation

let blendImageName = "eyeball.png"

class FilterDisplayViewController: UIViewController {

    @IBOutlet weak var filterSlider: UISlider!
    @IBOutlet weak var filterView: RenderView!
    
    let videoCamera:Camera?
    var blendImage:PictureInput?
    
    // Face setup
    let blendFilter = AlphaBlend()
    let blendFilter2 = AlphaBlend()
    let fbSize = Size(width: 640, height: 480)
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
    var shouldDetectFaces = true
    lazy var lineGenerator: LineGenerator = {
        let gen = LineGenerator(size: self.fbSize)
        gen.lineWidth = 5
        return gen
    }()
    
    required init(coder aDecoder: NSCoder)
    {
        do {
            videoCamera = try Camera(sessionPreset:AVCaptureSessionPreset640x480, location:.FrontFacing)
            videoCamera!.runBenchmark = true
        } catch {
            videoCamera = nil
            print("Couldn't initialize camera with error: \(error)")
        }
        
        super.init(coder: aDecoder)!
    }
    
    var filterOperation: FilterOperationInterface?
    
    func configureView() {
        guard let videoCamera = videoCamera else {
            let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: "Couldn't initialize camera", preferredStyle: .Alert)
            errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default, handler: nil))
            self.presentViewController(errorAlertController, animated: true, completion: nil)
            return
        }
        if let currentFilterConfiguration = self.filterOperation {
            self.title = currentFilterConfiguration.titleName
            
            // Configure the filter chain, ending with the view
            if let view = self.filterView {
                switch currentFilterConfiguration.filterOperationType {
                case .SingleInput:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
//                    currentFilterConfiguration.filter.addTarget(view)
                    videoCamera --> blendFilter2 --> blendFilter --> filterView
                    lineGenerator --> blendFilter
                    currentFilterConfiguration.filter --> blendFilter2
                case .Blend:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
                    self.blendImage = PictureInput(imageName:blendImageName)
                    self.blendImage?.addTarget(currentFilterConfiguration.filter)
                    self.blendImage?.processImage()
//                    currentFilterConfiguration.filter.addTarget(view)
                    videoCamera --> blendFilter2 --> blendFilter --> filterView
                    lineGenerator --> blendFilter
                    currentFilterConfiguration.filter --> blendFilter2
                case let .Custom(filterSetupFunction:setupFunction):
                    currentFilterConfiguration.configureCustomFilter(setupFunction(camera:videoCamera, filter:currentFilterConfiguration.filter, outputView:view))
                case let .Own(filterSetupFunction:setupFunction):
                    videoCamera.addTarget(currentFilterConfiguration.filter)
                    videoCamera --> blendFilter2 --> blendFilter --> filterView
                    lineGenerator --> blendFilter
                    currentFilterConfiguration.filter --> blendFilter2
                }
                videoCamera.delegate = self
                videoCamera.startCapture()
            }
            
            // Hide or display the slider, based on whether the filter needs it
            if let slider = self.filterSlider {
                switch currentFilterConfiguration.sliderConfiguration {
                case .Disabled:
                    slider.hidden = true
                //                case let .Enabled(minimumValue, initialValue, maximumValue, filterSliderCallback):
                case let .Enabled(minimumValue, maximumValue, initialValue):
                    slider.minimumValue = minimumValue
                    slider.maximumValue = maximumValue
                    slider.value = initialValue
                    slider.hidden = false
                    self.updateSliderValue()
                }
            }
            
        }
    }
    
    @IBAction func updateSliderValue() {
        if let currentFilterConfiguration = self.filterOperation {
            switch (currentFilterConfiguration.sliderConfiguration) {
                case .Enabled(_, _, _): currentFilterConfiguration.updateBasedOnSliderValue(Float(self.filterSlider!.value))
                case .Disabled: break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let videoCamera = videoCamera {
            videoCamera.stopCapture()
            videoCamera.removeAllTargets()
            blendImage?.removeAllTargets()
        }
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FilterDisplayViewController: CameraDelegate {
    func didCaptureBuffer(sampleBuffer: CMSampleBuffer) {
        guard shouldDetectFaces else {
            lineGenerator.renderLines([]) // clear
            return
        }
        
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))!
            let img = CIImage(CVPixelBuffer: pixelBuffer, options: attachments as? [String: AnyObject])
            var lines = [Line]()
            for feature in faceDetector.featuresInImage(img, options: [CIDetectorImageOrientation: 6]) {
                if feature is CIFaceFeature {
                    lines = lines + faceLines(feature.bounds)
                }
            }
            lineGenerator.renderLines(lines)
        }
    }
    
    func faceLines(bounds: CGRect) -> [Line] {
        // convert from CoreImage to GL coords
        let flip = CGAffineTransformMakeScale(1, -1)
        let rotate = CGAffineTransformRotate(flip, CGFloat(-M_PI_2))
        let translate = CGAffineTransformTranslate(rotate, -1, -1)
        let xform = CGAffineTransformScale(translate, CGFloat(2/fbSize.width), CGFloat(2/fbSize.height))
        let glRect = CGRectApplyAffineTransform(bounds, xform)
        
        let x = Float(glRect.origin.x)
        let y = Float(glRect.origin.y)
        let width = Float(glRect.size.width)
        let height = Float(glRect.size.height)
        
        let tl = Position(x, y)
        let tr = Position(x + width, y)
        let bl = Position(x, y + height)
        let br = Position(x + width, y + height)
        
        return [.Segment(p1:tl, p2:tr),   // top
            .Segment(p1:tr, p2:br),   // right
            .Segment(p1:br, p2:bl),   // bottom
            .Segment(p1:bl, p2:tl)]   // left
    }
}


