// MIT License
//
// Copyright (c) 2020 Bryce Dougherty <bryce.dougherty@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if canImport(UIKit)
import Foundation
import UIKit
import CoreGraphics

extension CGImage {
    public func getVibrantPalette() -> CGVibrantPalette {
        let image = UIImage(cgImage: self)
        return VibrantManager.from(image).getPalette()
    }
}

//
//  Builder.swift
//  swift-vibrant-ios
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//
typealias Callback<T> = (T)->Void

class Builder {
    
    private var _src: UIImage
    private var _opts: VibrantManager.Options
    
    init(_ src: UIImage, _ opts: VibrantManager.Options = VibrantManager.Options()) {
        self._src = src
        self._opts = opts
    }
    func maxColorCount(_ n: Int)->Builder {
        self._opts.colorCount = n
        return self
    }
    
    func maxDimension(_ d: CGFloat)->Builder {
        self._opts.maxDimension = d
        return self
    }
    
    func quality(_ q: Int)->Builder {
        self._opts.quality = q
        return self
    }
    
    func addFilter(_ f: Filter)->Builder {
        self._opts.filters.append(f)
        return self
    }
    
    func removeFilter(_ f: Filter)->Builder {
        self._opts.filters.removeAll(where: { (callback: Filter) in
            callback.id == f.id
        })
        return self
    }
    
    func useGenerator(_ generator: @escaping Generator.generator)->Builder {
        self._opts.generator = generator
        return self
    }
    
    func useQuantizer(_ quantizer: @escaping Quantizer.quantizer)->Builder {
        self._opts.quantizer = quantizer
        return self
    }
    
    func build()->VibrantManager {
        return VibrantManager(src: self._src, opts: self._opts)
    }
    func getPalette()->CGVibrantPalette {
        return self.build().getPalette()
    }
    func getPalette(_ cb: @escaping Callback<CGVibrantPalette>) {
        return self.build().getPalette(cb)
    }
    
}
//
//  util.swift
//  swift-vibrant
//
//  Created by Bryce Dougherty on 4/30/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//





struct DELTAE94_DIFF_STATUS {
    static let NA:Int = 0
    static let PERFECT:Int = 1
    static let CLOSE:Int = 2
    static let GOOD:Int = 10
    static let SIMILAR:Int = 50
}

//typealias Double = Double

struct newErr: Error {
    init(_ message: String) {
        self.message = message
    }
    let message: String
}

func uiColorToRgb(_ color: UIColor)->RGB {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    color.getRed(&r, green: &g, blue: &b, alpha: nil)
    return (UInt8(r * 255), UInt8(g * 255), UInt8(b * 255))
}

func rgbToUIColor(_ r: UInt8, _ g: UInt8, _ b: UInt8)->UIColor {
    return UIColor.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
}
func uiColorToHsl(_ color: UIColor)->HSL {
    var h:CGFloat = 0
    var s:CGFloat = 0
    var l:CGFloat = 0
    color.getHue(&h, saturation: &s, brightness: &l, alpha: nil)
    return (Double(h),Double(s),Double(l))
}
func hslToUIColor(_ h: Double, _ s: Double, _ l: Double)->UIColor {
    return UIColor.init(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(l), alpha: 1)
}


func hexToRgb(_ hex: String)->RGB? {
    let r, g, b: UInt8
    
    if hex.hasPrefix("#") {
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexDouble: UInt64 = 0
            
            
            if scanner.scanHexInt64(&hexDouble) {
                r = UInt8(hexDouble & 0xff000000) >> 24
                g = UInt8(hexDouble & 0x00ff0000) >> 16
                b = UInt8(hexDouble & 0x0000ff00) >> 8
                
                return (r, g, b)
            }
        }
    }
    return nil
}



func rgbToHex(_ r: UInt8, _ g: UInt8, _ b: UInt8)->String {
    return "#" + String(format:"%02X", r) + String(format:"%02X", g) + String(format:"%02X", b)
}

func rgbToHsl(r: UInt8, g: UInt8, b: UInt8)-> Vec3<Double> {
    let r = Double(r) / 255
    let g = Double(g) / 255
    let b = Double(b) / 255
    let maxVal = max(r, g, b)
    let minVal = min(r, g, b)
    var h: Double
    let s: Double
    let l = (maxVal + minVal) / 2
    if (maxVal == minVal) {
        h = 0
        s = 0
    } else {
        let d = maxVal - minVal
        s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal)
        switch (maxVal) {
        case r:
            h = (g - b) / d + (g < b ? 6 : 0)
            break
        case g:
            h = (b - r) / d + 2
            break
        case b:
            h = (r - g) / d + 4
            break
        default:
            h = 0
            break
        }
        h /= 6
    }
    return (h, s, l)
}

func hslToRgb(_ h: Double, _ s: Double, _ l: Double)-> RGB {
    var r: Double
    var g: Double
    var b: Double
    
    func hue2rgb(_ p: Double, _ q: Double, _ t: Double)-> Double {
        var t = t
        if (t < 0) { t += 1 }
        if (t > 1) { t -= 1 }
        if (t < 1 / 6) { return p + (q - p) * 6 * t }
        if (t < 1 / 2)  { return q }
        if (t < 2 / 3)  { return p + (q - p) * (2 / 3 - t) * 6 }
        return p
    }
    
    if (s == 0) {
        r = l
        g = l
        b = l
    } else {
        let q = l < 0.5 ? l * (1 + s) : l + s - (l * s)
        let p = 2 * l - q
        r = hue2rgb(p, q, h + 1 / 3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - (1 / 3))
    }
    return(
        UInt8(r * 255),
        UInt8(g * 255),
        UInt8(b * 255)
    )
}


