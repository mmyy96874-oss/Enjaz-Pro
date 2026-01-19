import 'package:flutter/material.dart';
import 'package:enjaz_pro/view/Super_Admin/Project_DataSurs.dart';

import 'Manager_DataSurs.dart';
import 'Manager_model.dart';
import 'Manager_viwe.dart';
import 'Project_Viwe.dart';


class Super_Admin extends StatefulWidget {
  const Super_Admin({super.key});

  @override
  State<Super_Admin> createState() => _Super_AdminState();
}

class _Super_AdminState extends State<Super_Admin> {

  // دالة بناء أزرار الفلترة العلوي
  Widget _buildFilterButton(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2D62ED) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDataRow(String name, String team, String supervisor, String status, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5))),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Expanded(flex: 2, child: Text(team, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))),
          Expanded(flex: 2, child: Text(supervisor, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
              child: Text(status, textAlign: TextAlign.center, style: TextStyle(color: text, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int count= 0;
  int accepted =0;
  int reject =0 ;

  final projectList = ProjectRepository.projects;
  List<Supervisor> list = SupervisorProvider.supervisors;
  final nameController = TextEditingController();
  final specController = TextEditingController();
  final countController = TextEditingController();

  final List<Map<String, String>> projects = [
    {
      "name": "نظام إدارة المكتبة",
      "team": "أحمد محمد",
      "supervisor": "د. خالد العمري",
      "status": "تنفيذ",
      "color": "blue"
    },
    {
      "name": "تطبيق التجارة الإلكترونية",
      "team": "فاطمة علي",
      "supervisor": "د. سارة أحمد",
      "status": "تخطيط",
      "color": "green"
    },
    {
      "name": "نظام إدارة المستشفيات",
      "team": "فريق الابتكار",
      "supervisor": "-",
      "status": "مراجعة",
      "color": "yellow"
    },
  ];

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text("إضافة مشرف"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(hintText: "الاسم")),
              TextField(controller: specController, decoration: InputDecoration(hintText: "التخصص")),
              TextField(controller: countController, decoration: InputDecoration(hintText: "عدد المشاريع"), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
            ElevatedButton(
                onPressed: () {
                  // هنا نضع كود الحفظ
                  setState(() {
                    SupervisorProvider.supervisors.add(Supervisor(
                      name: nameController.text,
                      specialty: specController.text,
                      projectCount: int.tryParse(countController.text) ?? 0,
                    ));
                  });
                  nameController.clear();
                  specController.clear();
                  countController.clear();
                  Navigator.pop(context);
                },
                child: Text("حفظ")
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Scaffold يجب أن يكون هو الـ Widget الأول في الـ return
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text(" لوحة التحكم المسؤل",style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.lightBlueAccent,
          centerTitle: true,
          leading: IconButton(onPressed: () {

          }, icon: Icon(Icons.face,color: Colors.purple,size: 30,)),
          actions: [
            Container(

              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15),


              ),
              child: Row(
                children: [
                  IconButton(onPressed: () {

                  }, icon: Icon(Icons.exit_to_app,color: Colors.purple,)
                  ),
                  Text(" تسجيل خروج ",style: TextStyle(fontSize: 10),),
                ],
              ),
            )

          ],

        ),
        body: ListView(
          // shrinkWrap: true, // مهم جداً لمنع خطأ Unbounded Height
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.timelapse,size: 40,color: Colors.deepOrange,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${reject}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("قيد المراجعة",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 10,),

                        Container(
                          width: 150,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.check_circle,size: 40,color: Colors.green,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${accepted}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("مقبول",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),



                      ],
                    ),

                    Container(height: 10,),

                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.settings_outlined,size: 40,color: Colors.blue,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${count}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("قيد التنفيذ",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 10,),

                        Container(
                          width: 150,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.emoji_events,size: 40,color: Colors.purpleAccent,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${count}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("منتهي",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),

                  ],
                ),
              ),
            ),

            // عرض الطلبات..........................

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black,width: 1),
                    color: Colors.lightBlueAccent
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.purple
                          ),
                          child: Column(
                            children: [
                              MaterialButton(onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectListScreen(),));
                              },child: Text('عرض'),),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.sticky_note_2_outlined,size: 35,color: Colors.deepOrangeAccent,),
                            Container(width: 10,),
                            Text(
                              "الطلبات الجديده ",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      // التعديل هنا: أزلنا Expanded وأضفنا shrinkWrap و physics
                      ListView.builder(
                        shrinkWrap: true, // يجعل القائمة تأخذ حجم عناصرها فقط
                        physics: NeverScrollableScrollPhysics(), // يمنع القائمة من التمرير بشكل مستقل لأن الأب يمرر
                        itemCount: projectList.length,
                        itemBuilder: (context, index) {
                          final project = projectList[index];

                          return Column(
                            children: [
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                elevation: 2,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(Icons.folder, color: Colors.white),
                                  ),
                                  title: Text(
                                    project.title,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(project.description),
                                      SizedBox(height: 5),
                                      Text(
                                        "التاريخ: ${project.date}",
                                        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                                      ),
                                      Container(height: 10,),
                                      Row(
                                        children: [
                                          MaterialButton(

                                            onPressed: () {
                                              setState(() {
                                                accepted++;
                                                showDialog(context: context, builder: (context) {
                                                  return AlertDialog(
                                                    title: Text("تم قبول طلبك "),
                                                    content: Text("اضغط لاضافة مشرف لمشروعك"),
                                                    actions: [

                                                      //
                                                      TextButton(onPressed: () {
                                                        scaffoldKey.currentState!.showBottomSheet((context) => Directionality(
                                                          textDirection: TextDirection.rtl,
                                                          child: ListView.builder(
                                                            itemCount: list.length,
                                                            itemBuilder: (context, index) {
                                                              final supervisor = list[index];
                                                              return Card(
                                                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                child: ListTile(
                                                                  contentPadding: EdgeInsets.all(12),
                                                                  leading: CircleAvatar(
                                                                    radius: 30,
                                                                    backgroundColor: Colors.purple[50],
                                                                    child: Icon(Icons.person, color: Colors.purple),
                                                                  ),
                                                                  title: Text(supervisor.name, style: TextStyle(fontWeight: FontWeight.bold)),

                                                                  trailing: Container(
                                                                    padding: EdgeInsets.all(8),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.blue[50],
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),

                                                                    //

                                                                    child:TextButton(onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    }, child: Text("اختيار")),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        );

                                                      }, child: Text("اضغط لاختيار مشرف")),
                                                    ],

                                                  );

                                                },
                                                );

                                              });

                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.green,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("قبول"),
                                                )
                                            ),
                                          ),
                                          MaterialButton(onPressed: () {
                                            setState(() {
                                              reject++;
                                              showBottomSheet(context: context, builder: (context) {
                                                return AlertDialog(
                                                  title: Text("مرفوض"),
                                                  content: Text("بسبب تاخر تسليم المتطلبات"),
                                                  backgroundColor: Colors.deepOrange,
                                                  actions: [
                                                    TextButton(onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }, child: Text("الغاء"))
                                                  ],

                                                );
                                              },);
                                            });

                                          },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.deepOrange,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("رفض"),
                                                )),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // قائمه المشرفين...........................................
            Container(height: 10,),


            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width: 1),
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // زر الإضافة البنفسجي
                            ElevatedButton.icon(
                              onPressed: () => _showAddDialog(),
                              icon: Icon(Icons.add, color: Colors.white),
                              label: Text("إضافة", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[600],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),

                            MaterialButton(onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupervisorScreen(),));

                            },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(" عرض"),
                                  )),
                            ),

                            // العنوان والأيقونة
                            Row(
                              children: [
                                Text("إدارة المشرفين",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.group, color: Colors.purple),
                              ],
                            ),

                          ],
                        ),
                      ),
                      // قائمة المشرفين
                      ListView.builder(
                        shrinkWrap: true, // مهم جداً داخل Column
                        physics: NeverScrollableScrollPhysics(), // لمنع التمرير المزدوج
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final supervisor = list[index];
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              elevation: 0, // كما في الصورة بدون ظل قوي
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12),
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.purple[50],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.person, color: Colors.purple, size: 35),
                                ),
                                title: Text(supervisor.name,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                subtitle: Text(supervisor.specialty,
                                    style: TextStyle(color: Colors.grey[600])),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("${supervisor.projectCount} مشاريع",
                                      style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 'طلبات التمدد.............................................'
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black,width: 1),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.hourglass_bottom,size: 35,color: Colors.deepOrangeAccent,),
                          Container(width: 10,),
                          Text("طلبات التمدد",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),

                        ),

                        child: Column(
                          children: [
                            ListTile(
                              title: Text("نظام ادارة المكتبة",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                              leading: Icon(Icons.propane,color: Colors.blue,),
                              subtitle: Text("السبب : تاخر في استلام المتطلبات"),
                              trailing: Text("المدة:15 يوم"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  MaterialButton(

                                    onPressed: () {
                                      setState(() {
                                        accepted++;

                                      });

                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.green,



                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("قبول"),
                                        )
                                    ),
                                  ),
                                  MaterialButton(onPressed: () {
                                    setState(() {
                                      reject++;
                                    });

                                  },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.deepOrange,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("رفض"),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),


                  ],
                ),

              ),
            ),

            // التقارير النهائية........................................................
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(height: 10,),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(onPressed: () {

                                  }, icon: Icon(Icons.picture_as_pdf,size: 40,color: Colors.white,),)
                              ),

                              Container(height: 10,),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("تقرير المشاريع",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 10,),

                        Container(
                          width: 150,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(width: 10,),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(onPressed: () {

                                  }, icon: Icon(Icons.fork_right_rounded,size: 40,color: Colors.white,),)
                              ),

                              Container(height:  10,),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("تقرير الاداء",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),



                      ],
                    ),

                    Container(height: 10,),

                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(onPressed: () {

                                  }, icon: Icon(Icons.people_alt_outlined,size: 40,color: Colors.white,))
                              ),
                              Container(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("تقارير المشرفين",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 10,),

                        Container(
                          width: 150,
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(onPressed: () {

                                  }, icon:Icon(Icons.remove_circle_sharp,size: 40,color: Colors.white,))
                              ),
                              Container(height: 10,),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("المشاريع المتوقفة",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),

                  ],
                ),
              ),
            ),

            // القائمه الاخيره..................................................
            // هذا الكونتير هو العنصر الأول والوحيد المطلوب وضعه في الـ children
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // هام جداً لتجنب خطأ الحجم
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. العنوان
                  const Row(
                    children: [
                      Icon(Icons.list_alt, color: Color(0xFF34495E), size: 22),
                      SizedBox(width: 8),
                      Text(
                        "جميع المشاريع",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. أزرار الفلترة (استخدمنا SizedBox لتحديد ارتفاع ثابت ومنع خطأ الـ Hit Test)
                  SizedBox(
                    height: 45,
                    child: ListView( // استبدال Row بـ ListView أفقي أكثر استقراراً داخل القوائم
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterButton("الكل (152)", true),
                        _buildFilterButton("قيد المراجعة (12)", false),
                        _buildFilterButton("التخطيط (8)", false),
                        _buildFilterButton("قيد التنفيذ (20)", false),
                        _buildFilterButton("المنتهية (112)", false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 3. رأس الجدول
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 3, child: Text("اسم المشروع", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                        Expanded(flex: 2, child: Text("الفريق", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                        Expanded(flex: 2, child: Text("المشرف", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                        Expanded(flex: 2, child: Text("الحالة", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                      ],
                    ),
                  ),

                  // 4. صفوف البيانات (بدون ListView داخلية لمنع التعارض)
                  _buildDataRow("نظام إدارة المكتبة", "أحمد محمد", "د. خالد العمري", "تنفيذ", const Color(0xFFE3F2FD), Colors.blue),
                  _buildDataRow("تطبيق التجارة الإلكترونية", "فاطمة علي", "د. سارة أحمد", "تخطيط", const Color(0xFFE8F5E9), Colors.green),
                  _buildDataRow("نظام إدارة المستشفيات", "فريق الابتكار", "-", "مراجعة", const Color(0xFFFFF9C4), Colors.orange),
                ],
              ),
            ),
            Container(height: 20,),








          ],
        )
    );
  }
}