import 'package:flutter/foundation.dart';

enum TxIconType { store, person, shopee, mytelkomsel }

class TransactionItem {
  final String id;
  final TxIconType iconType;
  final String name;
  final String category;
  final String date;
  final String amount;
  final bool isPositive;
  final String amountValue;
  final String? toName;
  final String? toLocation;
  final String? acquirer;
  final String? txNumber;
  final String? refNumber;
  final String? terminalId;

  const TransactionItem({
    required this.id,
    required this.iconType,
    required this.name,
    required this.category,
    required this.date,
    required this.amount,
    required this.isPositive,
    required this.amountValue,
    this.toName,
    this.toLocation,
    this.acquirer,
    this.txNumber,
    this.refNumber,
    this.terminalId,
  });
}

final _defaultTransactions = <TransactionItem>[
  TransactionItem(
    id: '1',
    iconType: TxIconType.mytelkomsel,
    name: 'MyTelkomsel Apps',
    category: 'Pembayaran',
    date: '15 Mei 2026, 17:00',
    amount: '-Rp 5.000',
    isPositive: false,
    amountValue: '5.000',
    toName: 'MyTelkomsel Apps',
    toLocation: 'JAKARTA SELATAN',
    acquirer: 'OVO',
    txNumber: '20260515170034567891234567',
    refNumber: '010000AB1C2D',
    terminalId: 'FYFKb6DXOqVbnJX6',
  ),
  TransactionItem(
    id: '2',
    iconType: TxIconType.mytelkomsel,
    name: 'MyTelkomsel Apps',
    category: 'Pembayaran',
    date: '15 Mei 2026, 16:59',
    amount: '-Rp 30.000',
    isPositive: false,
    amountValue: '30.000',
    toName: 'MyTelkomsel Apps',
    toLocation: 'JAKARTA SELATAN',
    acquirer: 'OVO',
    txNumber: '20260515165934567891234567',
    refNumber: '010000CD3E4F',
    terminalId: 'FYFKb6DXOqVbnJX6',
  ),
  TransactionItem(
    id: '3',
    iconType: TxIconType.mytelkomsel,
    name: 'MyTelkomsel Apps',
    category: 'Pembayaran',
    date: '15 Mei 2026, 16:57',
    amount: '-Rp 150.000',
    isPositive: false,
    amountValue: '150.000',
    toName: 'MyTelkomsel Apps',
    toLocation: 'JAKARTA SELATAN',
    acquirer: 'OVO',
    txNumber: '20260515165734567891234567',
    refNumber: '010000EF5G6H',
    terminalId: 'FYFKb6DXOqVbnJX6',
  ),
  TransactionItem(
    id: '4',
    iconType: TxIconType.person,
    name: 'Ainilmardiah',
    category: 'Transfer',
    date: '15 Mei 2026, 11:42',
    amount: '+Rp 750.000',
    isPositive: true,
    amountValue: '750.000',
    toName: 'Anla Harpanda',
    toLocation: 'SeaBank',
    acquirer: '-',
    txNumber: '20260515114234567891234567',
    refNumber: '010000GH7I8J',
    terminalId: '-',
  ),
  TransactionItem(
    id: '5',
    iconType: TxIconType.shopee,
    name: 'Shopee',
    category: 'Pembayaran',
    date: '14 Mei 2026, 22:10',
    amount: '-Rp 113.700',
    isPositive: false,
    amountValue: '113.700',
    toName: 'Shopee',
    toLocation: 'JAKARTA',
    acquirer: 'SeaBank',
    txNumber: '20260514221034567891234567',
    refNumber: '010000IJ9K0L',
    terminalId: 'ShopeeTerminal01',
  ),
  TransactionItem(
    id: '6',
    iconType: TxIconType.person,
    name: 'Anla Harpanda',
    category: 'Transfer',
    date: '14 Mei 2026, 12:34',
    amount: '-Rp 72.200',
    isPositive: false,
    amountValue: '72.200',
    toName: 'Anla Harpanda',
    toLocation: 'BANK NAGARI',
    acquirer: '-',
    txNumber: '20260514123434567891234567',
    refNumber: '010000KL1M2N',
    terminalId: '-',
  ),
  TransactionItem(
    id: '7',
    iconType: TxIconType.store,
    name: 'Ayam Geprek Ayu Kuline...',
    category: 'Pembayaran',
    date: '13 Mei 2026, 13:14',
    amount: '-Rp 23.000',
    isPositive: false,
    amountValue: '23.000',
    toName: 'Ayam Geprek Ayu Kuline...',
    toLocation: 'Padang',
    acquirer: 'OVO',
    txNumber: '20260513435058977541299962',
    refNumber: '010000FY4F4L',
    terminalId: 'FYFKb6DXOqVbnJX6',
  ),
];

final transactionStore = ValueNotifier<List<TransactionItem>>(List.from(_defaultTransactions));

void addTransaction(TransactionItem tx) {
  transactionStore.value = [tx, ...transactionStore.value];
}