func rgbToXyz(_ r: UInt8, _ g: UInt8, _ b: UInt8)->XYZ {
    var r = Double(r) / 255
    var g = Double(g) / 255
    var b = Double(b) / 255
    
    r = r > 0.04045 ? pow((r + 0.005) / 1.055, 2.4) : r / 12.92
    g = g > 0.04045 ? pow((g + 0.005) / 1.055, 2.4) : g / 12.92
    b = b > 0.04045 ? pow((b + 0.005) / 1.055, 2.4) : b / 12.92
    
    r *= 100
    g *= 100
    b *= 100
    
    let x = r * 0.4124 + g * 0.3576 + b * 0.1805
    let y = r * 0.2126 + g * 0.7152 + b * 0.0722
    let z = r * 0.0193 + g * 0.1192 + b * 0.9505
    
    return (x: x,y: y,z: z)
}

func xyzToCIELab(_ x: Double, _ y: Double, _ z: Double)-> LAB {
    let REF_X: Double = 95.047
    let REF_Y: Double = 100
    let REF_Z: Double = 108.883
    
    var x = x / REF_X
    var y = y / REF_Y
    var z = z / REF_Z
    
    x = x > 0.008856 ? pow(x, 1 / 3) : 7.787 * x + 16 / 116
    y = y > 0.008856 ? pow(y, 1 / 3) : 7.787 * y + 16 / 116
    z = z > 0.008856 ? pow(z, 1 / 3) : 7.787 * z + 16 / 116
    
    let L = 116 * y - 16
    let a = 500 * (x - y)
    let b = 200 * (y - z)
    
    return (L: L, a: a, b: b)
}


func rgbToCIELab(_ r: UInt8, _ g: UInt8, _ b: UInt8)->LAB {
    let (x,y,z) = rgbToXyz(r, g, b)
    return xyzToCIELab(x, y, z)
}

func deltaE94(_ lab1: Vec3<Double>, _ lab2: Vec3<Double>)->Double {
    let WEIGHT_L:Double = 1
    let WEIGHT_C:Double = 1
    let WEIGHT_H:Double = 1
    
    let (L1, a1, b1) = lab1
    let (L2, a2, b2) = lab2
    let dL = L1 - L2
    let da = a1 - a2
    let db = b1 - b2
    
    let xC1 = sqrt(a1 * a1 + b1 * b1)
    let xC2 = sqrt(a2 * a2 + b2 * b2)
    
    var xDL = L2 - L1
    var xDC = xC2 - xC1
    let xDE = sqrt(dL * dL + da * da + db * db)
    
    var xDH = (sqrt(xDE) > sqrt(abs(xDL)) + sqrt(abs(xDC)))
    ? sqrt(xDE * xDE - xDL * xDL - xDC * xDC)
    : 0
    
    let xSC = 1 + 0.045 * xC1
    let xSH = 1 + 0.015 * xC1
    
    xDL /= WEIGHT_L
    xDC /= WEIGHT_C * xSC
    xDH /= WEIGHT_H * xSH
    
    return sqrt(xDL * xDL + xDC * xDC + xDH * xDH)
}

func rgbDiff(_ rgb1: RGB, _ rgb2: RGB)->Double {
    let lab1 = apply(rgbToCIELab, rgb1)
    let lab2 = apply(rgbToCIELab, rgb2)
    return deltaE94(lab1, lab2)
}

func hexDiff(_ hex1: String, _ hex2: String)->Double {
    let rgb1 = hexToRgb(hex1)!
    let rgb2 = hexToRgb(hex2)!
    return rgbDiff(rgb1, rgb2)
}

func getColorDiffStatus(_ d: Int)->String {
    if (d < DELTAE94_DIFF_STATUS.NA) { return "N/A" }
    // Not perceptible by human eyes
    if (d <= DELTAE94_DIFF_STATUS.PERFECT) { return "Perfect" }
    // Perceptible through close observation
    if (d <= DELTAE94_DIFF_STATUS.CLOSE) { return "Close" }
    // Perceptible at a glance
    if (d <= DELTAE94_DIFF_STATUS.GOOD) { return "Good" }
    // Colors are more similar than opposite
    if (d < DELTAE94_DIFF_STATUS.SIMILAR) { return "Similar" }
    return "Wrong"
}

//
//  Constants.swift
//  swift-vibrant
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//

internal let signalBits = 5
internal let rightShift = 8 - signalBits
internal let multiplier = 1 << rightShift
internal let histogramSize = 1 << (3 * signalBits)
internal let vboxLength = 1 << signalBits
internal let fractionByPopulation = 0.75
internal let maxIterations = 1000

//
//  Filter.swift
//  swift-vibrant-ios
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//

class Filter {
    typealias filterFunction = (_ red: UInt8, _ green: UInt8, _ blue: UInt8, _ alpha: UInt8)->Bool
    
    var f: filterFunction
    var id: String
    
    init(_ f: @escaping filterFunction) {
        self.f = f
        self.id = UUID().uuidString
    }
    
    private init(_ f: @escaping filterFunction, id: String) {
        self.f = f
        self.id = id
    }
    
    static func combineFilters (filters: [Filter])->Filter? {
        if filters.count == 0 { return nil }
        let newFilterFunction:filterFunction = { r,g,b,a in
            if a == 0 { return false }
            for f in filters {
                if !f.f(r,g,b,a) { return false }
            }
            return true
        }
        return Filter(newFilterFunction)
    }
    
    static let defaultFilter: Filter = Filter({r, g, b, a in
        return a >= 125 && !(r > 250 && g > 250 && b > 250)
    }, id: "default")
}

//
//  default.swift
//  swift-vibrant
//
//  Created by Bryce Dougherty on 4/30/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//

class Generator {
    
    typealias generator = (_ swatches: [Swatch])->CGVibrantPalette
    
