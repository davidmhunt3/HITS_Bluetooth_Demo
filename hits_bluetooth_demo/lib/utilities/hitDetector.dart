import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'dart:math';

const HIT_DETECTED = 1;
const HIT_HARD_DETECTED = 2;
const HIT_DEBOUNCE = 3;
const HIT_NOT_DETECTED = 4;
const DEBOUNCE_TICKS = 10;
final hitThreshold = pow(kHitThreshold, 2);
final hardHitThreshold = pow(kHardHitThreshold, 2);

class HitDetector {
  int _hitState;
  int _debounceTickCount;
  double _currentHitMag; //actually magnitude squared
  bool _hitDetected;
  bool _hardHitDetected;
  bool _newHighG;
  double _highG;
  double _highG_sq; //the hardest hit recorded

  HitDetector() {
    _hitState = HIT_NOT_DETECTED;
    _debounceTickCount = DEBOUNCE_TICKS;
    _highG = 0.0;
    _highG_sq = 0.0;
    _hitDetected = false;
    _hardHitDetected = false;
    _newHighG = false;
  }

  void clockDetector(List<double> currentAcc) {
    calculateAccMagnitude(currentAcc);
    updateHardestHit();
    switch (_hitState) {
      case HIT_NOT_DETECTED:
        if (_currentHitMag >= hitThreshold) {
          _hitDetected = true;
          if (_currentHitMag >= hardHitThreshold) {
            _hardHitDetected = true;
            _hitState = HIT_HARD_DETECTED;
          } else {
            _hitState = HIT_DETECTED;
          }
        }
        break;
      case HIT_DETECTED:
        if (_currentHitMag < hitThreshold) {
          _hitState = HIT_DEBOUNCE;
        } else if (_currentHitMag >= hardHitThreshold) {
          _hardHitDetected = true;
          _hitState = HIT_HARD_DETECTED;
        }
        break;
      case HIT_HARD_DETECTED:
        if (_currentHitMag < hitThreshold) {
          _hitState = HIT_DEBOUNCE;
        }
        break;
      case HIT_DEBOUNCE:
        if (--_debounceTickCount <= 0) {
          if (_currentHitMag >= hitThreshold) {
            _hitState = HIT_HARD_DETECTED;
          } else {
            _hitDetected = false;
            _hardHitDetected = false;
            _hitState = HIT_NOT_DETECTED;
          }
        }
        break;
    }
  }

  void calculateAccMagnitude(List<double> acc) {
    _currentHitMag = pow(acc[0], 2) + pow(acc[1], 2) + pow(acc[2], 2);
  }

  void updateHardestHit() {
    if (_currentHitMag > _highG_sq) {
      _highG = sqrt(_currentHitMag);
      _highG_sq = _currentHitMag;
      _newHighG = true;
    }
  }

  bool hitDetected() {
    return _hitDetected;
  }

  bool hardHitDetected() {
    return _hardHitDetected;
  }

  bool newHighG() {
    return _newHighG;
  }

  double getHighG() {
    return _highG;
  }

  void clearNewHighG() {
    _newHighG = false;
  }

  void resetHighG() {
    _highG = 0.0;
    _highG_sq = 0.0;
  }

  void clearHitDetected() {
    _hitDetected = false;
  }

  void clearHardHitDetected() {
    _hardHitDetected = false;
  }
}
