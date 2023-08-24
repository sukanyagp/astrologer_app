import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:wordpress_hindi/blocs/featured_bloc.dart';
import 'package:wordpress_hindi/blocs/latest_articles_bloc.dart';
import 'package:wordpress_hindi/blocs/popular_articles_bloc.dart';
import 'package:wordpress_hindi/blocs/tab_index_bloc.dart';
import 'package:wordpress_hindi/config/wp_config.dart';
import 'package:wordpress_hindi/pages/notifications.dart';
import 'package:wordpress_hindi/pages/search.dart';
import 'package:wordpress_hindi/services/app_service.dart';
import 'package:wordpress_hindi/utils/next_screen.dart';
import 'package:wordpress_hindi/widgets/drawer.dart';
import 'package:wordpress_hindi/widgets/tab_medium.dart';
import '../config/config.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // List<String> navBarItem = ["Top News","India","World","Finance","Health"];


  late TabController _tabController ;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Tab> _tabs = [
    Tab(
      text: "Explore".tr(),
    ),
    Tab(
      text: WpConfig.selectedCategories['1'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['2'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['3'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['4'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['5'][1],
    ),
    // Tab(
    //   text: WpConfig.selectedCategories['6'][1],
    // ),
    // Tab(
    //   text: WpConfig.selectedCategories['7'][1],
    // ),
    // Tab(
    //   text: WpConfig.selectedCategories['8'][1],
    // ),
    // Tab(
    //   text: WpConfig.selectedCategories['9'][1],
    // ),
    // Tab(
    //   text: WpConfig.selectedCategories['10'][1],
    // ),







  ];



  _fetchData () async{
    await AppService().checkInternet().then((bool? hasInternet){
      if(hasInternet != null && hasInternet == true){
        context.read<FeaturedBloc>().fetchData();
        context.read<PopularArticlesBloc>().fetchData();
        context.read<LatestArticlesBloc>().fetchData();
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      context.read<TabIndexBloc>().setTabIndex(_tabController.index);
    });
    _fetchData();
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }







  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: CustomDrawer(),
      key: scaffoldKey,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                backgroundColor: Colors.white,
                titleSpacing: 0,
                title: Image(image: AssetImage(Config.splash), height: 30,),
                leading: IconButton(
                  icon: Icon(
                    Feather.menu,
                    size: 25,
                  ),
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
                elevation: 1,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      AntDesign.search1,
                      size: 22,
                    ),
                    onPressed: () {
                      nextScreen(context, SearchPage());
                    },
                  ),

                  SizedBox(width: 3),

                  IconButton(
                    padding: EdgeInsets.only(right: 8),
                    constraints: BoxConstraints(),
                    icon: Icon(
                      AntDesign.bells,
                      size: 20,
                    ),
                    onPressed: () => nextScreen(context, Notifications()),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                // backgroundColor: Colors.black,//------



                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50) ,
                  child: Material(
                    color:Colors.black,
                    child: TabBar(
                      indicatorColor: Colors.black,
                      labelStyle: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,),
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor:Colors.white,

                      unselectedLabelColor: Colors.white,
                      isScrollable: true,
                      indicator: MD2Indicator(
                        indicatorHeight: 3,
                        // indicatorColor: Theme.of(context).primaryColor,
                        indicatorColor:Colors.redAccent.shade200,
                        indicatorSize: MD2IndicatorSize.normal,

                      ),
                      tabs: _tabs,
                    ),

                  ),
                ),
              ),




            ];
          },

          body: Builder(
            builder: (BuildContext context) {
              final innerScrollController = ScrollController();
              return TabMedium(
                sc: innerScrollController,
                tc: _tabController,
                scaffoldKey: scaffoldKey,
              );
            },
          ),
      ),

    );

  }

  @override
  bool get wantKeepAlive => true;
}
























// SliverToBoxAdapter(
//   child:  Column(
//     children: [
//       Container(
//         height: 70,
//         margin: EdgeInsets.only(top: 10),
//         // margin: const EdgeInsets.only(bottom: 30),
//         child: ListView.builder(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           physics: const BouncingScrollPhysics(),
//           itemCount:navBarItem.length,
//
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: (){
//                 print(navBarItem[index]);
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal:20,vertical: 10 ),
//                 margin: EdgeInsets.symmetric(horizontal: 5),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                     children: [
//                             Text('this is the news headline',style: TextStyle(color: Colors.red),),
//                             Text('6 hours ago',style: TextStyle(color: Colors.black),),
//                           ],
//                 )
//
//               ),
//             );
//           },
//           // separatorBuilder: (context, _) => const SizedBox(
//           //   width: 10,
//           // ),
//         ),
//       ),
//       //  Container(
//       //   height: 150,
//       //   margin: const EdgeInsets.only(bottom: 30),
//       //   child: ListView.separated(
//       //     scrollDirection: Axis.horizontal,
//       //     physics: const BouncingScrollPhysics(),
//       //     itemCount:navBarItem.length,
//       //
//       //     itemBuilder: (context, index) {
//       //       return Container(
//       //         height: 40,
//       //       color: Colors.grey,
//       //       child:Column(
//       //         children: [
//       //           Text('this is the news headline',style: TextStyle(color: Colors.red),),
//       //           Text('6 hours ago',style: TextStyle(color: Colors.red),),
//       //         ],
//       //       ),);
//       //     },
//       //     separatorBuilder: (context, _) => const SizedBox(
//       //       width: 10,
//       //     ),
//       //   ),
//       // ),
//     ],
//   ),
// )