    struct Options {
        var targetDarkLuma:  Double = 0.26
        var maxDarkLuma:  Double = 0.45
        var minLightLuma:  Double = 0.55
        var targetLightLuma:  Double = 0.74
        var minNormalLuma:  Double = 0.3
        var targetNormalLuma:  Double = 0.5
        var maxNormalLuma:  Double = 0.7
        var targetMutesSaturation:  Double = 0.3
        var maxMutesSaturation:  Double = 0.4
        var targetVibrantSaturation:  Double = 1.0
        var minVibrantSaturation:  Double = 0.35
        var weightSaturation:  Double = 3.0
        var weightLuma:  Double = 6.5
        var weightPopulation:  Double = 0.5
    }
    var options: Options
    init(options: Options) {
        self.options = options
    }
    
    
    static let defaultGenerator:generator = Generator(options: Options()).generate
    
    private func generate(swatches: [Swatch])->CGVibrantPalette {
        let maxPopulation = findMaxPopulation(swatches: swatches)
        var palette = generateVariationColors(swatches: swatches, maxPopulation: maxPopulation, opts: options)
        palette = generateEmptySwatches(palette: palette, opts: options)
        return palette
    }
    
    func findMaxPopulation( swatches: [Swatch])->Int {
        var p: Int = 0
        swatches.forEach { (s: Swatch) in
            p = max(p, s.population)
        }
        return p
    }
    
    func isAlreadySelected (palette: CGVibrantPalette, s: Swatch)->Bool {
        return palette._vibrant == s ||
        palette._darkVibrant == s ||
        palette._lightVibrant == s ||
        palette._muted == s ||
        palette._darkMuted == s ||
        palette._lightMuted == s
    }
    
    func createComparisonValue (
        saturation: Double, targetSaturation: Double,
        luma: Double, targetLuma: Double,
        population: Int, maxPopulation: Int, opts: Options) -> Double {
            
            func weightedMean (values: Double...)->Double {
                var sum: Double = 0
                var weightSum: Double = 0
                var i = 0
                while i < values.count {
                    let value = values[i]
                    let weight = values[i + 1]
                    sum += value * weight
                    weightSum += weight
                    i+=2
                }
                return sum / weightSum
            }
            
            func invertDiff (value: Double, targetValue: Double)->Double {
                return 1 - abs(value - targetValue)
            }
            
            
            return weightedMean(
                values: invertDiff(value: saturation, targetValue: targetSaturation), opts.weightSaturation,
                invertDiff(value: luma, targetValue: targetLuma), opts.weightLuma,
                Double(population) / Double(maxPopulation), opts.weightPopulation
            )
        }
    
    func findColorVariation (palette: CGVibrantPalette, swatches: [Swatch], maxPopulation: Int,
                             targetLuma: Double,
                             minLuma: Double,
                             maxLuma: Double,
                             targetSaturation: Double,
                             minSaturation: Double,
                             maxSaturation: Double,
                             opts: Options)->Swatch? {
        
        var max: Swatch? = nil
        var maxValue: Double = 0
        
        swatches.forEach({swatch in
            let (_,s,l) = swatch.hsl
            
            if (s >= minSaturation && s <= maxSaturation &&
                l >= minLuma && l <= maxLuma &&
                !isAlreadySelected(palette: palette, s: swatch)
            ) {
                let value = createComparisonValue(saturation: s, targetSaturation: targetSaturation, luma: l, targetLuma: targetLuma, population: swatch.population, maxPopulation: maxPopulation, opts: opts)
                if (max == nil || value > maxValue) {
                    max = swatch
                    maxValue = value
                }
            }
        })
        return max
    }
    
