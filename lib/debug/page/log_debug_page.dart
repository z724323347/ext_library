import 'package:ext_library/lib_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogDebugPage extends StatefulWidget {
  const LogDebugPage({Key? key}) : super(key: key);

  static List<String> data = [];

  @override
  State createState() => _LogDebugPageState();
}

class _LogDebugPageState extends State<LogDebugPage> {
  final ctrl = DevLogsEventSer.to;
  late final TextEditingController _textController;

  @override
  void initState() {
    ctrl.logFilter();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(
            () => ctrl.listLog.isEmpty
                ? const Center(
                    child: Text('Empty', style: TextStyle(color: Colors.red)))
                : buildBody(),
          ),
          buildTag().positioned(top: 10, right: 10),
          filterTag().positioned(top: 60, right: 10),
        ],
      ),
    );
  }

  Widget buildBody() {
    if (ctrl.hasFilter.value) {
      return buildFilter();
    }
    return ctrl.foldUp.value ? buildStyle1() : buildStyle2();
  }

  Widget buildTag() {
    return Obx(
      () => Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Icon(
          ctrl.foldUp.value
              ? Icons.view_quilt_rounded
              : Icons.vertical_split_rounded,
          color: Colors.white,
          size: 20,
        ),
      ).onClick(onTap: () => ctrl.setStyle()),
    );
  }

  Widget filterTag() {
    return Obx(
      () => Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Icon(
          ctrl.hasFilter.value ? Icons.filter_list_off : Icons.filter_list,
          color: Colors.white,
          size: 20,
        ),
      ).onClick(onTap: () => ctrl.setFilter()),
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
            style: const TextStyle(color: Colors.red, fontSize: 12),
            maxLines: 2,
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.only(left: 20, right: 10),
          children: [
            Text(
              '输出时间:  ${item.time}',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              '对应文件:  ${item.file}',
              style: const TextStyle(color: Colors.black87, fontSize: 12),
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
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: .5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 4),
                color: Colors.white,
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
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 12),
                      ),
                      WidgetSpan(
                        child: ExpandableText(
                          text: '日志:  ${item.msg}'.fixLines,
                          textStyle: const TextStyle(
                              color: Colors.lightBlue, fontSize: 12),
                          buttonTextStyle: const TextStyle(
                              fontSize: 12, color: Colors.orange),
                          initLength: 300,
                          expanded: (v) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  style: const TextStyle(
                      color: Colors.red, fontSize: 12, height: 21 / 14),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildFilter() {
    return Column(
      children: [
        Container(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 33,
                  alignment: Alignment.centerLeft,
                  child: CupertinoTextField(
                    controller: _textController,
                    style: TextStyle(fontSize: 12),
                    padding: 5.all,
                    onSubmitted: (_) => ctrl.logFilter(text: _),
                  ),
                ),
              ),
              10.wGap,
              SizedBox(
                width: 58,
                height: 33,
                child: TextButton(
                  onPressed: () => ctrl.logFilter(text: _textController.text),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orangeAccent),
                  ),
                  child: const Text('Search', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ).clipRRect(all: 10).pOnly(left: 20, right: 80),
        Expanded(
          child: ctrl.filterLog.isEmpty
              ? Text('Filter Empty ~~~~')
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: ctrl.filterLog.length,
                  itemBuilder: (_, int index) {
                    final item = ctrl.filterLog[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300, width: .5),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 30,
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 4),
                            color: Colors.white,
                            child: Text(
                              index.limitMax(999),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child: SelectableText.rich(
                              TextSpan(
                                text:
                                    '时间:  ${item.time} =>${item.breakpoint.safety} \n',
                                children: [
                                  TextSpan(
                                    text: '文件:  ${item.file} \n',
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 12),
                                  ),
                                  WidgetSpan(
                                    child: ExpandableText(
                                      text: '日志:  ${item.msg}'.fixLines,
                                      textStyle: const TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 12),
                                      buttonTextStyle: const TextStyle(
                                          fontSize: 12, color: Colors.orange),
                                      initLength: 300,
                                      expanded: (v) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  height: 21 / 14),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        )
      ],
    );
  }
}
