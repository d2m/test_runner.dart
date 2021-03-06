// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

int _partition(List array, int left, int right, int pivotIndex) {
  var pivotValue = array[pivotIndex];
  array[pivotIndex] = array[right];
  array[right] = pivotValue;
  var storeIndex = left;
  for (var i = left; i < right; i++) {
    if (array[i] < pivotValue) {
      var tmp = array[i];
      array[i] = array[storeIndex];
      array[storeIndex++] = tmp;
    }
  }
  var tmp = array[storeIndex];
  array[storeIndex] = array[right];
  array[right] = tmp;
  return storeIndex;
}

void _quickSort(List array, int left, int right) {
  if (left < right) {
    int pivotIndex = left + ((right - left) ~/ 2);
    pivotIndex = _partition(array, left, right, pivotIndex);
    _quickSort(array, left, pivotIndex - 1);
    _quickSort(array, pivotIndex + 1, right);
  }
}

List quickSort(List array) {
  _quickSort(array, 0, array.length - 1);
  return array;
}

void main() {
  useHtmlEnhancedConfiguration();
  test('QuickSort', () =>
      expect(quickSort([5, 4, 3, 2, 1]), orderedEquals([1, 2, 3, 4, 5])));
  test('Partition', () {
    List array = [3, 2, 1];
    int index = _partition(array, 0, array.length - 1, 1);
    expect(index, equals(1));
    expect(array, orderedEquals([1, 2, 3]));
  });
}
