import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../data/model/model.dart';
import '../../features/history/history.dart';
import '../extensions/transaction_view.dart';

// Extension class for point records list. Will use in features/settings/view/history_view.dart
extension View on Records {
  Widget getHistoryTile({
    required BuildContext context,
    required HistoryState state,
    // required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Container(
            color: colorTransparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: colorTransparent,
                  child: _buildTransactionList(context, state, transaction),
                ),
                // ),
              ],
            ),
          ),
        ),
        // SizedBox(height: height * 0.01),
      ],
    );
  }

  Widget _buildTransactionList(BuildContext context, HistoryState state,
      List<Transaction>? transaction) {
    if (transaction != null) {
      var transactionHistoryTiles = [];

      transactionHistoryTiles = transaction
          .map((transactionList) => transactionList.getTransactionTile(
                context: context,
              ))
          .toList(growable: false);

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: transaction.length,
        itemBuilder: (context, index) {
          return transactionHistoryTiles[index];
        },
      );
    }

    return Container();
  }
}
