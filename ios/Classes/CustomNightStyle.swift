//
//  Light.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/3/6.
//

import Foundation
import NbmapNavigation

open class CustomNightStyle: NightStyle {
    
    public var arrivalTimeLabelNormalTextColor: UIColor?
    public var bottomBannerContentViewBackgroundColor: UIColor?
    public var bottomBannerViewBackgroundColor: UIColor?
    public var buttonTextColor: UIColor?
    public var cancelButtonTextFont: UIFont?
    public var cancelButtonTextColor: UIColor?
    public var overviewButtonBorderColor: UIColor?
    public var overviewButtonTintColor: UIColor?
    public var dismissButtonBackgroundColor: UIColor?
    public var dismissButtonTextColor: UIColor?
    public var distanceLabelInstructionsUnitColor: UIColor?
    public var distanceLabelInstructionsValueColor: UIColor?
    public var distanceLabelStepInstructionsUnitColor: UIColor?
    public var distanceLabelStepInstructionsValueColor: UIColor?
    public var distanceRemainingLabelNormalTextColor: UIColor?
    public var endOfRouteButtonTextColor: UIColor?
    public var endOfRouteContentViewBackgroundColor: UIColor?
    public var floatingButtonBackgroundColor: UIColor?
    public var floatingButtonTintColor: UIColor?
    public var instructionsBannerContentBackgroundColor: UIColor?
    public var instructionsBannerViewBackgroundColor: UIColor?
    public var laneViewPrimaryColor: UIColor?
    public var lanesViewBackgroundColor: UIColor?
    public var maneuverViewBackgroundColor: UIColor?
    public var maneuverInstructionsBannerPrimaryColor: UIColor?
    public var maneuverInstructionsBannerSecondaryColor: UIColor?
    public var maneuverNextBannerPrimaryColor: UIColor?
    public var maneuverNextBannerSecondaryColor: UIColor?
    public var maneuverStepInstructionsPrimaryColor: UIColor?
    public var maneuverStepInstructionsSecondaryColor: UIColor?
    public var routeAlternateColor: UIColor?
    public var trafficUnknownColor: UIColor?
    public var navigationViewBackgroundColor: UIColor?
    public var nextBannerViewBackgroundColor: UIColor?
    public var nextInstructionLabelNormalTextColor: UIColor?
    public var primaryLabelInstructionsBannerTextColor: UIColor?
    public var primaryLabelStepInstructionsTextColor: UIColor?
    public var resumeButtonBackgroundColor: UIColor?
    public var resumeButtonTintColor: UIColor?
    public var secondaryLabelInstructionsBannerTextColor: UIColor?
    public var secondaryLabelStepInstructionsTextColor: UIColor?
    public var separatorViewBackgroundColor: UIColor?
    public var stepInstructionsViewBackgroundColor: UIColor?
    public var stepTableViewCellBackgroundColor: UIColor?
    public var stepsBackgroundColor: UIColor?
    public var timeRemainingLabelTextColor: UIColor?
    public var timeRemainingLabelTrafficUnknownColor: UIColor?
    public var speedViewTextColor: UIColor?
    public var speedViewSignBackColor: UIColor?
    
