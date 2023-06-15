class Kasse{
  static double saldo = 0;

  static double addSaldo(double change){
    saldo = saldo + change;
    return saldo;
  }
}