    func generateVariationColors (swatches: [Swatch], maxPopulation: Int, opts: Options)->CGVibrantPalette {
        
        var palette = CGVibrantPalette()
        
        palette._vibrant = findColorVariation(palette: palette, swatches: swatches, maxPopulation: maxPopulation,
                                             targetLuma: opts.targetNormalLuma,
                                             minLuma: opts.minNormalLuma,
                                             maxLuma: opts.maxNormalLuma,
                                             targetSaturation: opts.targetVibrantSaturation,
                                             minSaturation: opts.minVibrantSaturation,
                                             maxSaturation: 1,
                                             opts: opts
        )
        
        palette._lightVibrant = findColorVariation(palette: palette, swatches: swatches, maxPopulation: maxPopulation,
                                                  targetLuma: opts.targetLightLuma,
                                                  minLuma: opts.minLightLuma,
                                                  maxLuma: 1,
                                                  targetSaturation: opts.targetVibrantSaturation,
                                                  minSaturation: opts.minVibrantSaturation,
                                                  maxSaturation: 1,
                                                  opts: opts
        )
        
        palette._darkVibrant = findColorVariation(palette: palette, swatches: swatches, maxPopulation: maxPopulation,
                                                 targetLuma: opts.targetDarkLuma,
                                                 minLuma: 0,
                                                 maxLuma: opts.maxDarkLuma,
                                                 targetSaturation: opts.targetVibrantSaturation,
                                                 minSaturation: opts.minVibrantSaturation,
                                                 maxSaturation: 1,
                                                 opts: opts
        )
        
        palette._muted = findColorVariation(palette: palette, swatches: swatches, maxPopulation: maxPopulation,
                                           targetLuma: opts.targetNormalLuma,
                                           minLuma: opts.minNormalLuma,
                                           maxLuma: opts.maxNormalLuma,
                                           targetSaturation: opts.targetMutesSaturation,
                                           minSaturation: 0,
                                           maxSaturation: opts.maxMutesSaturation,
                                           opts: opts
        )
        
        palette._lightMuted = findColorVariation(palette: palette, swatches: swatches, maxPopulation: maxPopulation,
                                                targetLuma: opts.targetLightLuma,
                                                minLuma: opts.minLightLuma,
                                                maxLuma: 1,
                                                targetSaturation: opts.targetMutesSaturation,
                                                minSaturation: 0,
                                                maxSaturation: opts.maxMutesSaturation,
                                                opts: opts
        )
        
        palette._darkMuted = findColorVariation(palette: palette, swatches: swatches, maxPopulation: maxPopulation,
                                               targetLuma: opts.targetDarkLuma,
                                               minLuma: 0,
                                               maxLuma: opts.maxDarkLuma,
                                               targetSaturation: opts.targetMutesSaturation,
                                               minSaturation: 0,
                                               maxSaturation: opts.maxMutesSaturation,
                                               opts: opts
        )
        return palette
        
    }
    //
    func generateEmptySwatches (palette: CGVibrantPalette, opts: Options)->CGVibrantPalette {
        
        var palette = palette
        //function _generateEmptySwatches (palette: Palette, maxPopulation: number, opts: DefaultGeneratorOptions): void {
        if (palette._vibrant == nil && palette._darkVibrant == nil && palette._lightVibrant == nil) {
            if (palette._darkVibrant == nil && palette._darkMuted != nil) {
                var (h, s, l) = palette._darkMuted!.hsl
                l = opts.targetDarkLuma
                palette._darkVibrant = Swatch(hslToRgb(h, s, l), 0)
            }
            if (palette._lightVibrant == nil && palette._lightMuted != nil) {
                var (h, s, l) = palette._lightMuted!.hsl
                l = opts.targetDarkLuma
                palette._darkVibrant = Swatch(hslToRgb(h, s, l), 0)
            }
        }
        if (palette._vibrant == nil && palette._darkVibrant != nil) {
            var (h, s, l) = palette._darkVibrant!.hsl
            l = opts.targetNormalLuma
            palette._vibrant =  Swatch(hslToRgb(h, s, l), 0)
        } else if (palette._vibrant == nil && palette._lightVibrant != nil) {
            var (h, s, l) = palette._lightVibrant!.hsl
            l = opts.targetNormalLuma
            palette._vibrant =  Swatch(hslToRgb(h, s, l), 0)
        }
        if (palette._darkVibrant == nil && palette._vibrant != nil) {
            var (h, s, l) = palette._vibrant!.hsl
            l = opts.targetDarkLuma
            palette._darkVibrant =  Swatch(hslToRgb(h, s, l), 0)
        }
        if (palette._lightVibrant == nil && palette._vibrant != nil) {
            var (h, s, l) = palette._vibrant!.hsl
            l = opts.targetLightLuma
            palette._lightVibrant =  Swatch(hslToRgb(h, s, l), 0)
        }
        if (palette._muted == nil && palette._vibrant != nil) {
            var (h, s, l) = palette._vibrant!.hsl
            l = opts.targetMutesSaturation
            palette._muted =  Swatch(hslToRgb(h, s, l), 0)
        }
        if (palette._darkMuted == nil && palette._darkVibrant != nil) {
            var (h, s, l) = palette._darkVibrant!.hsl
            l = opts.targetMutesSaturation
            palette._darkMuted =  Swatch(hslToRgb(h, s, l), 0)
        }
        if (palette._lightMuted == nil && palette._lightVibrant != nil) {
            var (h, s, l) = palette._lightVibrant!.hsl
            l = opts.targetMutesSaturation
            palette._lightMuted =  Swatch(hslToRgb(h, s, l), 0)
        }
        return palette
    }
}

//
//  Image.swift
//  swift-vibrant-ios
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//

class Image {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func applyFilter(_ filter: Filter)->[UInt8] {
        guard let imageData = self.getImageData() else {
            return []
        }
        var pixels = imageData
        let n = pixels.count / 4
        var offset: Int
        var r, g, b, a: UInt8
        
        for i in 0..<n {
            offset = i * 4
            r = pixels[offset + 0]
            g = pixels[offset + 1]
            b = pixels[offset + 2]
            a = pixels[offset + 3]
            
            if (!filter.f(r,g,b,a)) {
                pixels[offset + 3] = 0
            }
        }
        return imageData
    }
    
    func getImageData()->[UInt8]? {
        return Image.makeBytes(from: self.image)
    }
    
    func scaleTo(size maxSize: CGFloat?, quality: Int) {
        let width = image.size.width
        let height = image.size.height
        
        var ratio:CGFloat = 1.0
        if maxSize != nil && maxSize! > 0 {
            let maxSide = max(width, height)
            if maxSide > CGFloat(maxSize!) {
                ratio = CGFloat(maxSize!) / maxSide
            }
        } else {
            ratio = 1 / CGFloat(quality)
        }
        if ratio < 1 {
            self.scale(by: ratio)
        }
    }
    
    func scale(by scale: CGFloat) {
        self.image = Image.scaleImage(image: self.image, by: scale)
    }
    
    private static func scaleImage(image: UIImage, by scale: CGFloat)->UIImage {
        if scale == 1 { return image }
        
        let imageRef = image.cgImage!
        let width = imageRef.width
        let height = imageRef.height
        
        var bounds = CGSize(width: width, height: height)
        
        bounds.width = CGFloat(width) * scale
        bounds.height = CGFloat(height) * scale
        
        UIGraphicsBeginImageContext(bounds)
        image.draw(in: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy ?? image
    }
    
    private static func makeBytes(from image: UIImage) -> [UInt8]? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        if isCompatibleImage(cgImage) {
            return makeBytesFromCompatibleImage(cgImage)
        } else {
            return makeBytesFromIncompatibleImage(cgImage)
        }
    }
    
