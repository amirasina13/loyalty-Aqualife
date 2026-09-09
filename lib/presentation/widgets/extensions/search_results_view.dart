import 'package:flutter/material.dart';

import '../../../data/api/models/models.dart';
import '../independent/cache_network_image.dart';

extension View on SearchListsModel {
  Widget getSearchList({
    required BuildContext context,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(
              width: width * 0.26,
              height: width * 0.26,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: image != null
                    ? CachedImage(
                        imageUrl: image!,
                        boxFit: BoxFit.cover,
                      )
                    : Image(
                        image: AssetImage(
                            'assets/icons/outlet/no_merchant_outlet.png'),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: width * 0.26,
              child: Text(
                name ?? "",
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
