String convert64(int x) {
  return '${getShulkerBox(x) == 0 ? '' : '${getShulkerBox(x)}盒'}${getStack(x) == 0 ? '' : '${getStack(x)}组'}${x % 64}个';
}

String convert1(int x) {
  return '${x ~/ 27 == 0 ? '' : '${x ~/ 27}盒'}${x % 27}个';
}

int getShulkerBox(int x) {
  return x ~/ 1728;
}

int getStack(int x) {
  return (x - getShulkerBox(x) * 1728) ~/ 64;
}

Function(int) convert([bool single = false]) {
  return single ? convert1 : convert64;
}
