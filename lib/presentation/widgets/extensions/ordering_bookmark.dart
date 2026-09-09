import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../data/model/model.dart';
import '../independent/independent.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on MerchantBookmark {
  Widget getMerchantBookmarkListTile({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback onTapBookmark,
    // required SlidableController controllerSlider,
    // required bool past,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // return Builder(
    //   builder: (context) {
    return InkWell(
      onTap: onTap,
      child: Slidable(
        key: Key(id.toString()),
        endActionPane: ActionPane(
          motion: const ScrollMotion(), extentRatio: 0.2,
          // dismissible: DismissiblePane(onDismissed: () {}),
          // A pane can dismiss the Slidable.
          // All actions are defined in the children parameter.
          children: [
            // SlidableAction(
            //   onPressed: (_) => onTapBookmark,
            //   backgroundColor: colorBlack.withOpacity(0.1),
            //   foregroundColor: mainColor,
            //   // icon: Icons.save,
            //   label: 'Unfollow',
            // ),
            InkWell(
              onTap: onTapBookmark,
              child: Container(
                height: height,
                width: width * 0.2,
                color: colorBlack.withValues(alpha: 0.1),
                alignment: Alignment.center,
                child: Text(
                  'Unfollow',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Builder(
            //   builder: (cont) {
            //     return ElevatedButton(
            //       onPressed: () {
            //         Slidable.of(cont)!.close();
            //       },
            //       style: ElevatedButton.styleFrom(
            //         shape: CircleBorder(),
            //         backgroundColor: Colors.red,
            //         padding: EdgeInsets.all(10),
            //       ),
            //       child: const Icon(
            //         Icons.delete,
            //         color: Colors.white,
            //         size: 25,
            //       ),
            //     );
            //   },
            // ),
            // Expanded(
            //   flex: 1,
            //   child: Card(
            //     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Column(
            //       children: [
            //         Expanded(
            //           child: InkWell(
            //             onTap: onTapBookmark,
            //             child: Container(
            //               width: double.infinity,
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: const [
            //                   Icon(Icons.delete, color: Colors.red),
            //                   Text(
            //                     'Delete',
            //                     style:
            //                         TextStyle(color: Colors.red, fontSize: 16),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
        child: LayoutBuilder(
          builder: (contextFromLayoutBuilder, constraints) {
            return
                // GestureDetector(
                //   onTap: () {
                //     // final slidable = Slidable.of(contextFromLayoutBuilder);
                //     // slidable!.closing;
                //     // slidable.openEndActionPane(
                //     //   duration: const Duration(milliseconds: 500),
                //     //   curve: Curves.decelerate,
                //     // );
                //     Slidable.of(contextFromLayoutBuilder)!.close();

                //     // print('SLIDABLE: ${slidable!.isLeftToRight}');
                //   },
                //   child:
                Container(
              height: height / 8,
              margin: EdgeInsets.symmetric(
                  vertical: 5, horizontal: marginHorizontal),
              child: Row(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: colorBabyBlue,
                            border: Border.all(color: colorPinGrey),
                          ),
                          // )
                          child: ClipOval(
                            child: CachedImage(
                              imageUrl: image!,
                              // colorFilter: ColorFilter.mode(
                              //   colorUsedGray,
                              //   BlendMode.color,
                              // ),
                            ),
                          ),
                        ),
                      ),
                      isMuslim == 1
                          ? Positioned(
                              right: 18,
                              top: 18,
                              child: HalalWidget(
                                muslimCategory: muslimCategory!,
                                isCircle: true,
                                width: width * 0.04,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      // padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: colorTransparent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // height: height * 0.03,
                            // padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.topLeft,
                            // color: AppColors.deepYellow,
                            child: Text(
                              name!,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                color: colorBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            // height: height * 0.062,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.topLeft,
                            color: colorTransparent,
                            child: Text(
                              desc!,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: colorTextGrey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // ),
            );
          },
        ),
      ),
    );
    // },
    // child: InkWell(
    //   onTap: onTap,
    //   child: Slidable(
    //     // key: const ValueKey(0),
    //     endActionPane: ActionPane(
    //       motion: const StretchMotion(), extentRatio: 0.25,
    //       // dismissible: DismissiblePane(onDismissed: () {}),
    //       // A pane can dismiss the Slidable.
    //       // All actions are defined in the children parameter.
    //       children: [
    //         SlidableAction(
    //           onPressed: (_) => onTapBookmark,
    //           backgroundColor: colorBlack.withOpacity(0.1),
    //           foregroundColor: mainColor,
    //           // icon: Icons.save,
    //           label: 'Unfollow',
    //         ),
    //         Builder(
    //           builder: (cont) {
    //             return ElevatedButton(
    //               onPressed: () {
    //                 Slidable.of(cont)!.close();
    //               },
    //               style: ElevatedButton.styleFrom(
    //                 shape: CircleBorder(),
    //                 backgroundColor: Colors.red,
    //                 padding: EdgeInsets.all(10),
    //               ),
    //               child: const Icon(
    //                 Icons.delete,
    //                 color: Colors.white,
    //                 size: 25,
    //               ),
    //             );
    //           },
    //         ),
    //         // Expanded(
    //         //   flex: 1,
    //         //   child: Card(
    //         //     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    //         //     shape: RoundedRectangleBorder(
    //         //       borderRadius: BorderRadius.circular(10),
    //         //     ),
    //         //     child: Column(
    //         //       children: [
    //         //         Expanded(
    //         //           child: InkWell(
    //         //             onTap: onTapBookmark,
    //         //             child: Container(
    //         //               width: double.infinity,
    //         //               child: Column(
    //         //                 mainAxisAlignment: MainAxisAlignment.center,
    //         //                 children: const [
    //         //                   Icon(Icons.delete, color: Colors.red),
    //         //                   Text(
    //         //                     'Delete',
    //         //                     style:
    //         //                         TextStyle(color: Colors.red, fontSize: 16),
    //         //                   ),
    //         //                 ],
    //         //               ),
    //         //             ),
    //         //           ),
    //         //         ),
    //         //       ],
    //         //     ),
    //         //   ),
    //         // ),
    //       ],
    //     ),
    //     child: LayoutBuilder(builder: (contextFromLayoutBuilder, constraints) {
    //       return
    //           // GestureDetector(
    //           //   onTap: () {
    //           //     // final slidable = Slidable.of(contextFromLayoutBuilder);
    //           //     // slidable!.closing;
    //           //     // slidable.openEndActionPane(
    //           //     //   duration: const Duration(milliseconds: 500),
    //           //     //   curve: Curves.decelerate,
    //           //     // );
    //           //     Slidable.of(contextFromLayoutBuilder)!.close();

    //           //     // print('SLIDABLE: ${slidable!.isLeftToRight}');
    //           //   },
    //           //   child:
    //           Container(
    //         height: height / 8,
    //         margin:
    //             EdgeInsets.symmetric(vertical: 5, horizontal: marginHorizontal),
    //         child: Row(
    //           children: [
    //             Stack(
    //               children: [
    //                 AspectRatio(
    //                   aspectRatio: 1 / 1,
    //                   child: Container(
    //                     margin: EdgeInsets.all(5),
    //                     decoration: BoxDecoration(
    //                       shape: BoxShape.circle,
    //                       // color: colorBabyBlue,
    //                       border: Border.all(color: colorPinGrey),
    //                     ),
    //                     // )
    //                     child: ClipOval(
    //                       child: CachedImage(
    //                         imageUrl: image!,
    //                         // colorFilter: ColorFilter.mode(
    //                         //   colorUsedGray,
    //                         //   BlendMode.color,
    //                         // ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 isMuslim == 1
    //                     ? Positioned(
    //                         right: 18,
    //                         top: 18,
    //                         child: HalalWidget(
    //                           muslimCategory: muslimCategory!,
    //                           isCircle: true,
    //                           width: width * 0.04,
    //                         ),
    //                       )
    //                     : SizedBox(),
    //               ],
    //             ),
    //             Flexible(
    //               child: Container(
    //                 margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
    //                 // padding: EdgeInsets.symmetric(vertical: 5),
    //                 decoration: BoxDecoration(
    //                   color: colorTransparent,
    //                   borderRadius: BorderRadius.only(
    //                     topRight: Radius.circular(20),
    //                     bottomRight: Radius.circular(20),
    //                   ),
    //                 ),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   // crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Container(
    //                       // height: height * 0.03,
    //                       // padding: EdgeInsets.symmetric(vertical: 5),
    //                       alignment: Alignment.topLeft,
    //                       // color: AppColors.deepYellow,
    //                       child: Text(
    //                         name!,
    //                         style: TextStyle(
    //                           fontSize: 12,
    //                           fontFamily: 'Inter',
    //                           fontWeight: FontWeight.w600,
    //                           color: colorBlack,
    //                         ),
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ),
    //                     Container(
    //                       // height: height * 0.062,
    //                       padding: EdgeInsets.symmetric(vertical: 5),
    //                       alignment: Alignment.topLeft,
    //                       color: colorTransparent,
    //                       child: Text(
    //                         desc!,
    //                         style: TextStyle(
    //                           fontSize: 11,
    //                           fontFamily: 'Inter',
    //                           fontWeight: FontWeight.w500,
    //                           color: colorTextGrey,
    //                         ),
    //                         maxLines: 3,
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         // ),
    //       );
    //     }),
    //     // ),
    //     // child: SlideMenu(
    //     //   // isClicked: Storage().isClicked = true;,
    //     //   menuItems: <Widget>[
    //     //     InkWell(
    //     //       onTap: onTapBookmark,
    //     //       child: Container(
    //     //         color: colorBlack.withOpacity(0.1),
    //     //         height: height / 8,
    //     //         child: Center(
    //     //           child: Text(
    //     //             'Unfollow',
    //     //             style: TextStyle(
    //     //               fontSize: 10,
    //     //               fontWeight: FontWeight.w700,
    //     //               color: mainColor,
    //     //             ),
    //     //           ),
    //     //         ),
    //     //       ),
    //     //     ),
    //     //   ],
    //     //   child: Container(
    //     //     height: height / 8,
    //     //     margin:
    //     //         EdgeInsets.symmetric(vertical: 5, horizontal: marginHorizontal),
    //     //     child: Row(
    //     //       children: [
    //     //         Stack(
    //     //           children: [
    //     //             AspectRatio(
    //     //               aspectRatio: 1 / 1,
    //     //               child: Container(
    //     //                 margin: EdgeInsets.all(5),
    //     //                 decoration: BoxDecoration(
    //     //                   shape: BoxShape.circle,
    //     //                   // color: colorBabyBlue,
    //     //                   border: Border.all(color: colorPinGrey),
    //     //                 ),
    //     //                 // )
    //     //                 child: ClipOval(
    //     //                   child: CachedImage(
    //     //                     imageUrl: image!,
    //     //                     // colorFilter: ColorFilter.mode(
    //     //                     //   colorUsedGray,
    //     //                     //   BlendMode.color,
    //     //                     // ),
    //     //                   ),
    //     //                 ),
    //     //               ),
    //     //             ),
    //     //             isMuslim == 1
    //     //                 ? Positioned(
    //     //                     right: 18,
    //     //                     top: 18,
    //     //                     child: HalalWidget(
    //     //                       muslimCategory: muslimCategory!,
    //     //                       isCircle: true,
    //     //                       width: width * 0.04,
    //     //                     ),
    //     //                   )
    //     //                 : SizedBox(),
    //     //           ],
    //     //         ),
    //     //         Flexible(
    //     //           child: Container(
    //     //             margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
    //     //             // padding: EdgeInsets.symmetric(vertical: 5),
    //     //             decoration: BoxDecoration(
    //     //               color: colorTransparent,
    //     //               borderRadius: BorderRadius.only(
    //     //                 topRight: Radius.circular(20),
    //     //                 bottomRight: Radius.circular(20),
    //     //               ),
    //     //             ),
    //     //             child: Column(
    //     //               mainAxisAlignment: MainAxisAlignment.center,
    //     //               // crossAxisAlignment: CrossAxisAlignment.start,
    //     //               children: [
    //     //                 Container(
    //     //                   // height: height * 0.03,
    //     //                   // padding: EdgeInsets.symmetric(vertical: 5),
    //     //                   alignment: Alignment.topLeft,
    //     //                   // color: AppColors.deepYellow,
    //     //                   child: Text(
    //     //                     name!,
    //     //                     style: TextStyle(
    //     //                       fontSize: 12,
    //     //                       fontFamily: 'Inter',
    //     //                       fontWeight: FontWeight.w600,
    //     //                       color: colorBlack,
    //     //                     ),
    //     //                     overflow: TextOverflow.ellipsis,
    //     //                   ),
    //     //                 ),
    //     //                 Container(
    //     //                   // height: height * 0.062,
    //     //                   padding: EdgeInsets.symmetric(vertical: 5),
    //     //                   alignment: Alignment.topLeft,
    //     //                   color: colorTransparent,
    //     //                   child: Text(
    //     //                     desc!,
    //     //                     style: TextStyle(
    //     //                       fontSize: 11,
    //     //                       fontFamily: 'Inter',
    //     //                       fontWeight: FontWeight.w500,
    //     //                       color: colorTextGrey,
    //     //                     ),
    //     //                     maxLines: 3,
    //     //                     overflow: TextOverflow.ellipsis,
    //     //                   ),
    //     //                 ),
    //     //               ],
    //     //             ),
    //     //           ),
    //     //         ),
    //     //       ],
    //     //     ),
    //     //   ),
    //   ),
    // ),
    // );
  }
}
