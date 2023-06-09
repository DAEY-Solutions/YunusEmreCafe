class Kasse{
  double saldo;

  Kasse({
    required this.saldo
});

  double addSaldo(double change){
    saldo = saldo + change;
    return saldo;
  }
}