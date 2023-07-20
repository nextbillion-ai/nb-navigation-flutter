//
//  Light.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/3/6.
//

import Foundation
import NbmapNavigation

open class CustomDayStyle: DayStyle {
    
    public var arrivalTimeLabelFont: UIFont?
    public var arrivalTimeLabelNormalTextColor: UIColor?
    public var bottomBannerContentViewBackgroundColor: UIColor?
    public var bottomBannerViewBackgroundColor: UIColor?
    public var buttonTextColor: UIColor?
    public var cancelButtonBackgroundColor: UIColor?
    public var cancelButtonTextFont: UIFont?
    public var cancelButtonTextColor: UIColor?
    public var overviewButtonBorderColor: UIColor?
    public var overviewButtonTintColor: UIColor?
    public var dismissButtonBackgroundColor: UIColor?
    public var dismissButtonTextColor: UIColor?
    public var dismissButtonTextFont: UIFont?
    public var distanceLabelUnitFont: UIFont?
    public var distanceLabelValueFont: UIFont?
    public var distanceLabelInstructionsUnitColor: UIColor?
    public var distanceLabelInstructionsValueColor: UIColor?
    public var distanceLabelStepInstructionsUnitColor: UIColor?
    public var distanceLabelStepInstructionsValueColor: UIColor?
    public var distanceRemainingLabelFont: UIFont?
    public var distanceRemainingLabelNormalTextColor: UIColor?
    public var endOfRouteButtonTextColor: UIColor?
    public var endOfRouteButtonTextFont: UIFont?
    public var endOfRouteContentViewBackgroundColor: UIColor?
    public var endOfRouteStaticLabelNormalFont: UIFont?
    public var endOfRouteStaticLabelNormalTextColor: UIColor?
    public var endOfRouteTitleLabelNormalFont: UIFont?
    public var endOfRouteTitleLabelNormalTextColor: UIColor?
    public var floatingButtonBackgroundColor: UIColor?
    public var floatingButtonTintColor: UIColor?
    public var genericRouteShieldBackgroundColor: UIColor?
    public var instructionsBannerContentBackgroundColor: UIColor?
    public var instructionsBannerViewBackgroundColor: UIColor?
    public var laneViewPrimaryColor: UIColor?
    public var laneViewSecondaryColor: UIColor?
    public var lanesViewBackgroundColor: UIColor?
    public var lineViewLineColor: UIColor?
    public var maneuverViewBackgroundColor: UIColor?
    public var maneuverInstructionsBannerPrimaryColor: UIColor?
    public var maneuverInstructionsBannerSecondaryColor: UIColor?
    public var maneuverNextBannerPrimaryColor: UIColor?
    public var maneuverNextBannerSecondaryColor: UIColor?
    public var maneuverStepInstructionsPrimaryColor: UIColor?
    public var maneuverStepInstructionsSecondaryColor: UIColor?
    public var maneuverArrowColor: UIColor?
    public var maneuverArrowStrokeColor: UIColor?
    public var routeAlternateColor: UIColor?
    public var routeCasingColor: UIColor?
    public var trafficHeavyColor: UIColor?
    public var trafficLowColor: UIColor?
    public var trafficModerateColor: UIColor?
    public var trafficSevereColor: UIColor?
    public var trafficUnknownColor: UIColor?
    public var navigationViewBackgroundColor: UIColor?
    public var nextBannerViewBackgroundColor: UIColor?
    public var nextInstructionLabelFont: UIFont?
    public var nextInstructionLabelNormalTextColor: UIColor?
    public var primaryLabelNormalFont: UIFont?
    public var primaryLabelInstructionsBannerTextColor: UIColor?
    public var primaryLabelStepInstructionsTextColor: UIColor?
    public var primaryLabelStepInstructionsFont: UIFont?
    public var resumeButtonBackgroundColor: UIColor?
    public var resumeButtonTintColor: UIColor?
    public var secondaryLabeNormalFont: UIFont?
    public var secondaryLabelInstructionsBannerTextColor: UIColor?
    public var secondaryLabelStepInstructionsTextColor: UIColor?
    public var separatorViewBackgroundColor: UIColor?
    public var statusViewBackgroundColor: UIColor?
    public var stepInstructionsViewBackgroundColor: UIColor?
    public var stepTableViewCellBackgroundColor: UIColor?
    public var stepsBackgroundColor: UIColor?
    public var timeRemainingLabelFont: UIFont?
    public var timeRemainingLabelTextColor: UIColor?
    public var timeRemainingLabelTrafficHeavyColor: UIColor?
    public var timeRemainingLabelTrafficLowColor: UIColor?
    public var timeRemainingLabelTrafficModerateColor: UIColor?
    public var timeRemainingLabelTrafficSevereColor: UIColor?
    public var timeRemainingLabelTrafficUnknownColor: UIColor?
    public var speedViewTextColor: UIColor?
    public var speedViewSignBackColor: UIColor?
    
