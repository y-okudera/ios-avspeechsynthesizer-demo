//
//  AttributedSpeechViewController.swift
//  ios-avspeechsynthesizer-demo
//
//  Created by YukiOkudera on 2018/06/10.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

import AVFoundation
import UIKit

final class AttributedSpeechViewController: UIViewController {

    private let speechSynthesizer = AVSpeechSynthesizer()
    private let baseString = "Yuki"
    private var attributedString: NSMutableAttributedString!
    private var utterance: AVSpeechUtterance!
    @IBOutlet private weak var speakButton: UIButton!
    @IBOutlet private weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let rangeAll = NSMakeRange(0, baseString.count)
        attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(
            NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute),
            value: "yueu.uː.ki",
            range: rangeAll
        )
        utterance = AVSpeechUtterance(attributedString: attributedString)
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        updateUtterance(attributed: false)
        speechSynthesizer.delegate = self
    }

    private func updateUtterance(attributed: Bool) {
        if attributed {
            utterance = AVSpeechUtterance(attributedString: attributedString)
            speakButton.setTitle("speak(attributed)", for: .normal)
        } else {
            utterance = AVSpeechUtterance(string: baseString)
            speakButton.setTitle("speak", for: .normal)
        }
    }

    @IBAction private func didTapSpeakButton(_ sender: UIButton) {
        if speechSynthesizer.isSpeaking {
            print("already speaking...")
            return
        }
        textView.text = ""
        speechSynthesizer.speak(utterance)
    }

    @IBAction private func switchChanged(_ sender: UISwitch) {
        updateUtterance(attributed: sender.isOn)
    }
}

extension AttributedSpeechViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("Speech started")
        textView.text = "Speech started\n\n"
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Speech finished")
        textView.text = textView.text + "\n\nSpeech finished"
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           willSpeakRangeOfSpeechString characterRange: NSRange,
                           utterance: AVSpeechUtterance) {

        guard let rangeInString = Range(characterRange, in: utterance.speechString) else {
            return
        }
        let willSpeakText = utterance.speechString[rangeInString]
        print("Will speak: \(willSpeakText)")
        textView.text = textView.text + willSpeakText
    }
}
