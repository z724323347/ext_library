import 'package:ext_library/lib_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:washine/app/utils/extensions.dart';
import 'package:washine/ui/expandable_text.dart';
import '../logs_ctrl.dart';

class LogDebugPage extends StatefulWidget {
  const LogDebugPage({Key? key}) : super(key: key);

  static List<String> data = [];

  @override
  State createState() => _LogDebugPageState();
}

class _LogDebugPageState extends State<LogDebugPage> {
  final ctrl = DevLogsEventSer.to;
  bool fold = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(
            () => ctrl.listLog.isEmpty
                ? Center(
                    child: Text('Empty', style: TextStyle(color: Colors.red)))
                : fold
                    ? buildStyle1()
                    : buildStyle2(),
          ),
          buildTag().positioned(top: 10, right: 10),
        ],
      ),
    );
  }

  Widget buildTag() {
    return GestureDetector(
      onTap: () {
        fold = !fold;
        setState(() {});
      },
      child: Container(
        height: 40.w,
        width: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
        ),
        child: Icon(
          fold ? Icons.view_quilt_rounded : Icons.vertical_split_rounded,
          color: Colors.white,
          size: 20,
        ),
        // child: Text('↕', style: style()),
      ),
    );
  }

  Widget buildStyle1() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: ctrl.listLog.length,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: false,
      itemBuilder: (_, int index) {
        final item = ctrl.listLog[index];
        return ExpansionTile(
          title: Text(
            '${item.time} => ${item.breakpoint.safety}',
            style: TextStyle(color: Colors.red, fontSize: 12),
            maxLines: 2,
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.only(left: 20, right: 10),
          children: [
            Text(
              '输出时间:  ${item.time}',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              '对应文件:  ${item.file}',
              style: TextStyle(color: Colors.black87, fontSize: 12),
              maxLines: 3,
            ),
            const SizedBox(height: 5),
            SelectableText(
              '输出日志:  ${item.msg}'.fixLines,
              style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
              // maxLines: 99,
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget buildStyle2() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: ctrl.listLog.length,
      itemBuilder: (_, int index) {
        final item = ctrl.listLog[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: .5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30.w,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 4.w),
                color: Colors.purple,
                child: Text(
                  index.limitMax(999),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: SelectableText.rich(
                  TextSpan(
                    text: '时间:  ${item.time} =>${item.breakpoint.safety} \n',
                    children: [
                      TextSpan(
                        text: '文件:  ${item.file} \n',
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                      WidgetSpan(
                        child: ExpandableText(
                          text: '日志:  ${item.msg}'.fixLines,
                          textStyle:
                              TextStyle(color: Colors.lightBlue, fontSize: 12),
                          buttonTextStyle: TextStyle(fontSize: 12),
                          initLength: 300,
                          expanded: (v) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                      color: Colors.red, fontSize: 12, height: 21 / 14),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