    @objc open override func apply() {
        super.apply()
        ArrivalTimeLabel.appearance().font = arrivalTimeLabelFont ?? UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        ArrivalTimeLabel.appearance().normalTextColor = arrivalTimeLabelNormalTextColor ?? #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        BottomBannerContentView.appearance().backgroundColor = bottomBannerContentViewBackgroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        BottomBannerView.appearance().backgroundColor = bottomBannerViewBackgroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Button.appearance().textColor = buttonTextColor ?? #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        CancelButton.appearance().backgroundColor = cancelButtonBackgroundColor ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        CancelButton.appearance().textFont = cancelButtonTextFont ?? UIFont.systemFont(ofSize: 16, weight: .regular).adjustedFont
        CancelButton.appearance().textColor = cancelButtonTextColor ?? #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
        OverviewButton.appearance().borderColor = overviewButtonBorderColor ?? #colorLiteral(red: 0.94117647, green: 0.95294118, blue: 1, alpha: 1)
        OverviewButton.appearance().tintColor = overviewButtonTintColor ?? #colorLiteral(red: 0.2566259801, green: 0.3436664343, blue: 0.8086165786, alpha: 0.6812137831)
        DismissButton.appearance().backgroundColor = dismissButtonBackgroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        DismissButton.appearance().textColor = dismissButtonTextColor ?? #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        DismissButton.appearance().textFont = dismissButtonTextFont ?? UIFont.systemFont(ofSize: 20, weight: .medium).adjustedFont
        DistanceLabel.appearance().unitFont = distanceLabelUnitFont ?? UIFont.systemFont(ofSize: 14, weight: .medium).adjustedFont
        DistanceLabel.appearance().valueFont = distanceLabelValueFont ?? UIFont.systemFont(ofSize: 22, weight: .medium).adjustedFont
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).unitTextColor = distanceLabelInstructionsUnitColor ?? #colorLiteral(red: 0.980392158, green: 0.980392158, blue: 0.980392158, alpha: 1)
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).valueTextColor = distanceLabelInstructionsValueColor ?? #colorLiteral(red: 0.980392158, green: 0.980392158, blue: 0.980392158, alpha: 1)
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).unitTextColor = distanceLabelStepInstructionsUnitColor ?? #colorLiteral(red: 0.3999999762, green: 0.3999999762, blue: 0.3999999762, alpha: 1)
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).valueTextColor = distanceLabelStepInstructionsValueColor ?? #colorLiteral(red: 0.3999999762, green: 0.3999999762, blue: 0.3999999762, alpha: 1)
        DistanceRemainingLabel.appearance().font = distanceRemainingLabelFont ?? UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        DistanceRemainingLabel.appearance().normalTextColor = distanceRemainingLabelNormalTextColor ?? #colorLiteral(red: 0.3999999762, green: 0.3999999762, blue: 0.3999999762, alpha: 1)
        EndOfRouteButton.appearance().textColor = endOfRouteButtonTextColor ?? .darkGray
        EndOfRouteButton.appearance().textFont = endOfRouteButtonTextFont ?? .systemFont(ofSize: 15)
        EndOfRouteContentView.appearance().backgroundColor = endOfRouteContentViewBackgroundColor ?? .white
        EndOfRouteStaticLabel.appearance().normalFont = endOfRouteStaticLabelNormalFont ?? .systemFont(ofSize: 14.0)
        EndOfRouteStaticLabel.appearance().normalTextColor = endOfRouteStaticLabelNormalTextColor ?? #colorLiteral(red: 0.217173934, green: 0.3645851612, blue: 0.489295125, alpha: 1)
        EndOfRouteTitleLabel.appearance().normalFont = endOfRouteTitleLabelNormalFont ?? .systemFont(ofSize: 36.0)
        EndOfRouteTitleLabel.appearance().normalTextColor = endOfRouteTitleLabelNormalTextColor ?? .black
        FloatingButton.appearance().backgroundColor = floatingButtonBackgroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        FloatingButton.appearance().tintColor = floatingButtonTintColor ?? tintColor
        GenericRouteShield.appearance().backgroundColor = genericRouteShieldBackgroundColor ?? .clear
        InstructionsBannerContentView.appearance().backgroundColor = instructionsBannerContentBackgroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        InstructionsBannerView.appearance().backgroundColor = instructionsBannerViewBackgroundColor ?? #colorLiteral(red: 0.2755675018, green: 0.7829894423, blue: 0.3109624088, alpha: 1)
        LaneView.appearance().primaryColor = laneViewPrimaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        LaneView.appearance().secondaryColor = laneViewSecondaryColor ?? #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        LanesView.appearance().backgroundColor = lanesViewBackgroundColor ?? #colorLiteral(red: 0.1522715986, green: 0.5290428996, blue: 0.1787364483, alpha: 1)
        LineView.appearance().lineColor = lineViewLineColor ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        ManeuverView.appearance().backgroundColor = maneuverViewBackgroundColor ?? .clear
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).primaryColor = maneuverInstructionsBannerPrimaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).secondaryColor = maneuverInstructionsBannerSecondaryColor ?? #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).primaryColor = maneuverNextBannerPrimaryColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).secondaryColor = maneuverNextBannerSecondaryColor ?? #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).primaryColor = maneuverStepInstructionsPrimaryColor ?? #colorLiteral(red: 0.2392157018, green: 0.2392157018, blue: 0.2392157018, alpha: 1)
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).secondaryColor = maneuverStepInstructionsSecondaryColor ?? #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        NavigationMapView.appearance().maneuverArrowColor       = maneuverArrowColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        NavigationMapView.appearance().maneuverArrowStrokeColor = maneuverArrowStrokeColor ?? #colorLiteral(red: 0.4520691633, green: 0.5277981758, blue: 0.9168900847, alpha: 1)
        NavigationMapView.appearance().routeAlternateColor      = routeAlternateColor ?? #colorLiteral(red: 0.760784328, green: 0.7607844472, blue: 0.7607844472, alpha: 1)
        NavigationMapView.appearance().routeCasingColor         = routeCasingColor ?? #colorLiteral(red: 0.1843137255, green: 0.4784313725, blue: 0.7764705882, alpha: 1)
        NavigationMapView.appearance().trafficHeavyColor        = trafficHeavyColor ?? #colorLiteral(red: 1, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        NavigationMapView.appearance().trafficLowColor          = trafficLowColor ?? #colorLiteral(red: 0.4520691633, green: 0.5277981758, blue: 0.9168900847, alpha: 1)
        NavigationMapView.appearance().trafficModerateColor     = trafficModerateColor ?? #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
        NavigationMapView.appearance().trafficSevereColor       = trafficSevereColor ?? #colorLiteral(red: 0.5607843137, green: 0.1411764706, blue: 0.2784313725, alpha: 1)
        NavigationMapView.appearance().trafficUnknownColor      = trafficUnknownColor ?? #colorLiteral(red: 0.4520691633, green: 0.5277981758, blue: 0.9168900847, alpha: 1)
        NavigationView.appearance().backgroundColor = navigationViewBackgroundColor ?? #colorLiteral(red: 0.764706, green: 0.752941, blue: 0.733333, alpha: 1)
        NextBannerView.appearance().backgroundColor = nextBannerViewBackgroundColor ?? #colorLiteral(red: 0.1522715986, green: 0.5290428996, blue: 0.1787364483, alpha: 1)
        NextInstructionLabel.appearance().font = nextInstructionLabelFont ?? UIFont.systemFont(ofSize: 20, weight: .medium).adjustedFont
        NextInstructionLabel.appearance().normalTextColor = nextInstructionLabelNormalTextColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        PrimaryLabel.appearance().normalFont = primaryLabelNormalFont ?? UIFont.systemFont(ofSize: 30, weight: .medium).adjustedFont
        PrimaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = primaryLabelInstructionsBannerTextColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        PrimaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = primaryLabelStepInstructionsTextColor ?? #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        PrimaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalFont = primaryLabelStepInstructionsFont ??  UIFont.systemFont(ofSize: 15, weight: .medium).adjustedFont
        ResumeButton.appearance().backgroundColor = resumeButtonBackgroundColor ?? #colorLiteral(red: 0.4609908462, green: 0.5315783024, blue: 0.9125307202, alpha: 1)
        ResumeButton.appearance().tintColor = resumeButtonTintColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        SecondaryLabel.appearance().normalFont = secondaryLabeNormalFont ?? UIFont.systemFont(ofSize: 26, weight: .medium).adjustedFont
        SecondaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = secondaryLabelInstructionsBannerTextColor ?? #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
        SecondaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = secondaryLabelStepInstructionsTextColor ?? #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
        SeparatorView.appearance().backgroundColor = separatorViewBackgroundColor ?? #colorLiteral(red: 0.737254902, green: 0.7960784314, blue: 0.8705882353, alpha: 1)
        StatusView.appearance().backgroundColor = statusViewBackgroundColor ?? UIColor.black.withAlphaComponent(2.0/3.0)
        StepInstructionsView.appearance().backgroundColor = stepInstructionsViewBackgroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        StepTableViewCell.appearance().backgroundColor = stepTableViewCellBackgroundColor ?? #colorLiteral(red: 0.9675388083, green: 0.9675388083, blue: 0.9675388083, alpha: 1)
        StepsBackgroundView.appearance().backgroundColor = stepsBackgroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        TimeRemainingLabel.appearance().font = timeRemainingLabelFont ?? UIFont.systemFont(ofSize: 28, weight: .medium).adjustedFont
        TimeRemainingLabel.appearance().normalTextColor = timeRemainingLabelTextColor ?? #colorLiteral(red: 0.176, green: 0.176, blue: 0.176, alpha: 1)
        TimeRemainingLabel.appearance().trafficHeavyColor = timeRemainingLabelTrafficHeavyColor ?? #colorLiteral(red:0.91, green:0.20, blue:0.25, alpha:1.0)
        TimeRemainingLabel.appearance().trafficLowColor = timeRemainingLabelTrafficLowColor ?? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        TimeRemainingLabel.appearance().trafficModerateColor = timeRemainingLabelTrafficModerateColor ?? #colorLiteral(red:0.95, green:0.65, blue:0.31, alpha:1.0)
        TimeRemainingLabel.appearance().trafficSevereColor = timeRemainingLabelTrafficSevereColor ?? #colorLiteral(red: 0.7705719471, green: 0.1753477752, blue: 0.1177056804, alpha: 1)
        TimeRemainingLabel.appearance().trafficUnknownColor = timeRemainingLabelTrafficUnknownColor ?? #colorLiteral(red: 0.176, green: 0.176, blue: 0.176, alpha: 1)
//        UserPuckCourseView.appearance().puckColor = #colorLiteral(red: 0.4609908462, green: 0.5315783024, blue: 0.9125307202, alpha: 1)
      
        SpeedView.appearance().textColor = speedViewTextColor ?? #colorLiteral(red: 0.176, green: 0.176, blue: 0.176, alpha: 1)
        SpeedView.appearance().signBackColor = speedViewSignBackColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
}