    private static func isCompatibleImage(_ cgImage: CGImage) -> Bool {
        guard let colorSpace = cgImage.colorSpace else {
            return false
        }
        if colorSpace.model != .rgb {
            return false
        }
        let bitmapInfo = cgImage.bitmapInfo
        let alpha = bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let alphaRequirement = (alpha == CGImageAlphaInfo.noneSkipLast.rawValue || alpha == CGImageAlphaInfo.last.rawValue)
        let byteOrder = bitmapInfo.rawValue & CGBitmapInfo.byteOrderMask.rawValue
        let byteOrderRequirement = (byteOrder == CGBitmapInfo.byteOrder32Little.rawValue)
        if !(alphaRequirement && byteOrderRequirement) {
            return false
        }
        if cgImage.bitsPerComponent != 8 {
            return false
        }
        if cgImage.bitsPerPixel != 32 {
            return false
        }
        if cgImage.bytesPerRow != cgImage.width * 4 {
            return false
        }
        return true
    }
    private static func makeBytesFromCompatibleImage(_ image: CGImage) -> [UInt8]? {
        guard let dataProvider = image.dataProvider else {
            return nil
        }
        guard let data = dataProvider.data else {
            return nil
        }
        let length = CFDataGetLength(data)
        var rawData = [UInt8](repeating: 0, count: length)
        CFDataGetBytes(data, CFRange(location: 0, length: length), &rawData)
        return rawData
    }
    
    private static func makeBytesFromIncompatibleImage(_ image: CGImage) -> [UInt8]? {
        let width = image.width
        let height = image.height
        var rawData = [UInt8](repeating: 0, count: width * height * 4)
        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
            return nil
        }
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return rawData
    }
}

//
//  MMCQ.swift
//  ColorThiefSwift
//
//  Created by Kazuki Ohara on 2017/02/11.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//
//  License
//  -------
//  MIT License
//  https://github.com/yamoridon/ColorThiefSwift/blob/master/LICENSE
//
//  Thanks
//  ------
//  Lokesh Dhakar - for the original Color Thief JavaScript version
//  http://lokeshdhakar.com/projects/color-thief/
//  Sven Woltmann - for the fast Java Implementation
//  https://github.com/SvenWoltmann/color-thief-java

/// MMCQ (modified median cut quantization) algorithm from
/// the Leptonica library (http://www.leptonica.com/).

/// Get reduced-space color index for a pixel.
///
/// - Parameters:
///   - red: the red value
///   - green: the green value
///   - blue: the blue value
/// - Returns: the color index
struct Color {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    
    init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    func makeUIColor() -> UIColor {
        return UIColor(red: CGFloat(r) / CGFloat(255), green: CGFloat(g) / CGFloat(255), blue: CGFloat(b) / CGFloat(255), alpha: CGFloat(1))
    }
}

enum ColorChannel {
    case r
    case g
    case b
}

/// 3D color space box.


/// Color map.
class ColorMap {
    
    var vboxes = [VBox]()
    
    func push(_ vbox: VBox) {
        vboxes.append(vbox)
    }
    
    func makePalette() -> [Color] {
        return vboxes.map { $0.getAverage() }
    }
    
    func makeNearestColor(to color: Color) -> Color {
        var nearestDistance = Int.max
        var nearestColor = Color(r: 0, g: 0, b: 0)
        
        for vbox in vboxes {
            let vbColor = vbox.getAverage()
            let dr = abs(Int(color.r) - Int(vbColor.r))
            let dg = abs(Int(color.g) - Int(vbColor.g))
            let db = abs(Int(color.b) - Int(vbColor.b))
            let distance = dr + dg + db
            if distance < nearestDistance {
                nearestDistance = distance
                nearestColor = vbColor
            }
        }
        
        return nearestColor
    }
}

/// Histo (1-d array, giving the number of pixels in each quantized region of color space), or null on error.
internal func makeHistogramAndVBox(from pixels: [UInt8], quality: Int, ignoreWhite: Bool) -> ([Int], VBox) {
    var histogram = [Int](repeating: 0, count: histogramSize)
    var rMin = UInt8.max
    var rMax = UInt8.min
    var gMin = UInt8.max
    var gMax = UInt8.min
    var bMin = UInt8.max
    var bMax = UInt8.min
    
    let pixelCount = pixels.count / 4
    for i in stride(from: 0, to: pixelCount, by: quality) {
        let a = pixels[i * 4 + 0]
        let b = pixels[i * 4 + 1]
        let g = pixels[i * 4 + 2]
        let r = pixels[i * 4 + 3]
        
        // If pixel is not mostly opaque or white
        guard a >= 125 && !(ignoreWhite && r > 250 && g > 250 && b > 250) else {
            continue
        }
        
        let shiftedR = r >> UInt8(rightShift)
        let shiftedG = g >> UInt8(rightShift)
        let shiftedB = b >> UInt8(rightShift)
        
        // find min/max
        rMin = min(rMin, shiftedR)
        rMax = max(rMax, shiftedR)
        gMin = min(gMin, shiftedG)
        gMax = max(gMax, shiftedG)
        bMin = min(bMin, shiftedB)
        bMax = max(bMax, shiftedB)
        
        // increment histgram
        let index = makeColorIndexOf(red: Int(shiftedR), green: Int(shiftedG), blue: Int(shiftedB))
        histogram[index] += 1
    }
    
    let vbox = VBox(rMin: rMin, rMax: rMax, gMin: gMin, gMax: gMax, bMin: bMin, bMax: bMax, histogram: histogram)
    return (histogram, vbox)
}
//
//  Quantize.swift
//  swift-vibrant
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//

class Quantizer {
    typealias quantizer = (_ pixels: [UInt8], _ options: VibrantManager.Options)->[Swatch]
    
    static let defaultQuantizer: quantizer = Quantizer().quantize
    
    private func quantize(pixels: [UInt8], options: VibrantManager.Options)->[Swatch] {
        let quality = options.quality
        let colorcount = options.colorCount
        return Quantizer.vibrantQuantizer(pixels: pixels, quality: quality, colorCount: colorcount)
    }
    