    @objc open override func apply() {
        super.apply()
        ArrivalTimeLabel.appearance().normalTextColor = arrivalTimeLabelNormalTextColor ?? #colorLiteral(red: 0.7991961837, green: 0.8232284188, blue: 0.8481693864, alpha: 1)
        BottomBannerContentView.appearance().backgroundColor = bottomBannerContentViewBackgroundColor ?? #colorLiteral(red: 0.1854747534, green: 0.2004796863, blue: 0.2470968068, alpha: 1)
        BottomBannerView.appearance().backgroundColor = bottomBannerViewBackgroundColor ?? #colorLiteral(red: 0.1854747534, green: 0.2004796863, blue: 0.2470968068, alpha: 1)
        Button.appearance().textColor = buttonTextColor ??  #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        CancelButton.appearance().textFont = cancelButtonTextFont ?? UIFont.systemFont(ofSize: 16, weight: .regular).adjustedFont
        CancelButton.appearance().textColor = cancelButtonTextColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        OverviewButton.appearance().borderColor = overviewButtonBorderColor ?? #colorLiteral(red: 0.94117647, green: 0.95294118, blue: 1, alpha: 1)
        OverviewButton.appearance().tintColor = overviewButtonTintColor ?? #colorLiteral(red: 0.2566259801, green: 0.3436664343, blue: 0.8086165786, alpha: 0.6812137831)
        DismissButton.appearance().backgroundColor = dismissButtonBackgroundColor ?? #colorLiteral(red: 0.1854747534, green: 0.2004796863, blue: 0.2470968068, alpha: 1)
        DismissButton.appearance().textColor = dismissButtonTextColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).unitTextColor = distanceLabelInstructionsUnitColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).valueTextColor = distanceLabelInstructionsValueColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).unitTextColor = distanceLabelStepInstructionsUnitColor ?? #colorLiteral(red: 0.7991961837, green: 0.8232284188, blue: 0.8481693864, alpha: 1)
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).valueTextColor = distanceLabelStepInstructionsValueColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        DistanceRemainingLabel.appearance().normalTextColor = distanceRemainingLabelNormalTextColor ?? #colorLiteral(red: 0.7991961837, green: 0.8232284188, blue: 0.8481693864, alpha: 1)
        EndOfRouteButton.appearance().textColor = endOfRouteButtonTextColor ?? .white
        EndOfRouteContentView.appearance().backgroundColor = endOfRouteContentViewBackgroundColor ?? #colorLiteral(red: 0.1854747534, green: 0.2004796863, blue: 0.2470968068, alpha: 1)
        FloatingButton.appearance().backgroundColor = floatingButtonBackgroundColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        FloatingButton.appearance().tintColor = floatingButtonTintColor ?? #colorLiteral(red: 0.1725490093, green: 0.1725490093, blue: 0.1725490093, alpha: 1)
        InstructionsBannerContentView.appearance().backgroundColor = instructionsBannerContentBackgroundColor ?? #colorLiteral(red: 0.1854747534, green: 0.2004796863, blue: 0.2470968068, alpha: 1)
        InstructionsBannerView.appearance().backgroundColor = instructionsBannerViewBackgroundColor ?? #colorLiteral(red: 0.2755675018, green: 0.7829894423, blue: 0.3109624088, alpha: 1)
        LaneView.appearance().primaryColor = laneViewPrimaryColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        LanesView.appearance().backgroundColor = lanesViewBackgroundColor ?? #colorLiteral(red: 0.1522715986, green: 0.5290428996, blue: 0.1787364483, alpha: 1)
        ManeuverView.appearance().backgroundColor = maneuverViewBackgroundColor ?? .clear
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).primaryColor = maneuverInstructionsBannerPrimaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).secondaryColor = maneuverInstructionsBannerSecondaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).primaryColor = maneuverNextBannerPrimaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).secondaryColor = maneuverNextBannerSecondaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).primaryColor = maneuverStepInstructionsPrimaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).secondaryColor = maneuverStepInstructionsSecondaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        NavigationMapView.appearance().routeAlternateColor = routeAlternateColor ?? #colorLiteral(red: 0.7991961837, green: 0.8232284188, blue: 0.8481693864, alpha: 1)
        NavigationView.appearance().backgroundColor = navigationViewBackgroundColor ?? #colorLiteral(red: 0.0470588, green: 0.0509804, blue: 0.054902, alpha: 1)
        NextBannerView.appearance().backgroundColor = nextBannerViewBackgroundColor ?? #colorLiteral(red: 0.1522715986, green: 0.5290428996, blue: 0.1787364483, alpha: 1)
        NextInstructionLabel.appearance().normalTextColor = nextInstructionLabelNormalTextColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        PrimaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = primaryLabelInstructionsBannerTextColor ?? #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1)
        PrimaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = primaryLabelStepInstructionsTextColor ?? #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1)
        ResumeButton.appearance().backgroundColor = resumeButtonBackgroundColor ?? #colorLiteral(red: 0.4609908462, green: 0.5315783024, blue: 0.9125307202, alpha: 1)
        ResumeButton.appearance().tintColor = resumeButtonTintColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        SecondaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = secondaryLabelInstructionsBannerTextColor ?? #colorLiteral(red: 0.7349056005, green: 0.7675836682, blue: 0.8063536286, alpha: 1)
        SecondaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = secondaryLabelStepInstructionsTextColor ?? #colorLiteral(red: 0.7349056005, green: 0.7675836682, blue: 0.8063536286, alpha: 1)
        SeparatorView.appearance().backgroundColor = separatorViewBackgroundColor ?? #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.6117647059, alpha: 0.796599912)
        StepInstructionsView.appearance().backgroundColor = stepInstructionsViewBackgroundColor ?? #colorLiteral(red: 0.1854747534, green: 0.2004796863, blue: 0.2470968068, alpha: 1)
        StepTableViewCell.appearance().backgroundColor = stepTableViewCellBackgroundColor ?? #colorLiteral(red: 0.1854747534, green: 0.2004796863, blue: 0.2470968068, alpha: 1)
        StepsBackgroundView.appearance().backgroundColor = stepsBackgroundColor ?? #colorLiteral(red: 0.103291966, green: 0.1482483149, blue: 0.2006777823, alpha: 1)
        TimeRemainingLabel.appearance().normalTextColor = timeRemainingLabelTextColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        TimeRemainingLabel.appearance().trafficUnknownColor = timeRemainingLabelTrafficUnknownColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        SpeedView.appearance().textColor = speedViewTextColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        SpeedView.appearance().signBackColor = speedViewSignBackColor ?? #colorLiteral(red: 0.3483417034, green: 0.3733484447, blue: 0.4411733449, alpha: 1)
        
    }
}
