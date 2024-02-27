[1mdiff --git a/lib/helper/helper_functions.dart b/lib/helper/helper_functions.dart[m
[1mindex b883428..b3f9a02 100644[m
[1m--- a/lib/helper/helper_functions.dart[m
[1m+++ b/lib/helper/helper_functions.dart[m
[36m@@ -13,4 +13,23 @@[m [mString formatAmount(double amount){[m
 [m
 int calculateMonthCount(int startYear, startMonth, currentYear, currentMonth){[m
   return (currentYear-startYear)  *12 + currentMonth-startMonth + 1;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mString getCurrentMonthName(){[m
[32m+[m[32m  DateTime now = DateTime.now();[m
[32m+[m[32m  List<String> l = [[m
[32m+[m[32m      "OCK",[m
[32m+[m[32m      "ŞBT",[m
[32m+[m[32m      "MRT",[m
[32m+[m[32m      "NSN",[m
[32m+[m[32m      "MYS",[m
[32m+[m[32m      "HZR",[m
[32m+[m[32m      "TMZ",[m
[32m+[m[32m      "AUG",[m
[32m+[m[32m      "EYL",[m
[32m+[m[32m      "EKM",[m
[32m+[m[32m      "KSM",[m
[32m+[m[32m      "ARL"[m
[32m+[m[32m  ];[m
[32m+[m[32m  return l[now.month - 1];[m
 }[m
\ No newline at end of file[m
[1mdiff --git a/lib/pages/home_page.dart b/lib/pages/home_page.dart[m
[1mindex 15f3233..47af573 100644[m
[1m--- a/lib/pages/home_page.dart[m
[1m+++ b/lib/pages/home_page.dart[m
[36m@@ -127,7 +127,13 @@[m [mclass _HomePageState extends State<HomePage> {[m
                   future: _calculateCurrentMonthTotal,[m
                   builder: (context, snapshot){[m
                     if(snapshot.connectionState == ConnectionState.done){[m
[31m-                      return Center(child: Text('${snapshot.data!.toStringAsFixed(2)} ₺'));[m
[32m+[m[32m                      return Row([m
[32m+[m[32m                        mainAxisAlignment: MainAxisAlignment.spaceBetween,[m
[32m+[m[32m                        children: [[m
[32m+[m[32m                          Text('${snapshot.data!.toStringAsFixed(2)} ₺'),[m
[32m+[m[32m                          Text(getCurrentMonthName())[m
[32m+[m[32m                        ],[m
[32m+[m[32m                      );[m
                     }[m
                     return const Text('loading..');[m
                   },[m