    private static func splitBoxes (_ pq: inout [VBox], _ target: Int, hist: [Int]) {
        var lastSize = pq.count
        while pq.count < target {
            let vbox = pq.popLast()
            
            if (vbox != nil && vbox!.getCount() > 0) {
                let vboxes = applyMedianCut(with: hist, vbox: vbox!)
                let vbox1 = vboxes.count > 0 ? vboxes[0] : nil
                let vbox2 = vboxes.count > 1 ? vboxes[1] : nil
                pq.append(vbox1!)
                if vbox2 != nil && vbox2!.getCount() > 0 { pq.append(vbox2!) }
                
                if pq.count == lastSize {
                    break
                } else {
                    lastSize = pq.count
                }
            } else {
                break
            }
        }
    }
    
    static func vibrantQuantizer(pixels: [UInt8], quality: Int, colorCount: Int)->[Swatch] {
        let (hist, vbox) = makeHistogramAndVBox(from: pixels, quality: quality, ignoreWhite: false)
        var pq = [vbox]
        splitBoxes(&pq, Int(fractionByPopulation * Double(colorCount)), hist: hist)
        pq.sort { (a, b) -> Bool in
            a.getCount() * a.getVolume() > b.getCount() * b.getVolume()
        }
        splitBoxes(&pq, colorCount - pq.count, hist: hist)
        return generateSwatches(pq)
    }
    
    private static func generateSwatches (_ pq: [VBox])->[Swatch] {
        return pq.map { (box) in
            let color = box.rgb()
            return Swatch(color, box.getCount())
        }
    }
}

//
//  Util.swift
//  swift-vibrant
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//

internal func applyMedianCut(with histogram: [Int], vbox: VBox) -> [VBox] {
    guard vbox.getCount() != 0 else {
        return []
    }
    
    // only one pixel, no split
    guard vbox.getCount() != 1 else {
        return [vbox]
    }
    
    // Find the partial sum arrays along the selected axis.
    var total = 0
    var partialSum = [Int](repeating: -1, count: vboxLength) // -1 = not set / 0 = 0
    
    let axis = vbox.widestColorChannel()
    switch axis {
    case .r:
        for i in vbox.rRange {
            var sum = 0
            for j in vbox.gRange {
                for k in vbox.bRange {
                    let index = makeColorIndexOf(red: i, green: j, blue: k)
                    sum += histogram[index]
                }
            }
            total += sum
            partialSum[i] = total
        }
    case .g:
        for i in vbox.gRange {
            var sum = 0
            for j in vbox.rRange {
                for k in vbox.bRange {
                    let index = makeColorIndexOf(red: j, green: i, blue: k)
                    sum += histogram[index]
                }
            }
            total += sum
            partialSum[i] = total
        }
    case .b:
        for i in vbox.bRange {
            var sum = 0
            for j in vbox.rRange {
                for k in vbox.gRange {
                    let index = makeColorIndexOf(red: j, green: k, blue: i)
                    sum += histogram[index]
                }
            }
            total += sum
            partialSum[i] = total
        }
    }
    
    var lookAheadSum = [Int](repeating: -1, count: vboxLength) // -1 = not set / 0 = 0
    for (i, sum) in partialSum.enumerated() where sum != -1 {
        lookAheadSum[i] = total - sum
    }
    
    return cut(by: axis, vbox: vbox, partialSum: partialSum, lookAheadSum: lookAheadSum, total: total)
}

internal func cut(by axis: ColorChannel, vbox: VBox, partialSum: [Int], lookAheadSum: [Int], total: Int) -> [VBox] {
    let vboxMin: Int
    let vboxMax: Int
    
    switch axis {
    case .r:
        vboxMin = Int(vbox.rMin)
        vboxMax = Int(vbox.rMax)
    case .g:
        vboxMin = Int(vbox.gMin)
        vboxMax = Int(vbox.gMax)
    case .b:
        vboxMin = Int(vbox.bMin)
        vboxMax = Int(vbox.bMax)
    }
    
    for i in vboxMin ... vboxMax where partialSum[i] > total / 2 {
        let vbox1 = VBox(vbox: vbox)
        let vbox2 = VBox(vbox: vbox)
        
        let left = i - vboxMin
        let right = vboxMax - i
        
        var d2: Int
        if left <= right {
            d2 = min(vboxMax - 1, i + right / 2)
        } else {
            // 2.0 and cast to int is necessary to have the same
            // behaviour as in JavaScript
            d2 = max(vboxMin, Int(Double(i - 1) - Double(left) / 2.0))
        }
        
        // avoid 0-count
        while d2 < 0 || partialSum[d2] <= 0 {
            d2 += 1
        }
        var count2 = lookAheadSum[d2]
        while count2 == 0 && d2 > 0 && partialSum[d2 - 1] > 0 {
            d2 -= 1
            count2 = lookAheadSum[d2]
        }
        
        // set dimensions
        switch axis {
        case .r:
            vbox1.rMax = UInt8(d2)
            vbox2.rMin = UInt8(d2 + 1)
        case .g:
            vbox1.gMax = UInt8(d2)
            vbox2.gMin = UInt8(d2 + 1)
        case .b:
            vbox1.bMax = UInt8(d2)
            vbox2.bMin = UInt8(d2 + 1)
        }
        
        return [vbox1, vbox2]
    }
    
    fatalError("VBox can't be cut")
}

internal func iterate(over queue: inout [VBox], comparator: (VBox, VBox) -> Bool, target: Int, histogram: [Int]) {
    var color = 1
    
    for _ in 0 ..< maxIterations {
        guard let vbox = queue.last else {
            return
        }
        
        if vbox.getCount() == 0 {
            queue.sort(by: comparator)
            continue
        }
        queue.removeLast()
        
        // do the cut
        let vboxes = applyMedianCut(with: histogram, vbox: vbox)
        queue.append(vboxes[0])
        if vboxes.count == 2 {
            queue.append(vboxes[1])
            color += 1
        }
        queue.sort(by: comparator)
        
        if color >= target {
            return
        }
    }
}

internal func compareByCount(_ a: VBox, _ b: VBox) -> Bool {
    return a.getCount() < b.getCount()
}

internal func compareByProduct(_ a: VBox, _ b: VBox) -> Bool {
    let aCount = a.getCount()
    let bCount = b.getCount()
    let aVolume = a.getVolume()
    let bVolume = b.getVolume()
    
    if aCount == bCount {
        // If count is 0 for both (or the same), sort by volume
        return aVolume < bVolume
    } else {
        // Otherwise sort by products
        let aProduct = Int64(aCount) * Int64(aVolume)
        let bProduct = Int64(bCount) * Int64(bVolume)
        return aProduct < bProduct
    }
}

func makeColorIndexOf(red: Int, green: Int, blue: Int) -> Int {
    return (red << (2 * signalBits)) + (green << signalBits) + blue
}

func apply<T, V>(_ fn: (T) -> V, _ args: T) -> V {
    return fn(args)
}
//
//  Vbox.swift
//  swift-vibrant
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//



class VBox {
    
    var rMin: UInt8
    var rMax: UInt8
    var gMin: UInt8
    var gMax: UInt8
    var bMin: UInt8
    var bMax: UInt8
    
    private let histogram: [Int]
    
    private var average: Color?
    private var volume: Int?
    private var count: Int?
    
    init(rMin: UInt8, rMax: UInt8, gMin: UInt8, gMax: UInt8, bMin: UInt8, bMax: UInt8, histogram: [Int]) {
        self.rMin = rMin
        self.rMax = rMax
        self.gMin = gMin
        self.gMax = gMax
        self.bMin = bMin
        self.bMax = bMax
        self.histogram = histogram
    }
    
    init(vbox: VBox) {
        self.rMin = vbox.rMin
        self.rMax = vbox.rMax
        self.gMin = vbox.gMin
        self.gMax = vbox.gMax
        self.bMin = vbox.bMin
        self.bMax = vbox.bMax
        self.histogram = vbox.histogram
    }
    
    func makeRange(min: UInt8, max: UInt8) -> CountableRange<Int> {
        if min <= max {
            return Int(min) ..< Int(max + 1)
        } else {
            return Int(max) ..< Int(max)
        }
    }
    
    var rRange: CountableRange<Int> { return makeRange(min: rMin, max: rMax) }
    var gRange: CountableRange<Int> { return makeRange(min: gMin, max: gMax) }
    var bRange: CountableRange<Int> { return makeRange(min: bMin, max: bMax) }
    
    /// Get 3 dimensional volume of the color space
    ///
    /// - Parameter force: force recalculate
    /// - Returns: the volume
    func getVolume(forceRecalculate force: Bool = false) -> Int {
        if let volume = volume, !force {
            return volume
        } else {
            let volume = (Int(rMax) - Int(rMin) + 1) * (Int(gMax) - Int(gMin) + 1) * (Int(bMax) - Int(bMin) + 1)
            self.volume = volume
            return volume
        }
    }
    
    /// Get total count of histogram samples
    ///
    /// - Parameter force: force recalculate
    /// - Returns: the volume
    func getCount(forceRecalculate force: Bool = false) -> Int {
        if let count = count, !force {
            return count
        } else {
            var count = 0
            for i in rRange {
                for j in gRange {
                    for k in bRange {
                        let index = makeColorIndexOf(red: i, green: j, blue: k)
                        count += histogram[index]
                    }
                }
            }
            self.count = count
            return count
        }
    }
    
    func getAverage(forceRecalculate force: Bool = false) -> Color {
        if let average = average, !force {
            return average
        } else {
            var ntot = 0
            
            var rSum = 0
            var gSum = 0
            var bSum = 0
            
            for i in rRange {
                for j in gRange {
                    for k in bRange {
                        let index = makeColorIndexOf(red: i, green: j, blue: k)
                        let hval = histogram[index]
                        ntot += hval
                        rSum += Int(Double(hval) * (Double(i) + 0.5) * Double(multiplier))
                        gSum += Int(Double(hval) * (Double(j) + 0.5) * Double(multiplier))
                        bSum += Int(Double(hval) * (Double(k) + 0.5) * Double(multiplier))
                    }
                }
            }
            
            let average: Color
            if ntot > 0 {
                let r = UInt8(rSum / ntot)
                let g = UInt8(gSum / ntot)
                let b = UInt8(bSum / ntot)
                average = Color(r: r, g: g, b: b)
            } else {
                let r = UInt8(min(multiplier * (Int(rMin) + Int(rMax) + 1) / 2, 255))
                let g = UInt8(min(multiplier * (Int(gMin) + Int(gMax) + 1) / 2, 255))
                let b = UInt8(min(multiplier * (Int(bMin) + Int(bMax) + 1) / 2, 255))
                average = Color(r: r, g: g, b: b)
            }
            
            self.average = average
            return average
        }
    }
    
    
    func rgb() -> RGB {
        let color = self.getAverage()
        return (color.r, color.g, color.b)
    }
    
    func widestColorChannel() -> ColorChannel {
        let rWidth = rMax - rMin
        let gWidth = gMax - gMin
        let bWidth = bMax - bMin
        switch max(rWidth, gWidth, bWidth) {
        case rWidth:
            return .r
        case gWidth:
            return .g
        default:
            return .b
        }
    }
    
}
//
//  Vibrant.swift
//  swift-vibrant-ios
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//

class VibrantManager {
    struct Options {
        var colorCount: Int = 64
        
        var quality: Int = 5
        
        var quantizer: Quantizer.quantizer = Quantizer.defaultQuantizer
        
        var generator: Generator.generator = Generator.defaultGenerator
        
        var maxDimension: CGFloat?
        
        var filters: [Filter] = [Filter.defaultFilter]
        
        fileprivate var combinedFilter: Filter?
    }
    
    static func from( _ src: UIImage)->Builder {
        return Builder(src)
    }
    
    var opts: Options
    var src: UIImage
    
    private var _palette: CGVibrantPalette?
    var palette: CGVibrantPalette? { _palette }
    
    init(src: UIImage, opts: Options?) {
        self.src = src
        self.opts = opts ?? Options()
        self.opts.combinedFilter = Filter.combineFilters(filters: self.opts.filters)
    }
    
    static func process(image: Image, opts: Options)->CGVibrantPalette {
        let quantizer = opts.quantizer
        let generator = opts.generator
        let combinedFilter = opts.combinedFilter!
        let maxDimension = opts.maxDimension
        
        image.scaleTo(size: maxDimension, quality: opts.quality)
        
        
        let imageData = image.applyFilter(combinedFilter)
        let swatches = quantizer(imageData, opts)
        let colors = Swatch.applyFilter(colors: swatches, filter: combinedFilter)
        let palette = generator(colors)
        return palette
    }
    
    func getPalette(_ cb: @escaping Callback<CGVibrantPalette>) {
        DispatchQueue.init(label: "colorProcessor", qos: .background).async {
            let palette = self.getPalette()
            DispatchQueue.main.async {
                cb(palette)
            }
        }
    }
    
    func getPalette()->CGVibrantPalette {
        let image = Image(image: self.src)
        let palette = VibrantManager.process(image: image, opts: self.opts)
        self._palette = palette
        return palette
    }
}
//
//  VibrantColors.swift
//  swift-vibrant-ios
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//



typealias Vec3<T> = (T, T, T)
typealias RGB = (r: UInt8, g: UInt8, b: UInt8)
typealias HSL = (h: Double, s: Double, l: Double)
typealias XYZ = (x: Double, y: Double, z: Double)
typealias LAB = (L: Double, a: Double, b: Double)


//export type Vec3 = [Double, Double, Double]
//

public struct CGVibrantPalette {
    var _vibrant: Swatch?
    var _muted: Swatch?
    var _darkVibrant: Swatch?
    var _darkMuted: Swatch?
    var _lightVibrant: Swatch?
    var _lightMuted: Swatch?
    
    public var vibrant: CGColor? { self._vibrant?.cgColor }
    public var muted: CGColor? { self._muted?.cgColor }
    public var darkVibrant: CGColor? { self._darkVibrant?.cgColor }
    public var darkMuted: CGColor? { self._darkMuted?.cgColor }
    public var lightVibrant: CGColor? { self._lightVibrant?.cgColor }
    public var lightMuted: CGColor? { self._lightMuted?.cgColor }
}

class Swatch: Equatable {
    
    private var _hsl: HSL?
    
    private var _rgb: RGB
    
    private var _yiq: Double?
    
    private var _population: Int
    
    private var _hex: String?
    
    private var _uiColor: UIColor?
    
    var r: UInt8 { self._rgb.r }
    
    var g: UInt8 { self._rgb.g }
    
    var b: UInt8 { self._rgb.b }
    
    var rgb: RGB { self._rgb }
    
    var hsl: HSL {
        if self._hsl == nil {
            let rgb = self._rgb
            self._hsl = apply(rgbToHsl, rgb)
        }
        return self._hsl!
    }
    
    var hex: String {
        if self._hex == nil {
            let rgb = self._rgb
            self._hex = apply(rgbToHex, rgb)
        }
        return self._hex!
    }
    
    
    var uiColor: UIColor {
        if self._uiColor == nil {
            let rgb = self._rgb
            self._uiColor = apply(rgbToUIColor, rgb)
        }
        return self._uiColor!
    }
    
    var cgColor: CGColor {
        return self.uiColor.cgColor
    }
    
    static func applyFilter(colors: [Swatch], filter: Filter)->[Swatch] {
        var colors = colors
        colors = colors.filter { (swatch) -> Bool in
            let r = swatch.r
            let g = swatch.g
            let b = swatch.b
            return filter.f(r, g, b, 255)
        }
        return colors
    }
    
    var population: Int { self._population }
    
    
    func toDict()->[String: Any] {
        return [
            "rgb": self.rgb,
            "population": self.population
        ]
    }
    
    var toJSON = toDict
    
    private func getYiq()->Double {
        if self._yiq == nil {
            let (r,g,b) = self._rgb
            let mr = Int(r) * 299
            let mg = Int(g) * 598
            let mb = Int(b) * 114
            let mult = mr + mg + mb
            self._yiq =  Double(mult) / 1000
        }
        return self._yiq!
    }
    
    private var _titleTextColor: UIColor?
    
    private var _bodyTextColor: UIColor?
    
    var titleTextColor: UIColor {
        if self._titleTextColor == nil {
            self._titleTextColor = self.getYiq() < 200 ? .white : .black
        }
        return self._titleTextColor!
    }
    
    var bodyTextColor: UIColor {
        if self._bodyTextColor == nil {
            self._bodyTextColor = self.getYiq() < 150 ? .white : .black
        }
        return self._bodyTextColor!
    }
    
    func getTitleTextColor()->UIColor {
        return self.titleTextColor
    }
    
    func getBodyTextColor()->UIColor {
        return self.bodyTextColor
    }
    
    static func == (lhs: Swatch, rhs: Swatch) -> Bool {
        return lhs.rgb == rhs.rgb
    }
    
    init(_ rgb: RGB, _ population: Int) {
        self._rgb = rgb
        self._population = population
    }
}
#endif
